
class Contact {
  String? name;
  String? number;

  Contact({this.name, this.number});

  Contact.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    number = json["number"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["number"] = number;
    return _data;
  }
}
