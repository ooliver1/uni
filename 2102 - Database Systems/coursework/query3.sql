WITH vars AS (
  SELECT 
    'CRDFCEN' AS origin_tiploc,
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

SELECT * FROM service_stop
JOIN (
  SELECT tiploc_code, service_uid, *
  FROM service_stop
  WHERE tiploc_code = 'NTNG   '
) as stop_map
ON stop_map.service_uid = service_stop.service_uid

JOIN service
ON service.uid = service_stop.service_uid

CROSS JOIN vars

WHERE service_stop.tiploc_code = origin_tiploc
AND service.valid_from <= yymmdd
AND service.valid_until >= yymmdd
AND service.days_run & day_mask
;
