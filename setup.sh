#!/bin/bash

# Configuración
GITHUB_USER="Bullet2024"
REPO_NAME="project"
BRANCH_NAME="main"
GITHUB_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"

# Clonar el repositorio (si no está vacío) o inicializar uno nuevo
if git clone $GITHUB_URL; then
    cd $REPO_NAME
else
    echo "Error al clonar el repositorio, inicializando uno nuevo"
    mkdir $REPO_NAME
    cd $REPO_NAME
    git init
    git remote add origin $GITHUB_URL
    git checkout -b $BRANCH_NAME
fi

# Crear la estructura de directorios y archivos
echo "Creando estructura de directorios y archivos..."

mkdir -p planetwise/auth/templates
mkdir -p planetwise/co2e_calculator/templates
mkdir -p planetwise/product_directory/templates
mkdir -p planetwise/static/css
mkdir -p planetwise/templates
mkdir -p planetwise/tips/templates

echo "Creating requirements.txt..."
cat <<EOL > planetwise/requirements.txt
flask==2.2.3
flask-oauthlib==0.9.6
flask_sqlalchemy==2.5.1
EOL

echo "Creating app.py..."
cat <<EOL > planetwise/app.py
from flask import Flask, render_template
from auth.auth import auth_bp
from co2e_calculator.calculator import calc_bp
from product_directory import product_bp, db as product_db
from tips.tips import tips_bp

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///products.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

product_db.init_app(app)

app.register_blueprint(auth_bp)
app.register_blueprint(calc_bp)
app.register_blueprint(product_bp)
app.register_blueprint(tips_bp)

@app.route('/')
def home():
    return render_template('home.html')

if __name__ == '__main__':
    with app.app_context():
        product_db.create_all()
    app.run(debug=True)
EOL

echo "Creating auth/auth.py..."
cat <<EOL > planetwise/auth/auth.py
from flask import Blueprint, render_template

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/welcome')
def welcome():
    return render_template('welcome.html')

@auth_bp.route('/error')
def error():
    return render_template('error.html')
EOL

echo "Creating auth/templates/welcome.html..."
cat <<EOL > planetwise/auth/templates/welcome.html
<!doctype html>
<html lang='en'>
  <head>
    <meta charset='utf-8'>
    <title>Welcome</title>
  </head>
  <body>
    <h1>Welcome to Planetwise</h1>
  </body>
</html>
EOL

echo "Creating auth/templates/error.html..."
cat <<EOL > planetwise/auth/templates/error.html
<!doctype html>
<html lang='en'>
  <head>
    <meta charset='utf-8'>
    <title>Error</title>
  </head>
  <body>
    <h1>Error occurred</h1>
  </body>
</html>
EOL

echo "Creating co2e_calculator/calculator.py..."
cat <<EOL > planetwise/co2e_calculator/calculator.py
from flask import Blueprint, render_template

calc_bp = Blueprint('calculator', __name__)

@calc_bp.route('/calculator')
def index():
    return render_template('index.html')

@calc_bp.route('/calculator/result')
def result():
    return render_template('result.html')
EOL

echo "Creating co2e_calculator/templates/index.html..."
cat <<EOL > planetwise/co2e_calculator/templates/index.html
<!doctype html>
<html lang='en'>
  <head>
    <meta charset='utf-8'>
    <title>CO2e Calculator</title>
  </head>
  <body>
    <h1>CO2e Calculator</h1>
  </body>
</html>
EOL

echo "Creating co2e_calculator/templates/result.html..."
cat <<EOL > planetwise/co2e_calculator/templates/result.html
<!doctype html>
<html lang='en'>
  <head>
    <meta charset='utf-8'>
    <title>Calculation Result</title>
  </head>
  <body>
    <h1>Calculation Result</h1>
  </body>
</html>
EOL

echo "Creating product_directory/__init__.py..."
cat <<EOL > planetwise/product_directory/__init__.py
from flask import Blueprint

product_bp = Blueprint('product_directory', __name__)

from . import routes
EOL

echo "Creating product_directory/models.py..."
cat <<EOL > planetwise/product_directory/models.py
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(255), nullable=False)
    brand = db.Column(db.String(50), nullable=False)
    price = db.Column(db.Float, nullable=False)

    def __repr__(self):
        return f'<Product {self.name}>'
EOL

echo "Creating product_directory/routes.py..."
cat <<EOL > planetwise/product_directory/routes.py
from flask import render_template, request, redirect, url_for
from . import product_bp
from .models import db, Product

@product_bp.route('/products')
def product_list():
    products = Product.query.all()
    return render_template('product_list.html', products=products)

@product_bp.route('/add_product', methods=['GET', 'POST'])
def add_product():
    if request.method == 'POST':
        name = request.form['name']
        description = request.form['description']
        brand = request.form['brand']
        price = request.form['price']
        new_product = Product(name=name, description=description, brand=brand, price=price)
        db.session.add(new_product)
        db.session.commit()
        return redirect(url_for('product_directory.product_list'))
    return render_template('add_product.html')
EOL

echo "Creating product_directory/templates/product_list.html..."
cat <<'EOL' > planetwise/product_directory/templates/product_list.html
{% extends "base.html" %}

{% block content %}
<h1>Product List</h1>
<ul>
    {% for product in products %}
    <li>{{ product.name }} - {{ product.brand }} - ${{ product.price }}</li>
    {% endfor %}
</ul>
<a href="{{ url_for('product_directory.add_product') }}">Add New Product</a>
{% endblock %}
EOL

echo "Creating product_directory/templates/add_product.html..."
cat <<'EOL' > planetwise/product_directory/templates/add_product.html
{% extends "base.html" %}

{% block content %}
<h1>Add Product</h1>
<form method="POST">
    <label for="name">Name:</label>
    <input type="text" id="name" name="name" required><br>
    <label for="description">Description:</label>
    <input type="text" id="description" name="description" required><br>
    <label for="brand">Brand:</label>
    <input type="text" id="brand" name="brand" required><br>
    <label for="price">Price:</label>
    <input type="number" id="price" name="price" required><br>
    <button type="submit">Add Product</button>
</form>
{% endblock %}
EOL

echo "Creating static/css/styles.css..."
cat <<EOL > planetwise/static/css/styles.css
body {
    font-family: Arial, sans-serif;
}
EOL

echo "Creating templates/base.html..."
cat <<EOL > planetwise/templates/base.html
<!doctype html>
<html lang='en'>
  <head>
    <meta charset='utf-8'>
    <title>Planetwise</title>
    <link rel='stylesheet' href='/static/css/styles.css'>
  </head>
  <body>
    <header>
      <h1>Planetwise</h1>
      <nav>
        <a href='/'>Home</a>
        <a href='/products'>Products</a>
        <a href='/tips'>Tips</a>
        <a href='/calculator'>CO2e Calculator</a>
      </nav>
    </header>
    <main>
      {% block content %}{% endblock %}
    </main>
  </body>
</html>
EOL

echo "Creating templates/home.html..."
cat <<EOL > planetwise/templates/home.html
{% extends "base.html" %}

{% block content %}
<h1>Welcome to Planetwise</h1>
<p>Your go-to resource for sustainable living.</p>
{% endblock %}
EOL

echo "Creating tips/tips.py..."
cat <<EOL > planetwise/tips/tips.py
from flask import Blueprint, render_template

tips_bp = Blueprint('tips', __name__)

@tips_bp.route('/tips')
def
