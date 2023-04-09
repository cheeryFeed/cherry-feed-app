import 'package:flutter/material.dart';

class MainRecommendationSlider extends StatelessWidget {
  const MainRecommendationSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contents.length,
        itemBuilder: (context, index) {
          final content = contents[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 176,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x29000000),
                        offset: Offset(4, 4),
                        blurRadius: 8,
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(content.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 200,
                  child: Text(
                    content.title,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RecommendationContent {
  final String title;
  final String imageUrl;

  RecommendationContent({required this.title, required this.imageUrl});
}

final List<RecommendationContent> contents = [
  RecommendationContent(
    title: '동대문역사공원(DDP)',
    imageUrl: 'assets/images/dummy/ex_1.jpg',
  ),
  RecommendationContent(
    title: '청수당 신사점',
    imageUrl: 'assets/images/dummy/ex_2.jpg',
  ),
  RecommendationContent(
    title: '멍멍이 본점',
    imageUrl: 'assets/images/dummy/ex_3.jpg',
  ),
];