WITH vars AS (
  SELECT
	13184 AS or_east,
	61774 AS or_north
)

SELECT
  station.crs_code,
  station.name,
  station.loc_east,
  station.loc_north,
  ROUND(
    SQRT(
      (station.loc_east - or_east)*(station.loc_east - or_east) +
      (station.loc_north - or_north)*(station.loc_north - or_north)
    ), 2
  ) AS distance
FROM station

CROSS JOIN vars

ORDER BY distance
LIMIT 5;