WITH vars AS (
  SELECT '2201260111984552706' AS select_uid
)

SELECT
  location.name,
  service_stop.arrival,
  service_stop.departure,
  service_stop.pass,
  station.crs_code,
  station.loc_east,
  station.loc_north
 FROM service_stop

JOIN location
  ON service_stop.tiploc_code = location.tiploc_code

LEFT JOIN station
  ON service_stop.tiploc_code = station.tiploc_code

CROSS JOIN vars
  
WHERE service_uid == select_uid
ORDER BY position;