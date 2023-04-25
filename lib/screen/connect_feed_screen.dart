import 'dart:convert';

import 'package:cherry_feed/appbar/custom_app_bar.dart';
import 'package:cherry_feed/button/next_button.dart';
import 'package:cherry_feed/models/user/user.dart';
import 'package:cherry_feed/screen/main_screen.dart';
import 'package:cherry_feed/text_edit/text_edit.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConnectFeedScreen extends StatefulWidget {
  final User user;
  const ConnectFeedScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ConnectFeedScreen> createState() => _ConnectFeedScreenState();
}

class _ConnectFeedScreenState extends State<ConnectFeedScreen> {
  late TokenProvider _tokenProvider;
  String _accessToken = "";

  late String labelCode;
  Future<void> sendDataToServer(User user) async {
    print(_accessToken);
// access token과 refresh token 저장
    final url = Uri.parse('http://218.53.23.14:8090/api/v1/users/kakao-join');
    final body = json.encode(user.toJson());
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_accessToken'
    };
    print('TOKENENENENE : : : :: : : ${_accessToken} ');


    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      // 성공적으로 요청을 보낸 경우
      print('Request succeeded with status ${response.statusCode}');
    } else {
      // 요청이 실패한 경우
      print('Request failed with status ${response.statusCode}');
    }
    print(user);
  }

  Future<String> getConnectCode() async {
    Uri uri = Uri.parse('http://218.53.23.14:8090/api/v1/users/create/connectcode');
    http.Response response = await http.get(uri);
    print(response.body);
    return response.body;
  }

  Future<void> initToken() async {
    await _tokenProvider.init();
    await _tokenProvider.getAccessToken().then((value){
      setState(() {
        _accessToken = value!;
      });
    });

  }
  @override
  void initState() {
    super.initState();
    _tokenProvider = TokenProvider();
    initToken();
    labelCode = 'Type Something';
    getConnectCode().then((value) {
      setState(() {
        labelCode = value;
        widget.user.setConnectCode(value);
        print(widget.user.toString());
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: CustomAppBar(isShow: true,isBorder: false,),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '체리피드를 함께 관리할 \n'
                      '상대방과 연결해주세요',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: Image.asset('assets/images/heart_asset.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '내 연결 코드',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            SizedBox(
              child: TextEdit(
                enabled: false,
                textHint: labelCode,
                controller: TextEditingController(),
                onChange: (String){},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 32),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '상대방 연결 코드',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            SizedBox(
              child: TextEdit(
                enabled: true,
                textHint:'상대방의 코드를 입력 해 주세요.',
                controller: TextEditingController(),
                onChange: (String){},
              ),
            ),

            Container(
              width: 500,
              child: Row(
                children: [
                  Expanded(
                    flex:10,
                    child: Padding(
                      padding: EdgeInsets.only(right: 5,top: 100),
                      child: NextButton(
                        backgroundColor: Color(0xffFFFFFF),
                        textColor: Color(0xffEE4545),
                        isHalf: true,
                        text: '공유하기',
                        onPressed: (){},
                      ),
                    ),
                  ),
                  // Expanded(
                  //   flex: 1,
                  //     child:
                  //     SizedBox(width: 10,)
                  // ),
                  Expanded(
                    flex:10,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,top: 100),
                      child: NextButton(
                        backgroundColor: Color(0xffEE4545),
                        textColor: Color(0xffFFFFFF),
                        isHalf: true,
                        text: '나중에 하기',
                        onPressed: (){
                          sendDataToServer(widget.user);
                          Navigator.push(context, MaterialPageRoute(builder: ((context) => MainScreen(user:widget.user))));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}
