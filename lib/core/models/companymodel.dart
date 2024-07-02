class Companies {
  int? id;
  String? employerId;
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

  Companies(
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
      this.updatedAt});

  Companies.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
