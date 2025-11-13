from pathlib import Path
from typing import NamedTuple
import hashlib

DATA_DIR = Path("/home/oliver/Documents/NRTT/8907b6402a01d1c5b213d81b6911f058/")

SCHEDULE_FILE = DATA_DIR / "RJTTF645.MCA"


class Stop(NamedTuple):
    tiploc: str
    arrival: str | None
    departure: str | None
    platform: str | None
    pass_: str | None


class Service(NamedTuple):
    uid: str
    date_from: str
    date_to: str
    days_run: int
    headcode: str
    atoc: str
    stops: list[Stop]

    def __hash__(self) -> int:
        origin = self.stops[0].tiploc
        destination = self.stops[-1].tiploc
        data = f"{self.uid}|{self.date_from}|{self.date_to}|{origin}|{destination}"
        return int(hashlib.md5(data.encode()).hexdigest(), 16)


services: list[Service] = []
problematic_service = False

valid_locs: set[str] = set()
with open("locations.sql", mode="r") as f:
    for line in f:
        if line.startswith("INSERT INTO location "):
            continue
        parts = line.strip().strip(",").strip("();").split(", ")
        tiploc = parts[0].strip("'").strip()
        valid_locs.add(tiploc)

with open(SCHEDULE_FILE, mode="r") as f:
    current_service = None
    current_stops = []
    for line in f:
        if line.startswith("BS"):
            uid = line[3:9]
            date_from = line[9:15]
            date_to = line[15:21]
            days_run = int(line[21:28], 2)
            headcode = line[32:36]
            atoc = ""  # to be filled from BX line

            current_service = Service(
                uid=uid,
                date_from=date_from,
                date_to=date_to,
                days_run=days_run,
                headcode=headcode,
                atoc=atoc,
                stops=[],
            )
        elif line.startswith("BX") and current_service is not None:
            atoc = line[11:13].strip()
            if atoc not in ("AW", "XC", "GW"):
                # only one operator
                current_service = None
                current_stops = []
                continue
            current_service = current_service._replace(atoc=atoc)
        elif line.startswith("LO"):
            tiploc = line[2:10].strip()
            departure = line[10:15]
            platform = line[19:22].strip() or None

            if tiploc not in valid_locs:
                # skip invalid locations
                # print(f"Skipping invalid tiploc {tiploc} in service {current_service.uid if current_service else 'N/A'}")
                continue

            current_stops.append(
                Stop(
                    tiploc=tiploc,
                    arrival=None,
                    departure=departure,
                    pass_=None,
                    platform=platform,
                )
            )

        elif line.startswith("LI"):
            tiploc = line[2:10].strip()
            arrival = line[10:15]
            departure = line[15:20]
            pass_ = line[20:25]
            platform = line[33:36].strip() or None

            if tiploc not in valid_locs:
                # skip invalid locations
                # print(f"Skipping invalid tiploc {tiploc} in service {current_service.uid if current_service else 'N/A'}")
                continue

            current_stops.append(
                Stop(
                    tiploc=tiploc,
                    arrival=arrival if arrival.isalnum() else None,
                    departure=departure if departure.isalnum() else None,
                    pass_=pass_ if pass_.isalnum() else None,
                    platform=platform,
                )
            )

        if line.startswith("LT"):
            tiploc = line[2:10].strip()
            arrival = line[10:15]
            platform = line[19:22].strip() or None

            if tiploc not in valid_locs:
                # skip invalid locations
                # print(f"Skipping invalid tiploc {tiploc} in service {current_service.uid if current_service else 'N/A'}")
                continue

            current_stops.append(
                Stop(
                    tiploc=tiploc,
                    arrival=arrival,
                    departure=None,
                    pass_=None,
                    platform=platform,
                )
            )

            if current_service is not None:
                s = Service(
                        uid=current_service.uid,
                        date_from=current_service.date_from,
                        date_to=current_service.date_to,
                        days_run=current_service.days_run,
                        headcode=current_service.headcode,
                        atoc=current_service.atoc,
                        stops=current_stops,
                    )
                # random dupe
                if hash(s) == 174062618079953919:
                    if problematic_service:
                        continue
                    problematic_service = True

                services.append(
                    s
                )
                current_service = None
                current_stops = []


with open("services.sql", mode="w") as f:
    f.write("INSERT INTO service (uid, headcode, operator, days_run, valid_from, valid_until) VALUES\n")
    for i, service in enumerate(services):
        f.write(f"('{hash(service)}', '{service.headcode}', '{service.atoc}', {service.days_run}, "
                f"'{service.date_from}', '{service.date_to}')")
        if i < len(services) - 1:
            f.write(",\n")
        else:
            f.write(";\n")

    f.write("\nINSERT INTO service_stop (tiploc_code, service_uid, platform, arrival, departure, pass, position) VALUES\n")
    first = True
    for service in services:
        for position, stop in enumerate(service.stops):
            if not first:
                f.write(",\n")
            first = False
            arrival_value = f"'{stop.arrival}'" if stop.arrival is not None else "NULL"
            departure_value = f"'{stop.departure}'" if stop.departure is not None else "NULL"
            pass_value = f"'{stop.pass_}'" if stop.pass_ is not None else "NULL"
            platform_value = f"'{stop.platform}'" if stop.platform is not None else "NULL"

            tiploc_value = f"'{stop.tiploc.ljust(7)}'"
            f.write(f"({tiploc_value}, '{hash(service)}', {platform_value}, "
                    f"{arrival_value}, {departure_value}, {pass_value}, {position})")
    f.write(";\n")