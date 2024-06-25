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
