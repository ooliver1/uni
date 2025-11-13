from pathlib import Path
from re import escape
import re
from typing import NamedTuple

DATA_DIR = Path("/home/oliver/Documents/NRTT/8907b6402a01d1c5b213d81b6911f058/")

STATION_FILE = DATA_DIR / "RJTTF645.MSN"
LOCATIONS_FILE = Path("locations.sql")

valid_tiplocs = set()
tiploc_pattern = re.compile(r"\('(.{7})',")

with open(LOCATIONS_FILE, "r") as f:
    for line in f:
        m = tiploc_pattern.search(line)
        if m:
            tiploc_code = m.group(1)
            valid_tiplocs.add(tiploc_code)

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

        # if any(code in name for code in ("(CIE", "MTLK", "BUS", "COACH")):
        #     # skip these as there's little data for them
        #     continue

        # if any(name.endswith(suffix) for suffix in (" NI", " UND", " ORIGIN", " DESTINATION", " SUBWAY", " CIE")):
        #     continue

        # if tiploc.startswith("CATZ"):
        #     # skip catz tiplocs, buses etc
        #     continue

        # if tiploc in ("ANSL3  ", "CREW998", "LYDNQDF", "EFARBUS", "LONDINT", "WATRINT", "NNTNMIR", "MNCRNMM", "STCRHCR", "WLSD   "):
        #     # problematic tiplocs, no valid location in locations data
        #     continue

        if tiploc not in valid_tiplocs:
            print(f"Skipping station with invalid tiploc: {tiploc} ({name})")
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
        escaped = escape(station.name.replace("'", "''"))
        f.write(f"('{station.crs}', '{station.tiploc}', {station.ref_east}, {station.ref_north}, '{escaped}')")
        if i < len(stations) - 1:
            f.write(",\n")
        else:
            f.write(";\n")