from app import app, db, Product


items = [
    {"name": "Wales", "price": 85_400_000_000, "description": "", "image": "wales.jpeg"},
    {"name": "England", "price": 2_160_000_000_000, "description": "", "image": "england.png"},
    {"name": "Scotland", "price": 218_000_000_000, "description": "", "image": "scotland.png"},
    {"name": "Northern Ireland", "price": 56_700_000_000, "description": "", "image": "ni.jpg"},
]

with app.app_context():
    db.create_all()

    for item in items:
        new_item = Product(name=item["name"], price=item["price"], description=item["description"], image=item["image"])
        db.session.add(new_item)

    db.session.commit()
