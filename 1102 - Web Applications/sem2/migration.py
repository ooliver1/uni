from app import app, db, Product


# eco in "Mt CO2e /year"
# price in "GBP"
items = [
    {
        "name": "Wales",
        "price": 85_400_000_000,
        "description": "",
        "image": "wales.jpeg",
        "eco_impact": 30.7,
    },
    {
        "name": "Scotland",
        "price": 218_000_000_000,
        "description": "",
        "image": "scotland.png",
        "eco_impact": 41.5,
    },
    {
        "name": "England",
        "price": 2_160_000_000_000,
        "description": "",
        "image": "england.png",
        "eco_impact": 313.2,
    },
    {
        "name": "Northern Ireland",
        "price": 56_700_000_000,
        "description": "",
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
