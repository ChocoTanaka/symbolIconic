import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

/// UIDとパスコードを元にAES-256の鍵を生成
Key generateKey(String uid, String passcode) {
  String combined = uid + passcode;
  Digest hash = sha256.convert(utf8.encode(combined));
  print("data:"+ combined);
  return Key(Uint8List.fromList(hash.bytes));
}

IV generateIV(String uid, String passcode) {
  String input = uid + passcode;
  List<int> hash = sha256.convert(utf8.encode(input)).bytes;
  print("data:"+ input);
  return IV(Uint8List.fromList(hash.sublist(0, 16))); // 最初の16バイトをIVとして使う
}

/// データをAES-256で暗号化
String encryptData(String plainText, String uid, String passcode) {
  final key = generateKey(uid, passcode);
  final iv = generateIV(uid,passcode); // 初期ベクトル（固定長16バイト）

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc)); // CBCモードを使用
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return base64.encode(encrypted.bytes); // Base64エンコードして保存
}

/// AES-256で復号
String decryptData(String encrypted, String uid, String passcode) {
  final key = generateKey(uid, passcode);
  final iv = generateIV(uid, passcode); // 初期ベクトル（固定長16バイト）
  final decrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final decrypted = decrypter.decrypt64(encrypted, iv: iv);
  print(decrypted);
  return decrypted;
}




