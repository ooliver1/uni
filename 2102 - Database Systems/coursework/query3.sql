WITH vars AS (
  SELECT 
    'CRDFCEN' AS origin_tiploc,
    substr(CURRENT_DATE,3,2) || substr(CURRENT_DATE,6,2) || substr(CURRENT_DATE,9,2) AS yymmdd,
    substr(CURRENT_TIME,1,2) || substr(CURRENT_TIME,4,2) AS hhmm,
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

SELECT 
  service_stop.platform,
  service_stop.departure,
  station.name,
  dest_stop.arrival,
  operator.name
FROM service_stop
JOIN (
  SELECT tiploc_code, service_uid, arrival
  FROM service_stop
  WHERE tiploc_code = 'NTNG   '
) as dest_stop
ON dest_stop.service_uid = service_stop.service_uid

JOIN service
ON service.uid = service_stop.service_uid

JOIN station
ON station.tiploc_code = dest_stop.tiploc_code

JOIN operator
ON operator.atoc_code = service.operator

CROSS JOIN vars

WHERE service_stop.tiploc_code = origin_tiploc
AND service.valid_from <= yymmdd
AND service.valid_until >= yymmdd
AND service.days_run & day_mask
AND service_stop.departure >= hhmm

ORDER BY service_stop.departure
;
