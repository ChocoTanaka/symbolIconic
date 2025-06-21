import 'dart:convert';
import 'package:symbol_sdk/index.dart';
import 'package:symbol_sdk/symbol/index.dart';
import 'package:symbol_sdk/CryptoTypes.dart' as ct;
import 'Const.dart';
import 'Encrypto.dart';

var facade = SymbolFacade(Network.TESTNET);
var mode = "TEST";


String MakeAccount(String Name,String Pass,String uid){
  var pkey = ct.PrivateKey.random();
  var keyPair = KeyPair(pkey);
  var address = Address(facade.network.publicKeyToAddress(keyPair.publicKey)).toString();

  Account Ac = new Account(
      AccountName: encryptData(Name, uid, Pass),
      Address: encryptData(address, uid, Pass),
      PublicKey: encryptData(keyPair.publicKey.toString(),uid,Pass),
      PrivateKey:encryptData(keyPair.privateKey.toString(), uid, Pass)
  );

  String Acjson = jsonEncode(Ac.toJson());
  return Acjson;
}