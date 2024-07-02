class ApiRoutes {
  static const String baseUrl = 'http://ijobshunts.com/public/';
  static const String signupurl = baseUrl+"api/signup";
  static const String loginapi = baseUrl+"api/login";
  static const String jobsapi = baseUrl+"index.php/api/jobs";
  static const String psotjobsapi = baseUrl+"index.php/api/post-job";
  static const String psotcompanydata = baseUrl+"index.php/api/post-company";
  static const String getcompanydata = baseUrl+"index.php/api/get-company";
  static const String getpaymentapi = baseUrl+"index.php/api/handle-payment";
  static const String getcompaniesapi = baseUrl+"api/get-companies";
  static const String getcocountriesapi = baseUrl+"api/country";
  static const String favJobs = baseUrl+"api/post-like";
  static const String removefavjobs = baseUrl+"api/post-like-delete";
  static const String getfavJobs = baseUrl+"api/get-like-job";
  static const String getuserdata = baseUrl+'api/get-user';
  static const String getcount = baseUrl+'api/post-rating';
  static const String postQuestions = baseUrl+'api/post-query';
  static const String deleteJobs = baseUrl+'api/delete-job';
  static const String updateJobs = baseUrl+'api/update-job';
  static const String updateuser = baseUrl+'api/update-user';
  static const String getnotification = baseUrl+'api/get-notification';
  // static const String searchcandidates =
  //     'http://ijobshunts.com/public/api/get-employee';
  static const String getrecomndedcondidates = baseUrl+'api/get-recomended';
  static const String getemployerlikedjobs = baseUrl+'api/get-likes-count';
  static const String forgotepassword = baseUrl+'api/forgot-password';
  static const String veryfiotp = baseUrl+'api/verify-otp';
  static const String changepassword = baseUrl+'api/change-password';
  static const String deleteaccount = baseUrl+'api/delete-account';

  static const String searchjobs = baseUrl+'api/advance-search-employee';

  static const String searchcaniddate = baseUrl+'api/advance-search-employer';
  static const String countryCodes = baseUrl+'api/phoneCode';
}
