import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overture/MenuTranslationScreen/DeepLTranslate.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _selectedImage;
  String extractedText = "";
  final FlutterTts tts = FlutterTts();

  @override
  void initState(){
    super.initState();

    tts.setLanguage("en-US");
    tts.setSpeechRate(0.5);
  }

  // 카운터 값을 각 메뉴 항목별로 저장하는 Map
  Map<String, int> menuItemCounters = {};
  Map<String, String> translatedMenuItems = {};
  final DeepLService  deepLService = DeepLService();
  // 갤러리에서 이미지를 선택하는 함수
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    // 갤러리에서 이미지 선택
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        // 선택한 이미지 파일을 _selectedImage에 저장
        _selectedImage = File(image.path);
      });
    }
    _processImage();
  }

  Future<void> _processImage() async {
    final inputImage = InputImage.fromFilePath(_selectedImage!.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    extractedText = recognizedText.text;

    // 정규 표현식을 사용하여 문자만 추출
    extractedText = _extractAlphabeticCharacters(extractedText);
  }

  // 문자만 추출하는 함수 - [참고] https://www.youtube.com/watch?v=GmhkXH8fO-A
  String _extractAlphabeticCharacters(String input) {
    // 알파벳 문자만 남기고 나머지 문자들은 제거 (공백 포함)
    RegExp regExp = RegExp(r'[a-zA-Zㄱ-ㅎ가-힣\s]+');
    return regExp.allMatches(input).map((match) => match.group(0)).join(' ').trim();
  }

  Future<void> _translateMenuItems(List<String> menuItems) async {
    for (var menuItem in menuItems) {
      if (!translatedMenuItems.containsKey(menuItem)) {
        try {
          final translatedText = await deepLService.translateText(menuItem, "KO");
          setState(() {
            translatedMenuItems[menuItem] = translatedText;
          });
        } catch (e) {
          print("번역 실패: $e");
          setState(() {
            translatedMenuItems[menuItem] = "번역 오류";
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이미지 선택하기')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 버튼을 누르면 갤러리로 이동
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('갤러리에서 이미지 선택'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.black, // 텍스트 색상
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_selectedImage == null) {
                      Fluttertoast.showToast(
                          msg:"이미지를 선택하세요.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    } else if(extractedText == "") {
                      Fluttertoast.showToast(
                          msg:"추출된 문자가 없습니다.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    } else {
                        List<String> menuItems = extractedText
                            .split("\n")
                            .map((item) => item.trim())
                            .toList();

                      //TODO Papago 번역 요청
                      showModalBottomSheet( context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {

                              return ListView.builder(
                                padding: EdgeInsets.all(8),
                                itemCount: menuItems.length,
                                itemBuilder: (context, index) {
                                  String menuItem = menuItems[index];
                                  String translatedText =
                                      translatedMenuItems[menuItem] ?? "번역 중...";

                                  // 각 메뉴 항목에 대해 숫자 값을 매핑
                                  if (!menuItemCounters.containsKey(menuItem)) {
                                    menuItemCounters[menuItem] = 0;
                                  }

                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                menuItem,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                translatedText,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: (){
                                                  tts.speak(menuItem);
                                                },
                                                icon: Icon(Icons.volume_down_rounded,color: Colors.amber,)
                                              ),
                                              CounterButton(
                                                loading: false,
                                                onChange: (int val) {
                                                  if(val<0){
                                                    return;
                                                  }
                                                  setState(() {
                                                    menuItemCounters[menuItem] = val;
                                                  });
                                                },
                                                count: menuItemCounters[menuItem]!,
                                                countColor: Colors.purple,
                                                buttonColor: Colors.purpleAccent,
                                                progressColor: Colors.purpleAccent,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );

                        await _translateMenuItems(menuItems);
                    }
                  },
                  child: Text("메뉴 추출하기"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // 텍스트 색상
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // 선택한 이미지를 비율에 맞게 화면에 표시
            _selectedImage != null
                ? Image.file(
              _selectedImage!,
              fit: BoxFit.contain, // 비율을 유지하면서 크기 맞추기
              width: MediaQuery.of(context).size.width, // 화면 너비에 맞추기
              height: MediaQuery.of(context).size.height * 0.5, // 화면 높이의 50% 크기
            )
                : Text('선택된 이미지가 없습니다.'),
          ],
        ),
      ),
    );
  }
}
