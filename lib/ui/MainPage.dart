import 'dart:ui';

import 'package:ecosoftvmsvisitor/modals/classes.dart';
import 'package:ecosoftvmsvisitor/services/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key,
    required this.Name,
    required this.CompanyName,
    required this.Phoneno,
    required this.EmailId,
    required this.Aadharnumber
  });

  final String Name;
  final String CompanyName;
  final String Phoneno;
  final String EmailId;
  final String Aadharnumber;

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
  bool aadharvalid=false;
  List<Staff> allstaff = [];
  List<Staff> itemsdisplay = [];
  bool nosuchstaff = false;
  var staffselected = TextEditingController();
  var name = TextEditingController();
  var company = TextEditingController();
  var phoneno = TextEditingController();
  var email = TextEditingController();
  var purpose = TextEditingController();
  final _searchcontroller = TextEditingController();
  final aadharcontroller = TextEditingController();
  final Services _s = Services();

  Future<void> acquirestaff() async {
    List<Staff> temp = await _s.getallstaff() as List<Staff>;
    setState(() {
      allstaff = temp;
      itemsdisplay = temp;
    });
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
    }
  }
  void filterresult(String query) {
    setState(() {
      itemsdisplay = allstaff
          .where((item) =>
          item.UserName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (itemsdisplay.isEmpty) {
        setState(() {
          nosuchstaff = true;
        });
      }
    });
  }

  void initialise() {
    if (widget.Name != "") {
      setState(() {
        name.text = widget.Name;
        company.text = widget.CompanyName;
        phoneno.text = widget.Phoneno;
        email.text = widget.EmailId;
        aadharcontroller.text=widget.Aadharnumber;
        namegiven = true;
        companygiven = true;
        phonenogiven = true;
        emailidgiven = true;
        aadharvalid=true;
      });
    }
  }

  @override
  void initState() {
    initialise();
    acquirestaff();
    itemsdisplay = allstaff;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Future<void> _selectstaff() async {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: const Color(0xFFE1E8F0),
                  title: Text(
                    "Choose Staff..",
                    style: GoogleFonts.questrial(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  content: SizedBox(
                    width: kIsWeb?500:size.width * 0.8,
                    height: size.height * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: kIsWeb?(400):size.width * 0.8,
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
                                  width: kIsWeb?(250):size.width * 0.55,
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
                          padding: const EdgeInsets.only(top: 20.0),
                          child: SizedBox(
                            width: size.width * 0.8,
                            height: size.height * 0.4,
                            child: itemsdisplay.isEmpty
                                ? Center(
                              child: Text("No such Staff..",
                                  style: GoogleFonts.questrial(
                                      fontSize: 24,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold)),
                            )
                                : GridView.builder(
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1/1.3,
                                    crossAxisCount: kIsWeb?3:2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10),

                                itemCount: itemsdisplay.length,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        staffselected.text =
                                            itemsdisplay[index].UserName;
                                        staffgiven = true;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            ClipRect(
                                              child: Image.asset(
                                                "assets/profile.png",
                                                width: kIsWeb?size.width*0.15:size.width * 0.25,
                                              ),
                                            ),
                                            Text(
                                              itemsdisplay[index].UserName,
                                              style: GoogleFonts.questrial(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                  );
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          });
    }
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(clipBehavior: Clip.none, children: [

          Positioned(
              top: 0,
              child: kIsWeb?Image.asset("assets/webbg.jpg",height: size.height,width:size.width,fit: BoxFit.fill,alignment: Alignment.bottomCenter,):Image.asset("assets/UserBG.jpeg",height: size.height,fit: BoxFit.fill,alignment: Alignment.bottomCenter,)),
          Positioned(
            top: 0,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaY: 10,sigmaX: 10),
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.black.withOpacity(0)],
                          stops: const [0.7, 0.9]).createShader(rect);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Container(color: const Color(0xeeeeeeee)),
                  )
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: size.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, bottom: 10),
                        child: Text(
                          "Enter Details",
                          style: GoogleFonts.questrial(
                              fontSize: 32,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: kIsWeb?(size.width*0.4>400?size.width*0.4:400):size.width * 0.8,
                      child: Material(
                        elevation: 4.0,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            style: GoogleFonts.questrial(fontSize: 22),
                            onChanged: (value) {
                              if (value != "") {
                                setState(() {
                                  namegiven = true;
                                });
                              } else {
                                namegiven = false;
                              }
                            },
                            controller: name,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              label: Text(
                                "Name of Visitor",
                                style: GoogleFonts.questrial(fontSize: 22),
                              ),
                              icon: Icon(
                                Icons.person_outline,
                                color: namegiven ? Colors.green : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: kIsWeb?(size.width*0.4>400?size.width*0.4:400):size.width * 0.8,
                      child: Material(
                        elevation: 4.0,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: (value) {
                              if (value != "") {
                                setState(() {
                                  companygiven = true;
                                });
                              } else {
                                companygiven = false;
                              }
                            },
                            style: GoogleFonts.questrial(fontSize: 22),
                            controller: company,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              label: Text("Company Name",
                                  style: GoogleFonts.questrial(fontSize: 22)),
                              icon: Icon(
                                Icons.apartment,
                                color:
                                companygiven ? Colors.green : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: kIsWeb?(size.width*0.4>400?size.width*0.4:400):size.width * 0.8,
                      child: Material(
                        elevation: 4.0,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: (value) {
                              if (value != "") {
                                setState(() {
                                  phonenogiven = (phoneno.text.length == 10);
                                });
                              } else {
                                phonenogiven = false;
                              }
                            },
                            style: GoogleFonts.questrial(fontSize: 22),
                            controller: phoneno,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              label: Text("Phone no",
                                  style: GoogleFonts.questrial(fontSize: 22)),
                              icon: Icon(
                                Icons.phone,
                                color:
                                phonenogiven ? Colors.green : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: kIsWeb?(size.width*0.4>400?size.width*0.4:400):size.width * 0.8,
                      child: Material(
                        elevation: 4.0,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: (value) {
                              if (value != "") {
                                setState(() {
                                  emailidgiven =
                                      EmailValidator.validate(email.text);
                                });
                              } else {
                                emailidgiven = false;
                              }
                            },
                            style: GoogleFonts.questrial(fontSize: 22),
                            controller: email,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              label: Text("Email Id",
                                  style: GoogleFonts.questrial(fontSize: 22)),
                              icon: Icon(
                                Icons.email,
                                color:
                                emailidgiven ? Colors.green : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: kIsWeb?(size.width*0.4>400?size.width*0.4:400):size.width * 0.8,
                      child: Material(
                        elevation: 4.0,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: (value) {
                              final check= num.tryParse(value);
                              if(check!=null){
                                if(value.length==12 && value[0]!="0" && value[0]!="1"){
                                  setState(() {
                                    aadharvalid=true;
                                  });
                                }else{
                                  setState(() {
                                    aadharvalid=false;
                                  });
                                }
                              }else{
                                setState(() {
                                  aadharvalid=false;
                                });
                              }

                            },
                            style: GoogleFonts.questrial(fontSize: 22),
                            controller: aadharcontroller,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              label: Text("Enter Aadhar Number",
                                  style: GoogleFonts.questrial(fontSize: 22)),
                              icon: Icon(
                                Icons.add_card_rounded,
                                color:
                                aadharvalid ? Colors.green : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: kIsWeb?(size.width*0.4>400?size.width*0.4:400):size.width * 0.8,
                      child: Material(
                          elevation: 4.0,
                          shadowColor: Colors.black,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: kIsWeb?size.width*0.2:size.width * 0.53,
                                  child: TextField(
                                    controller: staffselected,
                                    style: GoogleFonts.questrial(fontSize: 22),
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Select Staff",
                                      hintStyle:
                                      GoogleFonts.questrial(fontSize: 22),
                                      icon: Icon(
                                        Icons.person,
                                        color: staffgiven
                                            ? Colors.green
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      _selectstaff();
                                      if(staffselected!=""){
                                        setState(() {
                                          staffgiven=true;
                                        });
                                      }else{
                                        setState(() {
                                          staffgiven=false;
                                        });
                                      }
                                    },
                                    child: Text(
                                      "Choose..",
                                      style: GoogleFonts.questrial(
                                          fontSize: 22, color: Colors.blue),
                                    ))
                              ],
                            ),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: kIsWeb?(size.width*0.4>400?size.width*0.4:400):size.width * 0.8,
                      child: Material(
                        elevation: 4.0,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: (value) {
                              if (value != "") {
                                setState(() {
                                  purposegiven = true;
                                });
                              } else {
                                purposegiven = false;
                              }
                            },
                            style: GoogleFonts.questrial(fontSize: 22),
                            controller: purpose,
                            autocorrect: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              label: Text("Purpose of Visit",
                                  style: GoogleFonts.questrial(fontSize: 22)),
                              icon: Icon(
                                Icons.dashboard,
                                color:
                                purposegiven ? Colors.green : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: kIsWeb?(size.width*0.4>400?size.width*0.4:400):size.width * 0.8,
                      child: Material(
                        elevation: 4.0,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: (value) {
                              if (value != "") {
                                setState(() {
                                  purposegiven = true;
                                });
                              } else {
                                purposegiven = false;
                              }
                            },
                            style: GoogleFonts.questrial(fontSize: 22),
                            controller: purpose,
                            autocorrect: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              label: Text("Add assets you will bring in",
                                  style: GoogleFonts.questrial(fontSize: 22)),
                              icon: Icon(
                                Icons.laptop,
                                color:
                                purposegiven ? Colors.green : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Visitor v = Visitor(
                              Name: name.text,
                              CompanyName: company.text,
                              phoneno: phoneno.text,
                              EmailId: email.text,
                              Purpose: purpose.text,
                              id: name.text + phoneno.text,
                              aadharnumber: aadharcontroller.text,
                              staff: staffselected.text);
                          if (namegiven &&
                              companygiven &&
                              phonenogiven &&
                              emailidgiven &&
                              aadharvalid &&
                              purposegiven) {
                            await _s.addVisitor(v);
                            setState(() {
                              name.clear();
                              company.clear();
                              phoneno.clear();
                              email.clear();
                              purpose.clear();
                              aadharcontroller.clear();
                              namegiven = false;
                              companygiven = false;
                              phonenogiven = false;
                              emailidgiven = false;
                              aadharvalid=false;
                              purposegiven = false;
                              staffselected.clear();
                              staffgiven=false;

                            });
                            await mailStaff(v);
                            FloatingSnackBar(
                                message: 'Request sent!',
                                context: context,
                                textStyle: GoogleFonts.questrial(
                                    fontSize: 18, fontWeight: FontWeight.bold));
                          } else {
                            FloatingSnackBar(
                                message: "Please fill the details correctly!",
                                context: context,
                                textStyle: GoogleFonts.questrial(
                                    fontWeight: FontWeight.bold, fontSize: 18));
                          }
                        },
                        child: Container(
                          width: kIsWeb?200:size.width * 0.3,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[500]!,
                                    blurRadius: 10,
                                    offset: const Offset(4, 4),
                                    spreadRadius: 0.5),
                                const BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 10,
                                    offset: Offset(-5, -5),
                                    spreadRadius: 1)
                              ]),
                          child: Center(
                              child: Text(
                                "Create Visit",
                                style: GoogleFonts.questrial(
                                    fontSize: 24,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: size.width * 0.2,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(30))),
                      ),
                      Text(
                        "or",
                        style: GoogleFonts.questrial(fontSize: 24,color: Colors.white),
                      ),
                      Container(
                        width: size.width * 0.2,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(30))),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextButton(
                    child: Text(
                      "Existing Visitor?",
                      style: GoogleFonts.questrial(
                          color: Colors.white, fontSize: 24),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExistingVisitorPage()));
                    },
                  )
                ],
              ),
            ),
          ),

          Visibility(
            visible: !kIsWeb,
            child: Positioned(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(onPressed: (){
                Navigator.pop(context);
              },icon: const Icon(Icons.keyboard_double_arrow_left,size: 50,),),
            )),
          ),
        ]),
      ),
    );
  }
}

class ExistingVisitorPage extends StatefulWidget {
  const ExistingVisitorPage({super.key});

  @override
  State<ExistingVisitorPage> createState() => _ExistingVisitorPageState();
}

class _ExistingVisitorPageState extends State<ExistingVisitorPage> {
  List<Visitor> visitors = [];
  List<Visitor> items = [];
  final Services _s = Services();
  Future<void> getallvisitors() async {
    List<Visitor> temp = await _s.readVisitors() as List<Visitor>;
    setState(() {
      visitors = temp;
      items = temp;
    });
  }

  var nosuchvisitor = false;
  @override
  void initState() {
    getallvisitors();
    items = visitors;
    super.initState();
  }

  void filterresult(String query) {
    setState(() {
      items = visitors
          .where(
              (item) => item.Name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (items.isEmpty) {
        setState(() {
          nosuchvisitor = true;
        });
      }
    });
  }

  var search = TextEditingController();
  var purpose = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(clipBehavior: Clip.none, children: [
          Positioned(
              top: 0,
              child: kIsWeb?Image.asset("assets/webbg.jpg",height: size.height,width:size.width,fit: BoxFit.fill,alignment: Alignment.bottomCenter,):Image.asset("assets/UserBG.jpeg",height: size.height,fit: BoxFit.fill,alignment: Alignment.bottomCenter,)),
          Positioned(
            top: 0,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaY: 10,sigmaX: 10),
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.black.withOpacity(0)],
                          stops: const [0.7, 0.9]).createShader(rect);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Container(color: const Color(0xeeeeeeee)),
                  )
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Search For Existing Visitors",
                    style: GoogleFonts.questrial(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    width: size.width * 0.73,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.all(Radius.circular(50))),
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
                          width: size.width * 0.55,
                          height: 50,
                          child: Center(
                            child: TextField(
                              controller: search,
                              style: GoogleFonts.poppins(fontSize: 24),
                              decoration: InputDecoration(
                                  hintText: "Enter Name",
                                  hintStyle: GoogleFonts.poppins(fontSize: 24),
                                  border: InputBorder.none),
                              onChanged: (value) {
                                filterresult(value);
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: size.height * 0.75,
                  width: size.width,
                  child: items.isEmpty
                      ? Center(
                    child: Text(
                      nosuchvisitor
                          ? "No Such Visitor Exists"
                          : "Loading...",
                      style: GoogleFonts.questrial(
                          fontSize: 35,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                      : GridView.builder(
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1/1.3,
                          crossAxisCount: kIsWeb?(size.width>800?5:size.width>500?4:3):3, mainAxisSpacing: 20),
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(
                                    Name: items[index].Name,
                                    CompanyName:
                                    items[index].CompanyName,
                                    Phoneno: items[index].phoneno,
                                    EmailId: items[index].EmailId, Aadharnumber: items[index].aadharnumber,),

                                ));
                          },
                          child: Column(
                            children: [
                              ClipRect(
                                child: Image.asset(
                                  "assets/profile.png",
                                  width: kIsWeb?(size.width>700?200:size.width>600?size.width*0.2:size.width*0.25):size.width * 0.25,
                                ),
                              ),
                              Center(
                                  child: Text(
                                    items[index].Name,
                                    style: GoogleFonts.questrial(fontSize: 24),
                                  )),
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

