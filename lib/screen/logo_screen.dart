import 'package:cherry_feed/appbar/customAppBar.dart';
import 'package:cherry_feed/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogoScreen extends StatelessWidget {
  const LogoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(isShow: false,),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Center(
          child: Column(
            children: [
              Text(
                'Brand Slogan \n'
                'Type Something.',
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  'Service Logo',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              SizedBox(height: 200,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: BorderSide.none, // 여기에 추가
                    ),
                  ),
                ),
                child: Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/img.png'),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
