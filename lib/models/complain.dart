class Complaint {
  String _complainId;
  String _customerName;
  String _carOwnerName;
  String _complain;

  Complaint(
      this._complainId, this._customerName, this._carOwnerName, this._complain);

  String get complain => _complain;

  set complain(String value) {
    _complain = value;
  }

  String get carOwnerName => _carOwnerName;

  set carOwnerName(String value) {
    _carOwnerName = value;
  }

  String get customerName => _customerName;

  set customerName(String value) {
    _customerName = value;
  }

  String get complainId => _complainId;

  set complainId(String value) {
    _complainId = value;
  }
}
