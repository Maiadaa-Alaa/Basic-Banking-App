import 'package:flutter/material.dart';
import 'package:BasicBankingApp/Utils/constants.dart';
import 'package:BasicBankingApp/Screens/home.dart';
import 'package:lottie/lottie.dart';
class DisplayScreen extends StatelessWidget {
  const DisplayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor.backgroundContainer,
      body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
             'https://lottie.host/7db4056f-5285-42df-8178-32dd7c2d4c50/Sgc5bLJZ2b.json',
          height: 400, // Adjust the height as needed
          width: 300, // Adjust the width as needed
          repeat: true,
        ),
           
            SizedBox(height: 7),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
              },
              child: Container(
                height: height * 0.068,
                width: width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.backgroundColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ 
                    SizedBox(width: 5),
                    Text(
                      'Display Customers',
                      style: TextStyle(
                        color: AppColor.textColorWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
