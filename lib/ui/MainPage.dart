// ignore_for_file: non_constant_identifier_names, unrelated_type_equality_checks, use_build_context_synchronously
import 'dart:async';
import 'package:ecosoftvmsvisitor/modals/classes.dart';
import 'package:ecosoftvmsvisitor/services/services.dart';
import 'package:ecosoftvmsvisitor/ui/sessionoverpage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key,
  });
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool namegiven = false;
  bool companygiven = false;
  bool phonenogiven = false;
  bool emailidgiven = false;
  bool purposegiven = false;
  bool staffgiven = false;
  bool numbergiven=false;
  bool aadhargiven=false;
  bool emailgiven=false;
  bool aadharvalid=false;
  bool valid= false;
  int pagenow=0;
  final _pagecontroller = PageController(initialPage: 1);
  List<Staff> allstaff = [];
  List<Staff> staffdisplay = [];
  List<Visitor> allvisitors=[];
  List<Visitor> visitordisplay =[];
  bool nosuchstaff = false;
  bool assetgiven=false;
  DateTime timestamp= DateTime(1990);
  bool nosuchvisitor=false;
  var staffselected = TextEditingController();
  var name = TextEditingController();
  var company = TextEditingController();
  var phoneno = TextEditingController();
  var email = TextEditingController();
  var purpose = TextEditingController();
  final _searchcontroller = TextEditingController();
  final _searchcontrollervisitor = TextEditingController();
  final aadharcontroller = TextEditingController();
  final assetcontroller = TextEditingController();

  final Services _s = Services();
  Future<void> sessionvalid() async{
    if(DateTime.now().isBefore(timestamp.add(const Duration(minutes: 30)))){
      setState(() {
        valid= true;
      });
      Timer(Duration(seconds: timestamp.add(const Duration(minutes: 30)).difference(DateTime.now()).inSeconds),(){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SessionNonExisting()));
      });
    }else{
      setState(() {
        valid=false;
      });
    }

  }

  Future<void> acquirestaffvisitor() async {
    List<Staff> temp = await _s.getallstaff() as List<Staff>;
    List<Visitor> temp2 = await _s.readVisitors() as List<Visitor>;

    setState(() {
      allstaff = temp;
      staffdisplay=temp;
      allvisitors=temp2;
      visitordisplay=temp2;
    });
  }
  Future<void> gettime() async{
    DateTime dt= await _s.gettimestamp();
    setState(() {
      timestamp=dt;
    });
    sessionvalid();
  }
  Future<void> mailStaff(Visitor v) async{

    String staffemail = await _s.getemail(v.staff);
    String token="wbzu hfiq oyad sftv";
    final smtpServer = gmail('testsptest223@gmail.com',token);
    final message = Message()
      ..from = const Address('testsptest223@gmail.com')
      ..recipients.add(staffemail)
      ..subject = 'Visitor Alert'
      ..text= ""
      ..html = "Hello ${v.staff}\nYou have a new Visitor waiting for approval.Please find the details below.\n<strong>Visitor Name:</strong> ${v.Name}</p><p><strong>Company Name:</strong> ${v.CompanyName}</p><p><strong>Visitor Email:&nbsp;</strong>${v.EmailId}&nbsp;</p><p><strong>Visiting Purpose:</strong> ${v.Purpose}</p><p><strong>Visitor Number: </strong>${v.phoneno}</p><p><strong>From VMS</strong></p>";

    try {
      await send(message, smtpServer);
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  void filterresult(String query) {
    setState(() {
      staffdisplay = allstaff
          .where((item) =>
          item.UserName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (staffdisplay.isEmpty) {
        setState(() {
          nosuchstaff = true;
        });
      }
    });
  }
  void filterresultvisitor(String query) {
    setState(() {
      visitordisplay = allvisitors
          .where((item) =>
          item.Name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (visitordisplay.isEmpty) {
        setState(() {
          nosuchvisitor = true;
        });
      }
    });
  }

  @override
  void initState(){
    acquirestaffvisitor();
    gettime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Future<void> choosestaff ()async{
      return showDialog(context: context, builder: (BuildContext context){
        return StatefulBuilder(builder: (context,setState){
          return AlertDialog(
            title: Text("Choose Staff",style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold),),
            content: SizedBox(
              height: size.height*0.5,
              width: size.width*0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: size.width*0.2,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(50))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: size.width*0.15,
                            height: 50,
                            child: Center(
                              child: TextField(
                                controller: _searchcontroller,
                                style: GoogleFonts.poppins(fontSize: 24),
                                decoration: InputDecoration(
                                    hintText: "Enter Name",
                                    hintStyle:
                                    GoogleFonts.poppins(fontSize: 24),
                                    border: InputBorder.none),
                                onChanged: (value) {
                                  setState(() {
                                    filterresult(value);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: size.width*0.3,
                      height: size.height*0.4,
                      child: ListView.builder(
                          itemCount: staffdisplay.length,
                          itemBuilder: (BuildContext context,int index){
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      staffselected.text=staffdisplay[index].UserName;
                                      staffgiven=true;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      width: size.width*0.27,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(40)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(60),
                                              child: staffdisplay[index].ProfileLink!=""?Image.network(staffdisplay[index].ProfileLink,width: 60,height: 60,fit: BoxFit.cover,):Image.asset("assets/profile.png",width: 60,height: 60,fit: BoxFit.cover,),
                                            ),
                                            Text(staffdisplay[index].UserName,style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold),),
                                            Text(staffdisplay[index].phoneno,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),)
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            );
                          }),
                    ),
                  )


                ],
              ),

            ),

          );
        });

      });

    }
    Future<void> choosevisitor ()async{
      return showDialog(context: context, builder: (BuildContext context){
        return StatefulBuilder(builder: (context,setState){
          return AlertDialog(
            title: Text("Choose Visitor",style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold),),
            content: SizedBox(
              height: size.height*0.5,
              width: size.width*0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: size.width*0.2,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(50))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.blue,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: size.width*0.15,
                            height: 50,
                            child: Center(
                              child: TextField(
                                controller: _searchcontrollervisitor,
                                style: GoogleFonts.poppins(fontSize: 24),
                                decoration: InputDecoration(
                                    hintText: "Enter Name",
                                    hintStyle:
                                    GoogleFonts.poppins(fontSize: 24),
                                    border: InputBorder.none),
                                onChanged: (value) {
                                  setState(() {
                                    filterresultvisitor(value);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: size.width*0.3,
                      height: size.height*0.4,
                      child: ListView.builder(
                          itemCount: visitordisplay.length,
                          itemBuilder: (BuildContext context,int index){
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      setState((){
                                        name.text=visitordisplay[index].Name;
                                        email.text=visitordisplay[index].EmailId;
                                        phoneno.text=visitordisplay[index].phoneno;
                                        aadharcontroller.text=visitordisplay[index].aadharnumber;
                                        company.text=visitordisplay[index].CompanyName;
                                        _searchcontrollervisitor.clear();
                                        namegiven=true;
                                        emailgiven=true;
                                        numbergiven=true;
                                        aadhargiven=true;
                                        companygiven=true;

                                      });

                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      width: size.width*0.27,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(40)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(visitordisplay[index].Name,style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold),),
                                            Text(visitordisplay[index].phoneno,style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54),)
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            );
                          }),
                    ),
                  )


                ],
              ),

            ),

          );
        });

      });

    }
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: size.width*0.3,
              height: size.height,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/vmspic.jpeg",width: 300,),
                  const SizedBox(height: 50,),
                  Text("Welcome to VMS",style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold),),
                  Text("Please register your details here",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),)

                ],
              ),
            ),
            Center(
              child: !valid?SizedBox(
                width: size.width*0.7,
                height: size.height,
                child: Center(
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Session doesnt Exist",style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold),),
                      Text("Ask the staff to resend the link",style: GoogleFonts.questrial(fontSize: 24,color: Colors.black54),)
                    ],
                  ),
                ),
              ):Container(
                width: size.width*0.7,
                height: size.height,
                color: Colors.grey.shade300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: size.width*0.4,
                      height: size.height*0.7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.grey.shade300,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black38,
                                blurRadius: 15,
                                offset: Offset(10,10)
                            ),
                            BoxShadow(
                                color: Colors.white,
                                blurRadius: 15,
                                offset: Offset(-10,-10)
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                            child: Container(
                              width: size.width*0.15,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              )      ,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedContainer(
                                      duration: const Duration(milliseconds: 500),
                                      width: pagenow==0?size.width*0.02:size.width*0.15,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(10)
                                      )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height*0.6,
                            width: size.width*0.4,
                            child: PageView(
                              controller: _pagecontroller,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: size.width*0.25,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                                        child: TextField(
                                            controller: company,
                                            onChanged: (value){
                                              setState(() {
                                                companygiven= (value!="");
                                              });
                                            },
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(Icons.people_alt_outlined,color: companygiven?Colors.green:Colors.blueGrey,size: 30,),
                                                hintText: "Company Name",
                                                hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                            ),
                                            style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width*0.25,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: size.width*0.15,
                                              height: 60,
                                              child: TextField(
                                                  controller: staffselected,
                                                  onChanged: (value){
                                                    setState(() {
                                                      staffgiven=value!="";
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      icon: Icon(Icons.people_alt_outlined,color: staffselected.text!=""?Colors.green:Colors.blueGrey,size: 30,),
                                                      hintText: "Staff to be Visited",
                                                      hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                                  ),
                                                  style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                              ),
                                            ),
                                            TextButton(onPressed: (){
                                              choosestaff();


                                            },child: Text("Choose",style: GoogleFonts.questrial(fontSize: 28,color: Colors.blue),),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width*0.25,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                                        child: TextField(
                                            controller: purpose,
                                            onChanged: (value){
                                              setState(() {
                                                purposegiven=value!="";
                                              });
                                            },
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(Icons.dashboard_outlined,color: purposegiven?Colors.green:Colors.blueGrey,size: 30,),
                                                hintText: "Purpose",
                                                hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                            ),
                                            style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width*0.25,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                                        child: TextField(
                                            controller: assetcontroller,
                                            onChanged: (value){
                                              setState(() {
                                                assetgiven=value!="";
                                              });
                                            },
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(Icons.laptop,color: assetgiven?Colors.green:Colors.blueGrey,size: 30,),
                                                hintText: "Assets Brought",
                                                hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                            ),
                                            style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: ()async{
                                        if(companygiven && staffgiven &&purposegiven&&assetgiven){
                                          _pagecontroller.jumpToPage(2);
                                          Visitor v = Visitor(Name: name.text, CompanyName: company.text, phoneno: phoneno.text, EmailId: email.text, Purpose: purpose.text, id: name.text+phoneno.text, staff: staffselected.text, aadharnumber: aadharcontroller.text, assets: assetcontroller.text);
                                          await _s.addVisitor(v).then((value){
                                            setState(() {
                                              name.clear();
                                              email.clear();
                                              phoneno.clear();
                                              aadharcontroller.clear();
                                              staffselected.clear();
                                              purpose.clear();
                                              assetcontroller.clear();
                                              namegiven=false;
                                              emailgiven=false;
                                              numbergiven=false;
                                              aadhargiven=false;
                                              companygiven=false;
                                              staffgiven=false;
                                              purposegiven=false;
                                              assetgiven=false;
                                              pagenow=0;
                                            });

                                            FloatingSnackBar(message: "Visit Added", context: context,textStyle: GoogleFonts.questrial(fontSize: 24));
                                          }).catchError((error){
                                            FloatingSnackBar(message: "An error has occurred", context: context,textStyle: GoogleFonts.questrial(fontSize: 24));
                                          });

                                        }else{
                                          FloatingSnackBar(message: "Fill all the necessary details", context: context,textStyle: GoogleFonts.questrial(fontSize: 24));
                                        }

                                      },
                                      child: Container(
                                        width: size.width*0.25,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Center(child: Text("Create Visit",style: GoogleFonts.questrial(fontSize: 32,color: Colors.white),)),
                                      ),
                                    ),

                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: size.width*0.25,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                                        child: TextField(
                                            controller: name,
                                            onChanged: (value){
                                              setState(() {
                                                namegiven=(value!="");
                                              });
                                            },
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(Icons.person_outline,color: namegiven?Colors.green:Colors.blueGrey,size: 30,),
                                                hintText: "Full Name of the Visitor",
                                                hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                            ),
                                            style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width*0.25,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                                        child: TextField(
                                            controller: email,
                                            onChanged: (value){
                                              setState(() {
                                                emailgiven=EmailValidator.validate(value);
                                              });
                                            },
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(Icons.mail_outline,color: emailgiven?Colors.green:Colors.blueGrey,size: 30,),
                                                hintText: "Email Address",
                                                hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                            ),
                                            style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width*0.25,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                                        child: TextField(
                                            controller: phoneno,
                                            onChanged: (value){
                                              setState(() {
                                                numbergiven= value.length==10;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(Icons.phone_outlined,color: numbergiven?Colors.green:Colors.blueGrey,size: 30,),
                                                hintText: "Phone Number",
                                                hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                            ),
                                            style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width*0.25,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                                        child: TextField(
                                            controller: aadharcontroller,
                                            onChanged: (value){
                                              final check= num.tryParse(value);
                                              if(check!=null){
                                                if(value.length==12 && value[0]!="0" && value[0]!="1"){
                                                  setState(() {
                                                    aadhargiven=true;
                                                  });
                                                }else{
                                                  setState(() {
                                                    aadhargiven=false;
                                                  });
                                                }
                                              }else{
                                                setState(() {
                                                  aadhargiven=false;
                                                });
                                              }

                                            },
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(Icons.credit_card,color: aadhargiven?Colors.green:Colors.blueGrey,size: 30,),
                                                hintText: "Aadhar Number",
                                                hintStyle: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                            ),
                                            style: GoogleFonts.questrial(fontSize: 28,color: Colors.black54)
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        if(namegiven && emailgiven && numbergiven && aadhargiven){
                                          _pagecontroller.jumpToPage(-1);
                                          setState(() {
                                            pagenow=1;
                                          });
                                        }
                                        else{
                                          FloatingSnackBar(message: "Fill All the necessary details", context: context,textStyle: GoogleFonts.questrial(fontSize: 24));
                                        }


                                      },
                                      child: Container(
                                        width: size.width*0.25,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Center(child: Text("Next",style: GoogleFonts.questrial(fontSize: 32,color: Colors.white),)),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: (){
                        choosevisitor();

                      },
                      child: Text("Existing Visitor?",style: GoogleFonts.questrial(fontSize: 32,fontWeight: FontWeight.bold,color: Colors.black54),),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}

