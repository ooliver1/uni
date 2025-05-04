from calendar import c
from flask import Flask, render_template, session, request
from flask_sqlalchemy import SQLAlchemy
from flask_bootstrap import Bootstrap


app = Flask(__name__)
app.config["SECRET_KEY"] = "..."
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///data.sqlite3"
db = SQLAlchemy(app)
bootstrap = Bootstrap(app)


class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(32), index=True, unique=True)
    price = db.Column(db.Float())
    description = db.Column(db.Text)
    image = db.Column(db.String(32))
    eco_impact = db.Column(db.Float())


def numerize(n, decimals=2):
    suffixes = ["", "K", "M", "B", "T"]
    is_negative = n < 0
    n = abs(n)
    for suffix in suffixes:
        if n < 1000:
            break
        n /= 1000
    return f"{'-' if is_negative else ''}{round(n, decimals)}{suffix}"


@app.route("/", methods=["GET", "POST"])
def index():
    sort_by = request.args.get("sort_by", "default")
    order = request.args.get("order", "asc")
    items = Product.query.all()

    reverse = order == "desc"
    if sort_by == "name":
        items.sort(key=lambda x: x.name, reverse=reverse)
    elif sort_by == "price":
        items.sort(key=lambda x: x.price, reverse=reverse)
    elif sort_by == "eco_impact":
        items.sort(key=lambda x: x.eco_impact, reverse=reverse)

    search_query = request.args.get("search")
    if search_query:
        items = [item for item in items if search_query.lower() in item.name.lower()]

    if "basket" not in session:
        session["basket"] = []

    basket: list[int] = session["basket"]

    if item_id_str := request.form.get("item_id"):
        item_id = int(item_id_str)
        if item_id not in basket:
            basket.append(item_id)
            session.modified = True

    if item_id_str := request.form.get("remove_item_id"):
        item_id = int(item_id_str)
        if item_id in basket:
            basket.remove(item_id)
            session.modified = True

    if request.form.get("clear_basket") == "true":
        session["basket"] = basket = []
        session.modified = True

    return render_template(
        "index.html",
        items=items,
        numerize=numerize,
        basket=basket,
        sort_by=sort_by,
        order=order,
        search_query=search_query,
    )


@app.route("/item/<int:item_id>")
def single_product(item_id):
    item = Product.query.get(item_id)

    if "basket" not in session:
        session["basket"] = []

    basket: list[int] = session["basket"]
    in_basket = item_id in basket

    return render_template(
        "single_item.html", item=item, numerize=numerize, in_basket=in_basket
    )


@app.route("/basket")
def basket():
    items = Product.query.all()
    basket: list[int] = session.get("basket", [])
    basket_items = [item for item in items if item.id in basket]
    total_price = sum(item.price for item in basket_items)
    total_eco_impact = sum(item.eco_impact for item in basket_items)
    return render_template(
        "basket.html",
        items=basket_items,
        numerize=numerize,
        total_price=round(total_price, 2),
        total_eco_impact=round(total_eco_impact, 2),
    )


@app.route("/checkout", methods=["GET", "POST"])
def checkout():
    if request.method == "GET":
        items = Product.query.all()
        basket: list[int] = session.get("basket", [])
        basket_items = [item for item in items if item.id in basket]
        total_price = sum(item.price for item in basket_items)
        total_eco_impact = sum(item.eco_impact for item in basket_items)
        return render_template(
            "checkout.html",
            items=basket_items,
            numerize=numerize,
            total_price=round(total_price, 2),
            total_eco_impact=round(total_eco_impact, 2),
        )
    else:
        if not session.get("basket"):
            return render_template(
                "checkout.html",
                error="Basket is empty.",
            )

        session["basket"] = []
        session.modified = True
        # validate form
        card_number = request.form.get("card_number")
        expiry_date = request.form.get("expiry_date")
        cvv = request.form.get("cvv")
        cardholder_name = request.form.get("cardholder_name")
        if not card_number or not expiry_date or not cvv or not cardholder_name:
            return render_template(
                "checkout.html",
                error="Please fill in all fields.",
            )

        card_number = card_number.replace(" ", "").replace("-", "")

        if len(card_number) != 16 or not card_number.isdigit():
            return render_template(
                "checkout.html",
                error="Invalid card number.",
            )
        if len(cvv) != 3 or not cvv.isdigit():
            return render_template(
                "checkout.html",
                error="Invalid CVV.",
            )
        if len(expiry_date) != 5 or expiry_date[2] != "/":
            return render_template(
                "checkout.html",
                error="Invalid expiry date.",
            )
        if not cardholder_name:
            return render_template(
                "checkout.html",
                error="Invalid cardholder name.",
            )

        # pretend to process payment

        return render_template(
            "checkout.html",
            success=True,
        )


if __name__ == "__main__":
    app.run(host="0.0.0.0")
