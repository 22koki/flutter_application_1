#!/usr/bin/env python3
from flask import Flask, jsonify, request
from flask_migrate import Migrate
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm.exc import NoResultFound
from sqlalchemy.exc import DataError
from models import db, Hero, Power, HeroPower


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db/app.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JSON_SORT_KEYS'] = False  # Keep the order of keys in JSON responses

migrate = Migrate(app, db)

db.init_app(app)

# Error handling for DataError
@app.errorhandler(DataError)
def handle_data_error(error):
    response = {'error': 'Invalid data provided'}
    return jsonify(response), 400

# Error handling for IntegrityError
@app.errorhandler(IntegrityError)
def handle_integrity_error(error):
    response = {'error': 'Integrity violation'}
    return jsonify(response), 400

# Error handling for NoResultFound
@app.errorhandler(NoResultFound)
def handle_no_result_found(error):
    response = {'error': 'Not Found'}
    return jsonify(response), 404

# Routes

@app.route('/')
def home():
    return ''

# # Routes

# GET /heroes
@app.route('/heroes', methods=['GET'])
def get_heroes():
    heroes = Hero.query.all()
    heroes_data = [{'id': hero.id, 'name': hero.name, 'super_name': hero.super_name} for hero in heroes]
    return jsonify(heroes_data)

# GET /heroes/:id
@app.route('/heroes/<int:hero_id>', methods=['GET'])
def get_hero(hero_id):
    try:
        hero = Hero.query.filter_by(id=hero_id).one()
        hero_data = {
            'id': hero.id,
            'name': hero.name,
            'super_name': hero.super_name,
            'powers': [{'id': power.id, 'name': power.name, 'description': power.description} for power in hero.powers]
        }
        return jsonify(hero_data)
    except NoResultFound:
        return jsonify({'error': 'Hero not found'}), 404

# GET /powers
@app.route('/powers', methods=['GET'])
def get_powers():
    powers = Power.query.all()
    powers_data = [{'id': power.id, 'name': power.name, 'description': power.description} for power in powers]
    return jsonify(powers_data)

# GET /powers/:id
@app.route('/powers/<int:power_id>', methods=['GET'])
def get_power(power_id):
    try:
        power = Power.query.filter_by(id=power_id).one()
        power_data = {'id': power.id, 'name': power.name, 'description': power.description}
        return jsonify(power_data)
    except NoResultFound:
        return jsonify({'error': 'Power not found'}), 404

# PATCH /powers/:id
@app.route('/powers/<int:power_id>', methods=['PATCH'])
def update_power(power_id):
    try:
        power = Power.query.filter_by(id=power_id).one()
        data = request.get_json()
        if 'description' in data:
            power.description = data['description']
            db.session.commit()
            return jsonify({'id': power.id, 'name': power.name, 'description': power.description})
        else:
            return jsonify({'error': 'No valid fields provided for update'}), 400
    except NoResultFound:
        return jsonify({'error': 'Power not found'}), 404
    except DataError:
        db.session.rollback()
        return jsonify({'errors': ['Validation errors']}), 400

# POST /hero_powers
@app.route('/hero_powers', methods=['POST'])
def create_hero_power():
    data = request.get_json()
    try:
        hero_power = HeroPower(strength=data['strength'], power_id=data['power_id'], hero_id=data['hero_id'])
        db.session.add(hero_power)
        db.session.commit()
        hero = Hero.query.get(data['hero_id'])
        hero_data = {
            'id': hero.id,
            'name': hero.name,
            'super_name': hero.super_name,
            'powers': [{'id': power.id, 'name': power.name, 'description': power.description} for power in hero.powers]
        }
        return jsonify(hero_data)
    except IntegrityError:
        db.session.rollback()
        return jsonify({'errors': ['Validation errors']}), 400



if __name__ == '__main__':
    app.run(port=5555)
