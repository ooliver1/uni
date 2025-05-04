from app import app, db, Product


# eco in "Mt CO2e /year"
# price in "GBP"
items = [
    {
        "name": "Wales",
        "price": 85_400_000_000,
        # dont just copy wikipedia DONT JUST COPY THE FIRST LINE OF WIKIPEDIA put stuff about the economy
        "description": "Wales (Welsh: Cymru) has a population of 3.2 million with an area of 21,218 km² (8,192 mi²). The capital city is Cardiff.",
        "image": "wales.jpeg",
        "eco_impact": 30.7,
    },
    {
        "name": "Scotland",
        "price": 218_000_000_000,
        "description": "Scotland (Scottish Gaelic: Alba) has a population of 5.4 million with an area of 80,231 km² (30,977 mi²). The capital city is Edinburgh.",
        "image": "scotland.png",
        "eco_impact": 41.5,
    },
    {
        "name": "England",
        "price": 2_160_000_000_000,
        "description": "England has a population of 57.1 million with an area of 132,932 km² (51,325 mi²). The capital city is London.",
        "image": "england.png",
        "eco_impact": 313.2,
    },
    {
        "name": "Northern Ireland",
        "price": 56_700_000_000,
        "description": "Northern Ireland (Irish: Tuaisceart Éireann, Ulster Scots: Norlin Airlann) has a population of 1.9 million with an area of 14,330 km² (5,530 mi²). The capital city is Belfast.",
        "image": "ni.jpg",
        "eco_impact": 20.9,
    },
]

with app.app_context():
    db.create_all()

    for item in items:
        new_item = Product(
            name=item["name"],
            price=item["price"],
            description=item["description"],
            image=item["image"],
            eco_impact=item["eco_impact"],
        )
        db.session.add(new_item)

    db.session.commit()
