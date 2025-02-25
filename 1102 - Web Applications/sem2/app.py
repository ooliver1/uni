from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
from numerize.numerize import numerize

app = Flask(__name__)
app.config["SECRET_KEY"] = ""
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///data.sqlite3"
db = SQLAlchemy(app)

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(32), index=True, unique=True)
    price = db.Column(db.Float())
    description = db.Column(db.Text)
    image = db.Column(db.String(32))

@app.route("/")
def index():
    items = Product.query.all()
    return render_template("index.html", items=items, numerize=numerize)

@app.route("/item/<int:item_id>")
def single_product(item_id):
    item = Product.query.get(item_id)
    return render_template("single_item.html", item=item)

if __name__ == "__main__":
    app.run(debug=True)
