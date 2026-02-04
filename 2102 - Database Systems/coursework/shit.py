import re

# --- Step 1: Read valid tiploc_codes from location.sql ---
valid_tiplocs = set()
with open("locations.sql", "r") as f:
    for line in f:
        match = re.search(r"\('([^']+)'", line)
        if match:
            tiploc = match.group(1).strip()
            valid_tiplocs.add(tiploc)

print(f"Loaded {len(valid_tiplocs)} valid tiploc codes.")

# --- Step 2: Check stations.sql for bad tiploc_codes ---
bad_rows = []

with open("stations.sql", "r") as f:
    for i, line in enumerate(f, 1):
        match = re.search(r"\('([^']+)',\s*'([^']+)'", line)
        if match:
            crs, tiploc = match.group(1).strip(), match.group(2).strip()
            if tiploc not in valid_tiplocs:
                bad_rows.append((i, crs, tiploc, line.strip()))

# --- Step 3: Report ---
if bad_rows:
    print(f"\nFound {len(bad_rows)} rows with invalid tiploc_code:\n")
    for row in bad_rows:
        print(f"Line {row[0]}: CRS={row[1]} Tiploc={row[2]} -> {row[3]}")
else:
    print("All rows have valid tiploc codes.")
