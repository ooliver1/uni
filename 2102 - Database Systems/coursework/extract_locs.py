from pathlib import Path
from typing import NamedTuple

DATA_DIR = Path("/home/oliver/Documents/NRTT/8907b6402a01d1c5b213d81b6911f058/")

SCHEDULE_FILE = DATA_DIR / "RJTTF645.MCA"


class Location(NamedTuple):
    tiploc: str
    stanox: int
    name: str | None


locations: list[Location] = []
raw: list[str] = []

with open(SCHEDULE_FILE, mode="r") as f:
    for line in f:
        if not line.startswith("TI"):
            # not a location line
            continue

        tiploc = line[2:9]
        print(tiploc)
        stanox = int(line[44:49])
        if stanox == 0:
            # skip locations with no stanox, usually bus related
            continue
        name = line[18:44].strip() or None

        locations.append(Location(
            tiploc=tiploc,
            stanox=stanox,
            name=name,
        ))
        raw.append(line)


"""
CREATE TABLE IF NOT EXISTS location (
	tiploc_code CHAR(7) PRIMARY KEY,
	stanox_code INTEGER NOT NULL,
	name VARCHAR(6)
);
"""

with open("locations.sql", mode="w") as f:
    f.write("INSERT INTO location (tiploc_code, stanox_code, name) VALUES\n")
    for i, location in enumerate(locations):
        escaped = location.name.replace("'", "''") if location.name is not None else None
        name_value = f"'{escaped}'" if location.name is not None else "NULL"
        f.write(f"('{location.tiploc}', {location.stanox}, {name_value})")
        if i < len(locations) - 1:
            f.write(",\n")
        else:
            f.write(";\n")

with open("locations.txt", mode="w") as f:
    f.writelines(raw)