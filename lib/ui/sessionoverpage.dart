import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SessionNonExisting extends StatefulWidget {
  const SessionNonExisting({super.key});

  @override
  State<SessionNonExisting> createState() => _SessionNonExistingState();
}

class _SessionNonExistingState extends State<SessionNonExisting> {
  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
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
          SizedBox(
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
          )
        ],
      ),
    );
  }
}
