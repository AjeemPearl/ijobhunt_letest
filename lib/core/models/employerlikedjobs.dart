class EmployerLikedJob {
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
  int? likes;

  EmployerLikedJob(
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
      this.updatedAt,
      this.likes});

  EmployerLikedJob.fromJson(Map<String, dynamic> json) {
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
    likes = json['likes'];
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
    data['likes'] = likes;
    return data;
  }
}
