from flask import Blueprint

product_bp = Blueprint('product_directory', __name__)

from . import routes
