class UpdateUser {
  UpdateUser({
    required this.added,
    required this.updated,
    required this.data,
  });
  late final bool added;
  late final bool updated;
  late final UpdatedData data;

  UpdateUser.fromJson(Map<String, dynamic> json) {
    added = json['added'];
    updated = json['updated'];
    data = UpdatedData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final mydata = <String, dynamic>{};
    mydata['updated'] = updated;
    mydata['data'] = data.toJson();
    return mydata;
  }
}

class UpdatedData {
  UpdatedData({
    required this.generatedMaps,
    required this.raw,
    required this.affected,
  });
  late final List<dynamic> generatedMaps;
  late final List<dynamic> raw;
  late final int affected;

  UpdatedData.fromJson(Map<String, dynamic> json) {
    generatedMaps = List.castFrom<dynamic, dynamic>(json['generatedMaps']);
    raw = List.castFrom<dynamic, dynamic>(json['raw']);
    affected = json['affected'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['generatedMaps'] = generatedMaps;
    data['raw'] = raw;
    data['affected'] = affected;
    return data;
  }
}

class ChangeUserPassword {
  ChangeUserPassword({
    required this.changed,
    required this.updated,
    required this.data,
  });
  late final bool changed;
  late final bool updated;
  late final String data;

  ChangeUserPassword.fromJson(Map<String, dynamic> json) {
    changed = json['changed'];
    updated = json['updated'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['changed'] = changed;
    data['updated'] = updated;
    data['data'] = data;
    return data;
  }
}
