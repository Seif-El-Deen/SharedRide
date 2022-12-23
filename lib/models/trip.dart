class Trip {
  String _carOwnerName;
  String _carModel;
  String _customerName;
  String _pickupPoint;
  String _destination;
  String _tripTime;

  Trip(this._carOwnerName, this._carModel, this._customerName,
      this._pickupPoint, this._destination, this._tripTime);

  String get tripTime => _tripTime;

  set tripTime(String value) {
    _tripTime = value;
  }

  String get destination => _destination;

  set destination(String value) {
    _destination = value;
  }

  String get pickupPoint => _pickupPoint;

  set pickupPoint(String value) {
    _pickupPoint = value;
  }

  String get customerName => _customerName;

  set customerName(String value) {
    _customerName = value;
  }

  String get carModel => _carModel;

  set carModel(String value) {
    _carModel = value;
  }

  String get carOwnerName => _carOwnerName;

  set carOwnerName(String value) {
    _carOwnerName = value;
  }
}
