import 'package:flutter/material.dart';

class MainPlanButton extends StatelessWidget {
  const MainPlanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Image.asset('assets/images/plan_icon.png'),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 14,),
                const Text(
                  '함께 세운 여행 계획이 있나요 ?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  ),
                  textAlign: TextAlign.left,
                ),
                Row(
                  children: [
                    const Text(
                      '계획 세우기',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEE4545),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFFEE4545)),
                      onPressed: () {},
                    )
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
