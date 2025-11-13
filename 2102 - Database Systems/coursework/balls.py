import re

# --- Step 1: Load all valid tiplocs ---
valid_tiplocs = set()
with open("locations.sql") as f:
    for line in f:
        match = re.match(r"\('(.{7})',\s*\d+,.+\)", line.strip())
        if match:
            tiploc = match.group(1)
            valid_tiplocs.add(tiploc)  # exact CHAR(7)

print(f"Loaded {len(valid_tiplocs)} valid tiplocs")

# --- Step 2: Load all valid service UIDs ---
valid_service_uids = set()
with open("services.sql") as f:
    for line in f:
        match = re.match(r"\('(\d+)',\s*'.{4}',\s*'.{2}',\s*\d+,\s*'.*?',\s*'.*?'\)", line.strip())
        if match:
            uid = int(match.group(1))
            valid_service_uids.add(uid)

print(f"Loaded {len(valid_service_uids)} valid service UIDs")

# --- Step 3: Check service_stop inserts ---
invalid_stops = []

with open("services.sql") as f:
    for line in f:
        line = line.strip()
        match = re.match(r"\('(.{1,7})',\s*'(\d+)'", line)
        if match:
            tiploc, uid = match.groups()
            uid_int = int(uid)
            tiploc_padded = tiploc.ljust(7)

            tiploc_invalid = tiploc_padded not in valid_tiplocs
            uid_invalid = uid_int not in valid_service_uids

            if tiploc_invalid or uid_invalid:
                invalid_stops.append({
                    "tiploc": tiploc,
                    "tiploc_padded": tiploc_padded,
                    "service_uid": uid_int,
                    "tiploc_invalid": tiploc_invalid,
                    "uid_invalid": uid_invalid
                })

# --- Step 4: Report ---
if invalid_stops:
    print(f"Found {len(invalid_stops)} invalid service stops:")
    for stop in invalid_stops:
        print(f"Service UID {stop['service_uid']}, tiploc '{stop['tiploc']}' "
              f"(padded: '{stop['tiploc_padded']}'), "
              f"tiploc_invalid={stop['tiploc_invalid']}, "
              f"uid_invalid={stop['uid_invalid']}")
else:
    print("All service stops have valid tiploc and service UID. FK should succeed.")
