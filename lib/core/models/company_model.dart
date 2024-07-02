class CompanyData {
  List<Company>? company;
  List<User1>? user1;
  String? status;
  int? paymentStatus;

  CompanyData({this.company, this.user1, this.status, this.paymentStatus});

  CompanyData.fromJson(Map<String, dynamic> json) {
    if (json['company'] != null) {
      company = <Company>[];
      json['company'].forEach((v) {
        company!.add(Company.fromJson(v));
      });
    }
    if (json['user'] != null) {
      user1 = <User1>[];
      json['user'].forEach((v) {
        user1!.add(User1.fromJson(v));
      });
    }
    status = json['status'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (company != null) {
      data['company'] = company!.map((v) => v.toJson()).toList();
    }
    if (user1 != null) {
      data['user'] = user1!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['payment_status'] = paymentStatus;
    return data;
  }
}

class Company {
  int? id;
  String? employerId;
  String? comapnyName;
  String? noOfEmployee;
  String? employerName;
  String? phoneNumber;
  String? phoneCode;
  String? email;
  String? country;
  String? aboutCompany;
  String? address;
  String? image;
  String? imageExt;
  String? createdAt;
  String? updatedAt;
  String? rating;
  List<MyJobs>? myJobs;

  Company(
      {this.id,
      this.employerId,
      this.comapnyName,
      this.noOfEmployee,
      this.employerName,
      this.phoneNumber,
        this.phoneCode,
      this.email,
      this.country,
      this.aboutCompany,
      this.address,
      this.image,
      this.imageExt,
      this.createdAt,
      this.updatedAt,
      this.rating,
      this.myJobs});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employerId = json['employer_id'].toString();
    comapnyName = json['comapny_name'];
    noOfEmployee = json['no_of_employee'];
    employerName = json['employer_name'];
    phoneNumber = json['phone_number'];
    phoneCode = json['phone_code'];
    email = json['email'];
    country = json['country'];
    aboutCompany = json['about_company'];
    address = json['address'];
    image = json['image'];
    imageExt = json['image_ext'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    rating = json['rating'].toString();
    if (json['my_jobs'] != null) {
      myJobs = <MyJobs>[];
      json['my_jobs'].forEach((v) {
        myJobs!.add(MyJobs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employer_id'] = employerId;
    data['comapny_name'] = comapnyName;
    data['no_of_employee'] = noOfEmployee;
    data['employer_name'] = employerName;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['country'] = country;
    data['about_company'] = aboutCompany;
    data['address'] = address;
    data['image'] = image;
    data['image_ext'] = imageExt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['rating'] = rating;
    if (myJobs != null) {
      data['my_jobs'] = myJobs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyJobs {
  int? id;
  String? employerId;
  String? hireEmployer;
  String? jobTitle;
  String? jobDesc;
  String? salary;
  String? country;
  String? jobLocation;
  String? jobType;
  String? status;
  String? createdAt;
  String? updatedAt;

  MyJobs(
      {this.id,
      this.employerId,
      this.hireEmployer,
      this.jobTitle,
      this.jobDesc,
      this.salary,
      this.country,
      this.jobLocation,
      this.jobType,
      this.status,
      this.createdAt,
      this.updatedAt});

  MyJobs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employerId = json['employer_id'];
    hireEmployer = json['hire employer'];
    jobTitle = json['job_title'];
    jobDesc = json['job_desc'];
    salary = json['salary'];
    country = json['country'];
    jobLocation = json['job_location'];
    jobType = json['job_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employer_id'] = employerId;
    data['hire employer'] = hireEmployer;
    data['job_title'] = jobTitle;
    data['job_desc'] = jobDesc;
    data['salary'] = salary;
    data['country'] = country;
    data['job_location'] = jobLocation;
    data['job_type'] = jobType;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class User1 {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? paymentStatus;
  String? paymentDate;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  User1(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.paymentStatus,
      this.paymentDate,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

  User1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    paymentStatus = json['payment_status'].toString();
    paymentDate = json['payment_date'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['payment_status'] = paymentStatus;
    data['payment_date'] = paymentDate;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
