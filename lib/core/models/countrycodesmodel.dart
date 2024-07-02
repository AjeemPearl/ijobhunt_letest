class CountryCodes {
  String? name;
  String? phonecode;

  CountryCodes({this.name, this.phonecode});

  CountryCodes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phonecode = json['phonecode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phonecode'] = phonecode;
    return data;
  }
}