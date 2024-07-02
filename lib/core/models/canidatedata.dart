class CandidateDataModel {
  List<Personalinfo>? personalinfo;
  List<Educationalinfo>? educationalinfo;
  List<Professionalinfo>? professionalinfo;

  CandidateDataModel(
      {this.personalinfo, this.educationalinfo, this.professionalinfo});

  CandidateDataModel.fromJson(Map<String, dynamic> json) {
    if (json['Personalinfo'] != null) {
      personalinfo = <Personalinfo>[];
      json['Personalinfo'].forEach((v) {
        personalinfo!.add(Personalinfo.fromJson(v));
      });
    }
    if (json['Educationalinfo'] != null) {
      educationalinfo = <Educationalinfo>[];
      json['Educationalinfo'].forEach((v) {
        educationalinfo!.add(Educationalinfo.fromJson(v));
      });
    }
    if (json['professionalinfo'] != null) {
      professionalinfo = <Professionalinfo>[];
      json['professionalinfo'].forEach((v) {
        professionalinfo!.add(Professionalinfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (personalinfo != null) {
      data['Personalinfo'] = personalinfo!.map((v) => v.toJson()).toList();
    }
    if (educationalinfo != null) {
      data['Educationalinfo'] =
          educationalinfo!.map((v) => v.toJson()).toList();
    }
    if (professionalinfo != null) {
      data['professionalinfo'] =
          professionalinfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Personalinfo {
  int? id;
  String? email;
  String? firstName;
  String? phone;
  String? dob;
  String? profession;
  String? address;
  String? about;
  String? avatar;

  Personalinfo(
      {this.id,
      this.email,
      this.firstName,
      this.phone,
      this.dob,
      this.profession,
      this.address,
      this.about,
      this.avatar});

  Personalinfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    phone = json['phone'];
    dob = json['dob'];
    profession = json['Profession'];
    address = json['address'];
    about = json['about'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['first_name'] = firstName;
    data['phone'] = phone;
    data['dob'] = dob;
    data['Profession'] = profession;
    data['address'] = address;
    data['about'] = about;
    data['avatar'] = avatar;
    return data;
  }
}

class Educationalinfo {
  String? degreetitle;
  String? institutename;
  String? degreestartdate;
  String? degreeenddate;
  String? persent;
  String? grade;
  String? details;

  Educationalinfo(
      {this.degreetitle,
      this.institutename,
      this.degreestartdate,
      this.degreeenddate,
      this.persent,
      this.grade,
      this.details});

  Educationalinfo.fromJson(Map<String, dynamic> json) {
    degreetitle = json['degreetitle'];
    institutename = json['institutename'];
    degreestartdate = json['degreestartdate'];
    degreeenddate = json['degreeenddate'];
    persent = json['Persent'];
    grade = json['grade'];
    details = json['Details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['degreetitle'] = degreetitle;
    data['institutename'] = institutename;
    data['degreestartdate'] = degreestartdate;
    data['degreeenddate'] = degreeenddate;
    data['Persent'] = persent;
    data['grade'] = grade;
    data['Details'] = details;
    return data;
  }
}

class Professionalinfo {
  String? orgname;
  String? strtdate;
  String? enddate;
  String? role;
  String? jobdetails;

  Professionalinfo(
      {this.orgname, this.strtdate, this.enddate, this.role, this.jobdetails});

  Professionalinfo.fromJson(Map<String, dynamic> json) {
    orgname = json['orgname'];
    strtdate = json['strtdate'];
    enddate = json['enddate'];
    role = json['role'];
    jobdetails = json['jobdetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orgname'] = orgname;
    data['strtdate'] = strtdate;
    data['enddate'] = enddate;
    data['role'] = role;
    data['jobdetails'] = jobdetails;
    return data;
  }
}
