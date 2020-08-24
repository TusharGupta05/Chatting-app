class Message {
  String _mode;
  String _message;
  String _user;
  String _createdAt;

  Message(this._user, this._mode, this._message, this._createdAt);

  get user => _user;
  get message => _message;
  get mode => _mode;
  get createdAt => _createdAt;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['mode'] = _mode;
    map['message'] = _message;
    map['createdAt'] = _createdAt;
    map['user'] = _user;
    return map;
  }

  Message.fromMapObject(Map<String, dynamic> map) {
    this._mode = map['mode'];
    this._message = map['message'];
    this._createdAt = map['createdAt'];
    this._user = map['user'];
  }
}
