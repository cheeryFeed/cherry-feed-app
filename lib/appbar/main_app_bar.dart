import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize {
    return const Size.fromHeight(60);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xffFAFAFA),
      centerTitle: false,
      leadingWidth: 250,
      leading: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'CherryFeed',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
          ),
          padding: EdgeInsets.only(left: 190, right: 190),
          child: SizedBox(height: 1),
        ),
      ),
      // 그림자 효과 없애기.
      elevation: 0.0,
      // 110 - 상태바의 크기.
      toolbarHeight: (110 - MediaQuery.of(context).padding.top),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: SizedBox(
            width: 60,
            child: IconButton(
              icon: Image.asset(
                'assets/images/profile_icon.png',
              ),
              color: Colors.black,
              onPressed: () {
                // 프로필 아이콘을 눌렀을 때 동작할 코드를 작성합니다.
              },
            ),
          ),
        ),
      ],
    );
  }
}
