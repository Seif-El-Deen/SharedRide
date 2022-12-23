import 'package:shared_ride_design_patterns/models/car_type.dart';

class Car {
  String _model;
  String _plateNumber;
  CarType _type;
  String _color;
  String _industryYear;

  Car(this._model, this._plateNumber, this._type, this._color,
      this._industryYear);

  String get industryYear => _industryYear;

  set industryYear(String value) {
    _industryYear = value;
  }

  CarType get type => _type;

  set type(CarType value) {
    _type = value;
  }

  String get plateNumber => _plateNumber;

  set plateNumber(String value) {
    _plateNumber = value;
  }

  String get model => _model;

  set model(String value) {
    _model = value;
  }

  String get color => _color;

  set color(String value) {
    _color = value;
  }
}
