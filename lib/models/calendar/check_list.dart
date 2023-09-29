class CheckList {
  String content;
  bool isFinish;

  CheckList({
    required this.content,
    required this.isFinish,
  });

  factory CheckList.fromJson(Map<String, dynamic> json) {
    return CheckList(
      content: json['content'] as String,
      isFinish: json['isFinish'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['content'] = this.content;
    data['isFinish'] = this.isFinish;
    return data;
  }

  @override
  String toString() {
    return 'CheckList{content: $content, isFinish: $isFinish}';
  }
}