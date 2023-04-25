class User {
  String? birth;
  String? connectCode;
  String? email;
  String? gender;
  int? imgId;
  bool? isTerms;
  String? nickname;
  String? password;
  String? phone;
  String? socialId;
  String? socialProvider;
  String? userName;
  User();
  void setBirth(String value) {
    this.birth = value;
  }

  void setConnectCode(String value) {
    this.connectCode = value;
  }

  void setEmail(String value) {
    this.email = value;
  }

  void setGender(String value) {
    this.gender = value;
  }

  void setImgId(int value) {
    this.imgId = value;
  }

  void setIsTerms(bool value) {
    this.isTerms = value;
  }

  void setNickname(String value) {
    this.nickname = value;
  }

  void setPassword(String value) {
    this.password = value;
  }

  void setPhone(String value) {
    this.phone = value;
  }

  void setSocialId(String value) {
    this.socialId = value;
  }

  void setSocialProvider(String value) {
    this.socialProvider = value;
  }

  void setUserName(String value) {
    this.userName = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'birth': birth,
      'connectCode': connectCode,
      'email': email,
      'gender': gender,
      'imgId': imgId,
      'isTerms': isTerms,
      'nickname': nickname,
      'password': password,
      'phone': phone,
      'socialId': socialId,
      'socialProvider': socialProvider,
      'userName': userName,
    };
  }

  @override
  String toString() {
    return 'User{birth: $birth, connectCode: $connectCode, email: $email, gender: $gender, imgId: $imgId, isTerms: $isTerms, nickname: $nickname, password: $password, phone: $phone, socialId: $socialId, socialProvider: $socialProvider, userName: $userName}';
  }

  static User fromJson(Map<String, dynamic> json) {
    return User()
      ..birth = json['birth']
      ..connectCode = json['connectCode']
      ..email = json['email']
      ..gender = json['gender']
      ..imgId = json['imgId']
      ..isTerms = json['isTerms']
      ..nickname = json['nickname']
      ..password = json['password']
      ..phone = json['phone']
      ..socialId = json['socialId']
      ..socialProvider = json['socialProvider']
      ..userName = json['userName'];
  }
}