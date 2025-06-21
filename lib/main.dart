import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:symboliconic/Symbol.dart';
import 'Word.dart';
import 'dart:convert';
import 'package:nfc_manager/nfc_manager.dart';
import 'Const.dart';
import 'Encrypto.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const Ippatsu_Main());
}

class Ippatsu_Main extends StatelessWidget {
  const Ippatsu_Main({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Symbol_Iconic Card',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Iconic(title: 'Symbol_Iconoic'),
    );
  }
}

class Iconic extends StatefulWidget {
  const Iconic({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Iconic> createState() => Iconic_Layout();
}

class Iconic_Layout extends State<Iconic> {
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  late String Name_card;
  late String Passcode;
  late String Address_read = "";
  late String Dialogue = "";
  bool Pass_obscure = true;

  initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Dialogue = "";
    setState(() {
      Reset();
      Address_read ="";
    });
  }

  Future readNfc(BuildContext context) async {
    int ErrorEnd = 0;
    Reset();
    final bool isNfcAvailable = await NfcManager.instance.isAvailable();
    if (!isNfcAvailable) {
      print('NFC is not available on this device');
    } else {
      print('NFC is available on this device');
      setState(() {
        Dialogue = "Scan your NFC card.";
      });
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          Ndef? ndef = Ndef.from(tag);
          if (ndef == null) {
            print('Tag is not ndef');
            setState(() {
              Dialogue = "Read only NDEF";
            });
            await Future.delayed(Duration(seconds: 3)).then((_) {
              setState(() {
                Dialogue = "";
              });
            });
            return;
          }
          NdefMessage message = await ndef.read();
          List<NdefRecord> records = message.records;
          String str = '';
          //解錠
          //dataを取り出す
          for (NdefRecord record in records) {
            Uint8List payload = record.payload.sublist(3);
            str += utf8.decode(payload);
          }
          Account Ac = Account.fromJson(jsonDecode(str));
          //uniqueidentifierを取得する
          var identifier = tag.data["nfca"]["identifier"] as List<int>;
          String uid = identifier.map((e) => e.toRadixString(16).padLeft(2, '0')).join('');
          NfcManager.instance.stopSession();
          String? pass = await _showPasscodeDialog(context,ErrorEnd);
          if(ErrorEnd ==0){
            //正常に終わった場合
            try{
              setState(() {
                Address_read = decryptData(Ac.Address, uid, pass!);
                Dialogue = "Compleated.";
              });
            }catch(e){
              setState(() {
                Dialogue = "Wrong password.";
              });
            }
            await Future.delayed(Duration(seconds: 3)).then((_) {
              setState(() {
                Dialogue = "";
              });
            });
          }
          else{
            setState(() {
              Dialogue = "Error.";
            });
            await Future.delayed(Duration(seconds: 3)).then((_) {
              setState(() {
                Dialogue = "";
              });
            });
          }
          NfcManager.instance.stopSession();
        },
        onError: (dynamic error) {
          print(error.message);
          return Future.value();
        },
      );
    }
  }

  Future<String?> _showPasscodeDialog(BuildContext context,int ErrorEnd) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return passAlert(context, ErrorEnd);
      },
    );
  }

  AlertDialog passAlert(BuildContext context, int ErrorEnd){
    String _status = Enter_pass(langint());
    int Retry = 0;
    String _passcode = "";
    TextEditingController passcodeController = TextEditingController();
    return AlertDialog(
      title: Text(_status),
      content: TextField(
        controller: passcodeController,
        keyboardType: TextInputType.number,
        obscureText: true,
        decoration: const InputDecoration(hintText: "8桁のパスコード"),
        onChanged: (text)=> setState(() {
          _passcode =passcodeController.text;
        }),
      ),
      actions: <Widget>[
        GestureDetector(
          child: Text(
              "Cancel",
              style: const TextStyle(fontSize: 18),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Padding(padding: const EdgeInsets.all(5.0)),
        GestureDetector(
          onTap: () {
            if (_passcode.length != 8) {
              setState(() {
                int rest = 3-Retry;
                _status = Pass_Error_length(langint(), rest);
                Retry++;
              });
              if(Retry>=3){
                ErrorEnd = 1;
                Navigator.pop(context);
              }
            } else {
              Navigator.pop(context,_passcode);
            }
          },
          child: Text(
              "OK",
              style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Future writeNFC() async {
    late String str;
    final bool isNfcAvailable = await NfcManager.instance.isAvailable();
    if (!isNfcAvailable) {
      print('NFC is not available on this device');
    } else {
      print('NFC is available on this device');
      setState(() {
        Dialogue = ScanNFC(langint());
      });
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          Ndef? ndef = Ndef.from(tag);
          if (ndef == null) {
            print('Tag is not ndef');
            setState(() {
              Dialogue = "Read only NDEF";
            });
            await Future.delayed(Duration(seconds: 3)).then((_) {
              setState(() {
                Dialogue = "";
              });
            });
            Reset();
            return;
          }
          bool isWritable = ndef.isWritable;
          if (isWritable) {
            //uniqueidentifierを取得する
            var identifier = tag.data["nfca"]["identifier"] as List<int>;
            str = identifier.map((e) => e.toRadixString(16).padLeft(2, '0')).join('');
            String Accountjson = MakeAccount(Name_card, Passcode, str);
            NdefMessage message = NdefMessage([
              NdefRecord.createText(Accountjson),
            ]);
            try {
              setState(() {
                Dialogue = NowWriting(langint());
              });
              await ndef.write(message).then((_) async{
                await ndef.writeLock().then((_){
                  setState(() {
                    Dialogue = "Compleated.";
                  });
                });
              });
            } catch (e) {
              print(e);
              setState(() {
                Dialogue = "Error.";
              });
            }
            await Future.delayed(Duration(seconds: 3)).then((_) {
              setState(() {
                Dialogue = "";
              });
            });
            NfcManager.instance.stopSession();
            Reset();
          } else {
            print('Tag is read-only');
            setState(() {
              Dialogue = "Read only";
            });
            await Future.delayed(Duration(seconds: 3)).then((_) {
              setState(() {
                Dialogue = "";
              });
            });
            NfcManager.instance.stopSession();
            Reset();
          }
        },
        onError: (dynamic error) {
          print(error.message);
          return Future.value();
        },
      );
    }
  }

  void Reset(){
    Name_card = "";
    Passcode = "";
    myController1.text = "";
    myController2.text = "";
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      //extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: const Text(
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
            'Symbol Iconic maker'
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  width: 3,
                  color: Colors.black
              ),
            ),
            child: Text(
              mode,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),

      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(10.0)),
            (Dialogue.isNotEmpty)?
              Container(
                height: 40,
                child: Text(
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.lightGreen,
                    ),
                    Dialogue
                ),
            ) :
              Container(
                  height: 40,
              ),
            Padding(padding: const EdgeInsets.all(20.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                Text(
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                    Name_resister(langint())
                ),
                Padding(padding: const EdgeInsets.all(10.0)),
                Expanded(
                    child: TextFormField(
                      controller: myController1,
                      onChanged: (text)=> setState(() {
                        Name_card =myController1.text;
                      }),
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your Name',
                      ),
                    ),
                ),
              ]
            ),
            Padding(padding: const EdgeInsets.all(30)),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  Text(
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                      pass(langint())
                  ),
                  Padding(padding: const EdgeInsets.all(10.0)),
                  Expanded(
                    child: TextFormField(
                      obscureText: Pass_obscure,
                      controller: myController2,
                      onChanged: (text)=> setState(() {
                        Passcode =myController2.text;
                      }),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: Set_pass(langint()),
                        suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                Pass_obscure = !Pass_obscure;
                              });
                            },
                            icon: Icon(Pass_obscure == true ? Icons.visibility_off : Icons.visibility),
                        )
                      ),
                    ),
                  ),
                ]
            ),
            Padding(padding: const EdgeInsets.all(40)),
            ElevatedButton(
                onPressed:() async{
                  if(Name_card !="" && Passcode.length == 8){
                    await writeNFC();
                  }else if(Passcode.length != 8){
                    setState(() {
                      Dialogue = Pass_Error_put(langint());
                    }); 
                  }else if(Name_card !=""){
                    setState(() {
                      Dialogue = Name_Error_length(langint());
                    });
                  }
                },
                child: Text(Dialogue_make(langint()))
            ),
            Padding(padding: const EdgeInsets.all(25)),
            ElevatedButton(
                onPressed:() async{
                  await readNfc(context);
                },
                child: Text(Dialogue_check(langint()))
            ),
            Padding(padding: const EdgeInsets.all(30)),
            (Address_read != "") ? Row(
              mainAxisSize: MainAxisSize.min, // 必要なサイズだけ確保
              children: <Widget>[
                Expanded(
                  child: Text(
                    Address_read,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis, // 長いテキストを省略
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: Address_read));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Text Copied")),
                    );
                  },
                ),
              ],
            ) : Container()
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ListTile(
          leading: Icon(Icons.language),
          title: Text(Language(langint())),
          trailing: Switch(
            value: lang,
            onChanged: (bool value) {
              setState(() {
                lang = value;
              });
            },
          ),
        )
      ),
    );
  }
}

