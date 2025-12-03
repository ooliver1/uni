= CM2102 Database Systems Portfolio
Oliver Wilkes \
C24057633

#pagebreak()

== 1. Database Design

I have designed my database around storing schedules for train services. This requires a table for the services themselves, the stops for each service, the stations and locations for these stops, and operators of these services.

This has been fully normalised to 3NF by splitting the operator name into a table, and separating locations from stations as not all service waypoints are stations (e.g. junctions).

#image("schema.drawio.png")
