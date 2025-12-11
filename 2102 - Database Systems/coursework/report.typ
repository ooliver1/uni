#show heading.where(level: 1): set text(20pt)
#show heading.where(level: 2): set text(16pt)
#show heading.where(level: 3): set text(14pt)
#show heading.where(level: 4): set text(12pt)
#set text(10pt)
#page[
  #set align(center)
  Oliver Wilkes
  
  C24057633
  === CM2102 - Database Systems
  = Portfolio Report
]

== Database Design

My database is designed as a train timetable system, which stores information about train services, stations, and the relationships between them. The relationships and example data are as follows:

#image("schema.drawio.png")

#table(
  columns: (auto, auto),
  stroke: none,
  [#image("images/loc_data.png", width: 256pt)], [#image("images/op_data.png", width: 256pt)],
  [#image("images/serv_data.png", width: 256pt)], [#image("images/serv_stop.png", width: 256pt)],
  [#image("images/stat_data.png", width: 256pt)]
)

== Database Creation

Here are my SQL scripts used to create the database schema:

```sql
CREATE TABLE IF NOT EXISTS operator (
	atoc_code CHAR(2) PRIMARY KEY,
	name VARCHAR(64) NOT NULL
);

CREATE TABLE IF NOT EXISTS location (
	tiploc_code CHAR(7) PRIMARY KEY,
	stanox_code INTEGER NOT NULL,
	name VARCHAR(6)
);

CREATE INDEX IF NOT EXISTS loc_stanox_ix ON location(stanox_code);

CREATE TABLE IF NOT EXISTS station (
	crs_code CHAR(3) NOT NULL,
	tiploc_code CHAR(7) NOT NULL,
	loc_east SMALLINT NOT NULL,
	loc_north SMALLINT NOT NULL,
	name VARCHAR(26) NOT NULL,
	PRIMARY KEY (crs_code, tiploc_code),
	FOREIGN KEY (tiploc_code) REFERENCES location(tiploc_code)
);

CREATE INDEX IF NOT EXISTS station_tiploc_ix ON station(tiploc_code);

CREATE TABLE IF NOT EXISTS service (
	uid INTEGER PRIMARY KEY,
	headcode CHAR(4) NOT NULL,
	operator CHAR(2) NOT NULL,
	days_run TINYINT NOT NULL,
	valid_from DATE NOT NULL,
	valid_until DATE NOT NULL,
	FOREIGN KEY (operator) REFERENCES operator(atoc_code)
);

CREATE INDEX IF NOT EXISTS service_valid_days_ix
ON service(valid_from, valid_until, days_run);

CREATE TABLE IF NOT EXISTS service_stop (
	service_uid INTEGER,
	position TINYINT,
	tiploc_code CHAR(7) NOT NULL,
	platform VARCHAR(3),
	arrival CHAR(5),
	departure CHAR(5),
	pass CHAR(5),
	PRIMARY KEY (service_uid, position),
	FOREIGN KEY (service_uid) REFERENCES service(uid) ON DELETE CASCADE
	FOREIGN KEY (tiploc_code) REFERENCES location(tiploc_code)
);

CREATE INDEX IF NOT EXISTS svcstop_service_uid_ix ON service_stop(service_uid, position);
CREATE INDEX IF NOT EXISTS svcstop_tiploc_ix ON service_stop(tiploc_code);
CREATE INDEX IF NOT EXISTS svcstop_tiploc_service_uid_ix
ON service_stop(tiploc_code, service_uid, position);
```

=== Insertion Statements

These are some truncated insertion statements used to populate the database with example data:

```sql
INSERT INTO location (tiploc_code, stanox_code, name) VALUES
('AACHEN ', 5, 'AACHEN'),
('ABCWM  ', 78128, 'ABERCWMBOI'),
('ABDARAR', 78102, 'ABERDARE PLATFORM 2'),
('ABDARE ', 78100, 'ABERDARE PLATFORM 1'),
...
('YTRHOND', 78008, 'YSTRAD RHONDDA'),
('YWAYNJN', 63620, 'YORK WAY NORTH JN'),
('YWAYSJN', 63621, 'YORK WAY SOUTH JUNCTION');
```

```sql
INSERT INTO operator (atoc_code, name) VALUES
('NT', 'Northern Trains'),
('AW', 'Transport for Wales'),
('CC', 'c2c'),
...
('LF', 'Grand Union Trains'),
('XJ', 'Ffestiniog Railway'),
('MV', 'Varamis Rail');
```

```sql
INSERT INTO service (uid, headcode, operator, days_run, valid_from, valid_until) VALUES
('770389487855936002', '0B00', 'AW', 1, '250518', '251207'),
('1131299455471068196', '0B00', 'AW', 1, '250518', '251207'),
('1192579618192067977', '0B00', 'AW', 1, '250518', '251207'),
...
('1754172376270541206', '0B00', 'AW', 124, '260511', '260515'),
('1197328322989852682', '1V58', 'XC', 16, '260513', '260513');
```

```sql
INSERT INTO service_stop (tiploc_code, service_uid, platform, arrival, departure, pass, position) VALUES
('HAGT   ', '770389487855936002', '3', NULL, '0855', NULL, 0),
('HRNBPK ', '770389487855936002', NULL, '0857', '0857', NULL, 1),
...
('TVSTCKJ', '1197328322989852682', NULL, NULL, NULL, NULL, 177),
('LIPSONJ', '1197328322989852682', NULL, NULL, NULL, '1843H', 178),
('PLYMTH ', '1197328322989852682', '4', '1847 ', NULL, NULL, 179);
```

```sql
INSERT INTO station (crs_code, tiploc_code, loc_east, loc_north, name) VALUES
('ABW', 'ABWD   ', 15473, 61790, 'ABBEY WOOD'),
('ABW', 'ABWDXR ', 15473, 61790, 'ABBEY WOOD EL'),
('ABE', 'ABER   ', 13148, 61870, 'ABER'),
('ACY', 'ABRCYNS', 13081, 61946, 'ABERCYNON'),
...
('YRT', 'YORTON ', 13504, 63237, 'YORTON'),
('YSM', 'YSTRADM', 13142, 61943, 'YSTRAD MYNACH'),
('YSR', 'YTRHOND', 12980, 61950, 'YSTRAD RHONDDA');
```

== Queries

=== Query 1: Upcoming Departures

My first query retrieves upcoming train departures from Cardiff Central (set as `tiploc` variable) within the next 5 minutes, along with their destination stations, arrival at the destination, platform number, and operating company. It accounts for the current day of the week and service validity dates.

#image("images/query1.png")

```sql
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
```

=== Query 2: Service Details

My second query retrieves detailed information about a specific train service (set as `select_uid` variable), including the names of all stations it stops at, arrival and departure times, pass times, CRS codes, and location coordinates.

#image("images/query2.png")

```sql
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
```

=== Query 3: Next Departures to Specific Station

My third query finds the next train departures from Cardiff Central (set as `origin_tiploc`) to Nottingham. Nottingham is hardcoded as the `CROSS JOIN` was too expensive to compute directly. This query also considers the current day of the week, service validity dates, and current time. It retrieves the platform number, departure time, destination station name, arrival time at the destination, and operating company.

#image("images/query3.png")

```sql
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

ORDER BY service_stop.departure;
```

=== Query 4: Nearest Stations

My fourth query finds the 5 nearest stations to a given location (set as `or_east` and `or_north` variables) using the Euclidean distance formula. It retrieves the CRS code, station name, location coordinates, and calculated distance.

#image("images/query4.png")

```sql
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
```

== Triggers

Both triggers use the expressive `RAISE(ROLLBACK, 'message')` statement to abort the transaction with a custom error message if the conditions are met. If nothing is changed, the `COMMIT` in the original transaction will succeed as normal.

=== Update Trigger

My first trigger `service_update_immutable` prevents updates to certain fields of the `service` table if the service is still valid in the future. This is necessary as changing these fields could lead to passengers having invalid tickets, and in the real-world, a process to handle refunds would be required.

The following SQL fails with an error, as the operator of a valid (current or future) service cannot be changed:

```sql
UPDATE service
SET operator = 'GW'
WHERE uid = 480153179574825;
```

#image("images/trigger1.png")

```sql
CREATE TRIGGER service_update_immutable
BEFORE UPDATE ON service
BEGIN
    -- Only enforce immutability for services still valid in the future
    SELECT CASE
        WHEN OLD.valid_until > strftime('%y%m%d','now')
             AND NEW.valid_until IS NOT NULL
             AND NEW.valid_until < OLD.valid_until
        THEN RAISE(ROLLBACK, 'Cannot shorten validity of a service.')
    END;

    SELECT CASE
        WHEN OLD.valid_until > strftime('%y%m%d','now')
             AND NEW.valid_from IS NOT NULL
             AND NEW.valid_from > OLD.valid_from
        THEN RAISE(ROLLBACK, 'Cannot delay start validity of a service.')
    END;

    SELECT CASE
        WHEN OLD.valid_until > strftime('%y%m%d','now')
             AND NEW.operator IS NOT NULL
        THEN RAISE(ROLLBACK, 'Cannot change operator of a service.')
    END;

    SELECT CASE
        WHEN OLD.valid_until > strftime('%y%m%d','now')
             AND NEW.days_run IS NOT NULL
        THEN RAISE(ROLLBACK, 'Cannot change valid days of an entry.')
    END;
END;
```

=== Delete Trigger

My second trigger `service_delete_immutable` prevents deletion of services that are currently valid. This is important to ensure that active services are not removed from the database, which could disrupt operations and passenger information.

The following SQL fails with an error, as the service being deleted is still valid:

```sql
DELETE FROM service
WHERE uid = 480153179574825;
```

#image("images/trigger2.png")

```sql
CREATE TRIGGER service_delete_immutable
BEFORE DELETE ON service
BEGIN
	-- Cannot delete services currently valid
	SELECT CASE
		WHEN OLD.valid_until > strftime('%y%m%d','now')
		AND OLD.valid_from < strftime('%y%m%d','now')
		THEN RAISE(ROLLBACK, 'Cannot delete a service that is still valid in the future.')
	END;
END;
```

== Live Database Considerations

In a live database system, there may be multiple asynchronous processes interacting with the database simultaneously. To prevent scenarios such as dirty reads, lost updates, and inconsistent data, databases implement transactions and locking mechanisms. Transactions ensure that a series of operations either complete entirely or not at all, maintaining data integrity. Locking mechanisms prevent concurrent access to data that is being modified, ensuring that one transaction's changes are not visible to others until it is committed. This ensures only one process can modify a particular piece of data at a time, preventing conflicts and ensuring consistency across the database.

Another challenge is deadlocks, where multiple transactions are waiting on each other to release locks, resulting in a standstill. To mitigate deadlocks, careful transaction design is essential, such as acquiring locks in a consistent order and keeping transactions short to minimize lock duration. Additionally, databases implement lock timeouts to automatically abort transactions that are waiting too long for a lock, allowing other transactions to proceed, and showing an error to the client so the transaction can be redesigned to prevent the same scenario in the future.

As the database grows, performance may become an issue. By default, queries may perform full table scans, which can be very slow for large datasets. To improve performance, indexing can be used. Indexing creates a data structure for faster lookups on frequently used columns, significantly speeding up query execution times. This however adds an overhead for write operations, as the index must be updated for every insert, update, or delete operation. Therefore, it's important to carefully choose which columns to index based on query patterns and performance requirements.

As creating and closing connections is resource-intensive, connection pooling can be implemented. Connection pooling maintains a pool of active database connections that can be reused, allowing for multiple queries to be executed, but reducing the overhead of establishing new connections.

For very large databases, partitioning can be employed. Partitioning involves dividing a large table into smaller, more manageable pieces based on certain criteria, such as date ranges or geographic locations. This can improve query performance by allowing the database to scan only relevant partitions instead of the entire table. In my database, this may involve partitioning services by region, allowing for faster queries when searching for services within a specific area.