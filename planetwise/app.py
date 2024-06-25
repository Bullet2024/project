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
