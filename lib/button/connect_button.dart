import 'package:cherry_feed/screen/join/connect_feed_screen.dart';
import 'package:flutter/material.dart';

import '../models/user/user.dart';

class ConnectButton extends StatelessWidget {
  final User user;
  const ConnectButton({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: const Color(0xFF45450),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                width: 70,
                height: 70,
                child: Image.asset('assets/images/heart_asset.png'),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>ConnectFeedScreen(user: user))),
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Column(
                  children: const [
                    SizedBox(
                      width: 220,
                      child: Text(
                        '일정을 함께 할 사람이 있나요?',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.33,
                          fontFamily: 'Pretendard',
                          letterSpacing: 0,
                          color: Color(0xFF202020),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: Text(
                        '상대방과 연결하기',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          height: 1.29,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                          color: Color(0xFFEE4545),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 20,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  color: Color(0xFFEE4545),
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
