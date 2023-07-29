import 'package:cherry_feed/screen/calendar_screen.dart';
import 'package:flutter/material.dart';

class ContentHeader extends StatelessWidget {
  final String title;
  final String description;
  final Widget wordOnClick;
  const ContentHeader({Key? key, required this.title, required this.description, required this.wordOnClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              height: 30,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 200,
              height: 30,
              child: Text(
                description,
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 18,
                    color: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 86,
        ),
        Column(
          children: [
            SizedBox(
              child: TextButton(
                child: Text(
                    '전체보기',
                    style: TextStyle(
                      fontSize: 19,
                      height: 1.3,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Pretendard',
                      letterSpacing: 0,
                      color: Color(0xffEE4545),
                    )
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> wordOnClick));
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        )
      ],
    );
  }
}
