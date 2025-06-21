
class Account{
 late final String AccountName;
 late final String Address;
 late final String PublicKey;
 late final String PrivateKey;
 Account({required this.AccountName, required this.Address, required this.PublicKey, required this.PrivateKey});

 factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

 Map<String, dynamic> toJson() => _$AccountToJson(this);
}


Account _$AccountFromJson(Map<String, dynamic> json) => Account(
 AccountName: json['AccountName'] as String,
 Address: json['Address'] as String,
 PublicKey: json['PublicKey'] as String,
 PrivateKey: json['PrivateKey'] as String,
);

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
 'AccountName': instance.AccountName,
 'Address': instance.Address,
 'PublicKey': instance.PublicKey,
 'PrivateKey': instance.PrivateKey,
};

