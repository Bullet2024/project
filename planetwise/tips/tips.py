from flask import Blueprint, render_template

tips_bp = Blueprint('tips', __name__)

@tips_bp.route('/tips')
def
