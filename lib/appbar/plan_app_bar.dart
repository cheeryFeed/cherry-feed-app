import 'package:cherry_feed/button/next_button.dart';
import 'package:flutter/material.dart';

class PlanAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PlanAppBar({Key? key}) : super(key: key);
  final double height = 400;
  @override
  Size get preferredSize {
    return Size.fromHeight(height);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/dummy/ex_3.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          height: double.infinity,
          width: double.infinity,
        ),
        AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          leadingWidth: 100,
          leading: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '계획',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          // 그림자 효과 없애기.
          elevation: 0.0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SizedBox(
                width: 60,
                child: IconButton(
                  icon: Icon(Icons.photo_camera_back_outlined, size: 36,),
                  color: Colors.white,
                  onPressed: () {
                    // 프로필 아이콘을 눌렀을 때 동작할 코드를 작성합니다.
                  },
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom:  height - 60,
          left: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
            padding: EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(height: 1),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 20,
          right: 20,
          child: NextButton(text: '계획 추가', onPressed: (){},
              isHalf: false, backgroundColor: Color(0xffEE4545), textColor: Colors.white),
        ),
      ],
    );
  }
}
