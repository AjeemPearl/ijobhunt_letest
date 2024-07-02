class UserModel {
  User? user;
  bool? status;

  UserModel({this.user, this.status});

  UserModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? userType;
  String? dateofbirth;
  String? profession;
  String? address;
  String? aboutyourself;
  String? image;
  int? paymentStatus;
  String? paymentDate;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? degreetitle;
  String? institutename;
  String? degreestartdate;
  String? degreeenddate;
  String? degreepercent;
  String? degreegrade;
  String? degreedetails;
  String? organizationname;
  String? jobTitle;
  String? jobstartDate;
  String? jobendDate;
  String? stillWorking;
  String? yourole;
  String? jobdetails;
  String? country;
  String? deviceToken;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.userType,
      this.dateofbirth,
      this.profession,
      this.address,
      this.aboutyourself,
      this.image,
      this.paymentStatus,
      this.paymentDate,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.degreetitle,
      this.institutename,
      this.degreestartdate,
      this.degreeenddate,
      this.degreepercent,
      this.degreegrade,
      this.degreedetails,
      this.organizationname,
      this.jobTitle,
      this.jobstartDate,
      this.jobendDate,
      this.stillWorking,
      this.yourole,
      this.jobdetails,
      this.country,
      this.deviceToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    userType = json['user_type'];
    dateofbirth = json['dateofbirth'];
    profession = json['profession'];
    address = json['address'];
    aboutyourself = json['aboutyourself'];
    image = json['image'];
    paymentStatus = json['payment_status'];
    paymentDate = json['payment_date'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    degreetitle = json['degreetitle'];
    institutename = json['institutename'];
    degreestartdate = json['degreestartdate'];
    degreeenddate = json['degreeenddate'];
    degreepercent = json['degreepercent'];
    degreegrade = json['degreegrade'];
    degreedetails = json['degreedetails'];
    organizationname = json['organizationname'];
    jobTitle = json['job_title'];
    jobstartDate = json['jobstartDate'];
    jobendDate = json['jobendDate'];
    stillWorking = json['stillWorking'];
    yourole = json['yourole'];
    jobdetails = json['jobdetails'];
    country = json['country'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['user_type'] = userType;
    data['dateofbirth'] = dateofbirth;
    data['profession'] = profession;
    data['address'] = address;
    data['aboutyourself'] = aboutyourself;
    data['image'] = image;
    data['payment_status'] = paymentStatus;
    data['payment_date'] = paymentDate;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['degreetitle'] = degreetitle;
    data['institutename'] = institutename;
    data['degreestartdate'] = degreestartdate;
    data['degreeenddate'] = degreeenddate;
    data['degreepercent'] = degreepercent;
    data['degreegrade'] = degreegrade;
    data['degreedetails'] = degreedetails;
    data['organizationname'] = organizationname;
    data['job_title'] = jobTitle;
    data['jobstartDate'] = jobstartDate;
    data['jobendDate'] = jobendDate;
    data['stillWorking'] = stillWorking;
    data['yourole'] = yourole;
    data['jobdetails'] = jobdetails;
    data['country'] = country;
    data['device_token'] = deviceToken;
    return data;
  }
}
