import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isShow;
  final bool isBorder;
  const CustomAppBar({Key? key, required this.isShow, required this.isBorder,}) : super(key: key);


  @override
  Size get preferredSize {
    return const Size.fromHeight(60);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: isShow ? Theme.of(context).primaryColor : Color(0xffFAFAFA),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Color(0xffFAFAFA),
      // 그림자 효과 없애기.
      elevation: 0.0,
      // 110 - 상태바의 크기.
      toolbarHeight: (110 - MediaQuery.of(context).padding.top),
      bottom: isBorder ? PreferredSize(
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
      ) : null,
    );
  }
}
