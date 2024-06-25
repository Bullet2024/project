from flask import Blueprint, render_template

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/welcome')
def welcome():
    return render_template('welcome.html')

@auth_bp.route('/error')
def error():
    return render_template('error.html')
