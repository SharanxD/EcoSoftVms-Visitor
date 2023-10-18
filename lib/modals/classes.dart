class Visitor{
  Visitor({required this.Name,required this.CompanyName,required this.phoneno,required this.EmailId,required this.Purpose,required this.id,required this.staff,required this.aadharnumber,required this.assets});
  final String Name;
  final String CompanyName;
  final String phoneno;
  final String EmailId;
  final String Purpose;
  final String id;
  final String staff;
  final String aadharnumber;
  final String assets;
}
class Staff{
  Staff({required this.EmailId,required this.UserName,required this.phoneno,required this.ProfileLink});
  final String UserName;
  final String EmailId;
  final String phoneno;
  final String ProfileLink;
}

class LogBook{
  LogBook({required this.VisitorName, required this.Purpose,required this.Checkedin,required this.Checkedout,required this.id,required this.CompanyName,required this.emailId,required this.Phoneno,required this.Staff});
  final String VisitorName;
  final String CompanyName;
  final String Phoneno;
  final String emailId;
  final String Staff;
  final String Purpose;
  final String Checkedin;
  final String Checkedout;
  final String id;
}
class Requests{
  Requests({required this.aadharnumber,required this.assets,required this.ReqTime,required this.Name,required this.CompanyName,required this.phoneno,required this.EmailId,required this.Purpose,required this.id,required this.staff});
  final String Name;
  final String CompanyName;
  final String phoneno;
  final String EmailId;
  final String Purpose;
  final String id;
  final String staff;
  final String ReqTime;
  final String aadharnumber;
  final String assets;

}