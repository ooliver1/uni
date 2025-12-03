WITH vars AS (
  SELECT 
    'CRDFCEN' AS tiploc,
    substr(CURRENT_DATE,3,2) || substr(CURRENT_DATE,6,2) || substr(CURRENT_DATE,9,2) AS yymmdd,
    substr(CURRENT_TIME,1,2) || substr(CURRENT_TIME,4,2) AS hhmm,
    printf('%02d%02d',
      (CAST(substr(CURRENT_TIME,1,2) AS INTEGER) + ((CAST(substr(CURRENT_TIME,4,2) AS INTEGER) + 5) / 60)) % 24,
      (CAST(substr(CURRENT_TIME,4,2) AS INTEGER) + 5) % 60
    ) AS hhmm_plus5,
	CASE strftime('%w','now')
      WHEN '0' THEN 1<<0   -- Sun
      WHEN '1' THEN 1<<6   -- Mon
      WHEN '2' THEN 1<<5   -- Tue
      WHEN '3' THEN 1<<4   -- Wed
      WHEN '4' THEN 1<<3   -- Thu
      WHEN '5' THEN 1<<2   -- Fri
      WHEN '6' THEN 1<<1   -- Sat
    END AS day_mask
)

SELECT DISTINCT service_stop.platform, operator.name, service_stop.departure, station.name, last_stop.arrival
FROM service_stop

JOIN service ON service_stop.service_uid = service.uid

JOIN (
	SELECT service_uid, MAX(position) last_pos, arrival, tiploc_code
	FROM service_stop
	GROUP BY service_uid
) as last_stop
  ON service_stop.service_uid = last_stop.service_uid

JOIN operator
  ON service.operator = operator.atoc_code

JOIN station
  ON last_stop.tiploc_code = station.tiploc_code

CROSS JOIN vars
  
WHERE service_stop.tiploc_code == tiploc
  AND service_stop.departure BETWEEN hhmm AND hhmm_plus5
  AND service.days_run & day_mask
  AND service.valid_from <= yymmdd
  AND service.valid_until >= CAST(yymmdd AS INTEGER)
  
ORDER BY service_stop.departure