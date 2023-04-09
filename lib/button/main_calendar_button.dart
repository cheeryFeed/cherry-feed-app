import 'package:flutter/material.dart';

class MainCalendarButton extends StatelessWidget {
  const MainCalendarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF4F4F4),
            Color(0xFFFAFAFA),
          ],
          stops: [0, 1],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x29000000),
            offset: Offset(4, 4),
            blurRadius: 8,
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: Image.asset('assets/images/calendar_icon.png'),
          ),
          const Text(
            '기념하고 싶은\n 하루가 언제인가요 ?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text(
                    '기념일 등록',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEE4545),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFFEE4545), size: 28,),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
