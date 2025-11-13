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
	uid CHAR(6) PRIMARY KEY,
	headcode CHAR(4) NOT NULL,
	operator CHAR(2) NOT NULL,
	days_run TINYINT NOT NULL,
	valid_from DATE NOT NULL,
	valid_until DATE NOT NULL,
	FOREIGN KEY (operator) REFERENCES operator(atoc_code)
);

CREATE TABLE IF NOT EXISTS service_stop (
	tiploc_code CHAR(7),
	service_uid CHAR(6),
	platform VARCHAR(3),
	arrival CHAR(5) NOT NULL,
	departure CHAR(5) NOT NULL,
	position TINYINT NOT NULL,
	PRIMARY KEY (tiploc_code, service_uid),
	FOREIGN KEY (tiploc_code) REFERENCES location(tiploc_code)
);

CREATE INDEX IF NOT EXISTS svcstop_service_uid_ix ON service_stop(service_uid, position);
CREATE INDEX IF NOT EXISTS svcstop_tiploc_ix ON service_stop(tiploc_code);