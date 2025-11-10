from pathlib import Path
from typing import NamedTuple

DATA_DIR = Path("/home/oliver/Documents/NRTT/8907b6402a01d1c5b213d81b6911f058/")

STATION_FILE = DATA_DIR / "RJTTF645.MSN"

class Station(NamedTuple):
    name: str
    tiploc: str
    crs: str
    ref_east: int
    ref_north: int

stations: list[Station] = []

with open(STATION_FILE, mode="r") as f:
    for line in f:
        if line[0] != "A" or line[5] == " ":
            # header line
            continue

        name = line[5:31].strip()
        print(name)
        tiploc = line[36:43]
        crs = line[49:52]
        ref_east = int(line[52:57])
        ref_north = int(line[58:63])

        if "CIE" in name:
            # skip CIE stations, as they don't have locations
            continue

        stations.append(Station(
            name=name,
            tiploc=tiploc,
            crs=crs,
            ref_east=ref_east,
            ref_north=ref_north,
        ))

"""
CREATE TABLE IF NOT EXISTS station (
	crs_code CHAR(3) PRIMARY KEY,
	tiploc_code CHAR(7),
	loc_east SMALLINT NOT NULL,
	loc_north SMALLINT NOT NULL,
	name VARCHAR(26) NOT NULL,
	FOREIGN KEY (tiploc_code) REFERENCES location(tiploc_code)
);
"""

with open("stations.sql", mode="w") as f:
    f.write("INSERT INTO station (crs_code, tiploc_code, loc_east, loc_north, name) VALUES\n")
    for i, station in enumerate(stations):
        f.write(f"('{station.crs}', '{station.tiploc}', {station.ref_east}, {station.ref_north}, '{station.name}')")
        if i < len(stations) - 1:
            f.write(",\n")
        else:
            f.write(";\n")