class CarType {
  String _type;
  int _numberOfSeats;

  CarType(this._type, this._numberOfSeats);

  int get numberOfSeats => _numberOfSeats;

  set numberOfSeats(int value) {
    _numberOfSeats = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }
}
