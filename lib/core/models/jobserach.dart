class Jobs {
  int? id;
  String? employerId;
  String? hireEmployer;
  String? jobTitle;
  String? jobDesc;
  String? salary;
  String? currency;
  String? country;
  String? jobLocation;
  String? jobType;
  String? status;
  String? createdAt;
  String? updatedAt;
  bool? myLike;
  MyCompany? myCompany;
  MyUser? myUser;

  Jobs(
      {this.id,
      this.employerId,
      this.hireEmployer,
      this.jobTitle,
      this.jobDesc,
      this.salary,
      this.currency,
      this.country,
      this.jobLocation,
      this.jobType,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.myLike,
      this.myCompany,
      this.myUser});

  Jobs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employerId = json['employer_id'];
    hireEmployer = json['hire employer'];
    jobTitle = json['job_title'];
    jobDesc = json['job_desc'];
    salary = json['salary'];
    currency = json['currency'];
    country = json['country'];
    jobLocation = json['job_location'];
    jobType = json['job_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    myLike = json['myLike'];
    myCompany = json['my_company'] != null
        ? MyCompany.fromJson(json['my_company'])
        : null;
    myUser = json['my_user'] != null ? MyUser.fromJson(json['my_user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employer_id'] = employerId;
    data['hire employer'] = hireEmployer;
    data['job_title'] = jobTitle;
    data['job_desc'] = jobDesc;
    data['salary'] = salary;
    data['currency'] = currency;
    data['country'] = country;
    data['job_location'] = jobLocation;
    data['job_type'] = jobType;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['myLike'] = myLike;
    if (myCompany != null) {
      data['my_company'] = myCompany!.toJson();
    }
    if (myUser != null) {
      data['my_user'] = myUser!.toJson();
    }
    return data;
  }
}

class MyCompany {
  int? id;
  int? employerId;
  String? comapnyName;
  String? noOfEmployee;
  String? employerName;
  String? phoneNumber;
  String? country;
  String? aboutCompany;
  String? address;
  String? image;
  String? imageExt;
  String? createdAt;
  String? updatedAt;
  String? rating;

  MyCompany(
      {this.id,
      this.employerId,
      this.comapnyName,
      this.noOfEmployee,
      this.employerName,
      this.phoneNumber,
      this.country,
      this.aboutCompany,
      this.address,
      this.image,
      this.imageExt,
      this.createdAt,
      this.updatedAt,
      this.rating});

  MyCompany.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employerId = json['employer_id'];
    comapnyName = json['comapny_name'];
    noOfEmployee = json['no_of_employee'];
    employerName = json['employer_name'];
    phoneNumber = json['phone_number'];
    country = json['country'];
    aboutCompany = json['about_company'];
    address = json['address'];
    image = json['image'];
    imageExt = json['image_ext'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    rating = json['rating'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employer_id'] = employerId;
    data['comapny_name'] = comapnyName;
    data['no_of_employee'] = noOfEmployee;
    data['employer_name'] = employerName;
    data['phone_number'] = phoneNumber;
    data['country'] = country;
    data['about_company'] = aboutCompany;
    data['address'] = address;
    data['image'] = image;
    data['image_ext'] = imageExt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['rating'] = rating;
    return data;
  }
}

class MyUser {
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

  MyUser(
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

  MyUser.fromJson(Map<String, dynamic> json) {
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
