class FevJobsGetModel {
  int? id;
  int? userId;
  int? jobId;
  String? createdAt;
  String? updatedAt;
  Job? job;

  FevJobsGetModel(
      {this.id,
      this.userId,
      this.jobId,
      this.createdAt,
      this.updatedAt,
      this.job});

  FevJobsGetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    jobId = json['job_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    job = json['job'] != null ? Job.fromJson(json['job']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['job_id'] = jobId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (job != null) {
      data['job'] = job!.toJson();
    }
    return data;
  }
}

class Job {
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

  Job(
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

  Job.fromJson(Map<String, dynamic> json) {
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
