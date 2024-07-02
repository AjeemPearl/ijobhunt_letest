// ignore_for_file: unnecessary_new

class Getcompanies {
  int? id;
  int? employerId;
  String? comapnyName;
  String? noOfEmployee;
  String? employerName;
  String? phoneNumber;
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

  Getcompanies(
      {this.id,
      this.employerId,
      this.comapnyName,
      this.noOfEmployee,
      this.employerName,
      this.phoneNumber,
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

  Getcompanies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employerId = json['employer_id'];
    comapnyName = json['comapny_name'];
    noOfEmployee = json['no_of_employee'];
    employerName = json['employer_name'];
    phoneNumber = json['phone_number'];
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
        myJobs!.add(new MyJobs.fromJson(v));
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
  String? currency;
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
      this.currency,
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
    currency = json['currency'];
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
    data['currency'] = currency;
    data['country'] = country;
    data['job_location'] = jobLocation;
    data['job_type'] = jobType;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
