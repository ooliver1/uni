# python code to find dupe uids (first column) in services.sql
"""INSERT INTO service (uid, headcode, operator, days_run, valid_from, valid_until) VALUES
('C029466250518', '0B00', 'AW', 1, '6250518', '251207'),
('C029477250518', '0B00', 'AW', 1, '7250518', '251207'),
('C029488250518', '0B00', 'AW', 1, '8250518', '251207'),
('C029499250518', '0B00', 'AW', 1, '9250518', '251207'),
..."""

from collections import Counter
uids = []
with open("services.sql", mode="r") as f:
    for line in f:
        if line.startswith("INSERT INTO service "):
            continue
        parts = line.strip().strip(",").strip("();").split(", ")
        uid = parts[0].strip("'")
        uids.append(uid)
        if line.startswith("INSERT INTO service_stop"):
            break

counts = Counter(uids)
dupes = {uid: count for uid, count in counts.items() if count >
    1}

for uid, count in dupes.items():
    print(f"UID: {uid} Count: {count}")
print(f"Total duplicate UIDs: {len(dupes)}")
