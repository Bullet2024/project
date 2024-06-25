from flask import Blueprint, render_template

calc_bp = Blueprint('calculator', __name__)

@calc_bp.route('/calculator')
def index():
    return render_template('index.html')

@calc_bp.route('/calculator/result')
def result():
    return render_template('result.html')
