import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecosoftvmsvisitor/modals/classes.dart';
import 'package:intl/intl.dart';

class Services{
  final FirebaseFirestore firestore=FirebaseFirestore.instance;
  Future<List> getallstaff() async{
    List<Staff> staffs=[];
    final snapshot=await firestore.collection("Staff").get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    for(DocumentSnapshot element in documents){
      staffs.add(Staff(EmailId: element["EmailId"], UserName: element["UserName"],phoneno: element["Phoneno"]));
    }
    return staffs;
  }
  Future<String> getemail(String staff) async{
    String temp="";
    final snapshot = await firestore.collection("Staff").get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    for(DocumentSnapshot element in documents){
      if(element["UserName"]==staff){
        temp=element["EmailId"];
      }
    }
    return temp;
  }
  Future<void> addVisitor(Visitor newVisitor) async{

    var currentdate= DateFormat("dd-MM-yyyy").format(DateTime.now());
    var currenttime = DateFormat.Hm().format(DateTime.now());
    Map<String,dynamic> obj={
      "VisitorName": newVisitor.Name,
      "CompanyName": newVisitor.CompanyName,
      "Phoneno": newVisitor.phoneno,
      "Emailid": newVisitor.EmailId,
      "Purpose": newVisitor.Purpose,
      "id": newVisitor.id,
      "aadharnumber": newVisitor.aadharnumber,
      "requesteddatetime": currentdate+"&"+currenttime,
      "Staff": newVisitor.staff
    };
    Map<String,dynamic> obj2={
      "VisitorName": newVisitor.Name,
      "CompanyName": newVisitor.CompanyName,
      "Phoneno": newVisitor.phoneno,
      "Emailid": newVisitor.EmailId,
      "aadharnumber": newVisitor.aadharnumber,
      "id": newVisitor.id,
      "lastvisit": currentdate
    };

    String docId= newVisitor.id;
    final DocumentReference tasksRef=firestore.collection("Requested").doc(docId);
    final DocumentReference tasksRef2=firestore.collection("AllVisitors").doc(docId);
    await tasksRef.set(obj);
    await tasksRef2.set(obj2);
    print("Added");
  }
  Future<List> readVisitors() async{
    List<Visitor> visitors=[];
    final snapshot=await firestore.collection("AllVisitors").get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    for(DocumentSnapshot element in documents){
      visitors.add(Visitor(Name: element["VisitorName"],aadharnumber: element["aadharnumber"], CompanyName: element["CompanyName"], phoneno: element["Phoneno"], EmailId: element["Emailid"], Purpose:"", id: element["id"],staff: ""));
    }
    return visitors;


  }
}