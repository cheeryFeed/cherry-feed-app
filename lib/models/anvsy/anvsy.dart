class Anvsy {
  final int? id;
  final DateTime? anvsyAt;
  final String? anvsyNm;
  final int? imgId;
  final int? status;

  Anvsy({
    required this.id,
    required this.anvsyAt,
    required this.anvsyNm,
    required this.imgId,
    required this.status,
  });

  factory Anvsy.fromJson(Map<String, dynamic> json) {
    DateTime? dateTime;
    if(json['anvsyAt'] != null && json['anvsyAt'].toString().isNotEmpty) {
      String dateString = json['anvsyAt'].toString();
      dateTime = DateTime.parse(dateString.substring(0, 8));
    }

    return Anvsy(
      id: json['id'],
      anvsyAt: dateTime,
      anvsyNm: json['anvsyNm'],
      imgId: json['imgId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['anvsyAt'] = this.anvsyAt;
    data['anvsyNm'] = this.anvsyNm;
    data['imgId'] = this.imgId;
    data['status'] = this.status;
    return data;
  }

  @override
  String toString() {
    return 'Anvsy{id: $id, anvsyAt: $anvsyAt, anvsyNm: $anvsyNm, imgId: $imgId, status: $status}';
  }
}