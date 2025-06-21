
bool lang = false;

int langint(){
  if(lang == false){
    return 0;
  }
  else{
    return 1;
  }
}

String Language(int langi){
  switch(langi){
    case 0:
      return "EN";
    case 1:
      return "JP";
  }
  return "Wrong language setting";
}

String Name_resister(int langi){
  switch(langi){
    case 0:
      return "Name:";
    case 1:
      return "宛名の名前:";
  }
  return "Wrong language setting";
}

String pass(int langi){
  switch(langi){
    case 0:
      return "Passcode:";
    case 1:
      return "パスコード:";
  }
  return "Wrong language setting";
}

String ScanNFC(int langi){
  switch(langi){
    case 0:
      return "Scan your NFC Card.";
    case 1:
      return "カードをスキャンしてください";
  }
  return "Wrong language setting";
}

String NowWriting(int langi){
  switch(langi){
    case 0:
      return "Now Writing";
    case 1:
      return "書き込み中";
  }
  return "Wrong language setting";
}

String Dialogue_make(int langi){
  switch(langi){
    case 0:
      return 'Create an account on the card.';
    case 1:
      return 'アカウント作成';
  }
  return "Wrong language setting";
}

String Dialogue_check(int langi){
  switch(langi){
    case 0:
      return "Check this card's address.";
    case 1:
      return "アドレス確認";
  }
  return "Wrong language setting";
}

String Set_pass(int langi){
  switch(langi){
    case 0:
      return "Set this passcode";
    case 1:
      return "パスコードを設定してください";
  }
  return "Wrong language setting";
}

String Enter_pass(int langi){
  switch(langi){
    case 0:
      return "Put on this passcode";
    case 1:
      return "カードのパスコードを記入してください";
  }
  return "Wrong language setting";
}

String Pass_Error_put(int langi){
  switch(langi){
    case 0:
      return "Passcord is 8 digit.";
    case 1:
      return "パスコードは8桁で入力してください";
  }
  return "Wrong language setting";
}

String Pass_Error_length(int langi, int rest){
  switch(langi){
    case 0:
      return "Passcord is 8 digit. Rest:$rest";
    case 1:
      return "パスコードは8桁で入力してください。残り$rest回";
  }
  return "Wrong language setting";
}

String Name_Error_length(int langi){
  switch(langi){
    case 0:
      return "Name is Needed.";
    case 1:
      return "名前が必要です";
  }
  return "Wrong language setting";
}

String Recipt(int langi, String Name, String Sighner_Name,int cost, String Usage){
  switch(langi) {
    case 0:
      return "Recipt \n"
          + "Name: $Sighner_Name \n"
          + "Cost: $cost XYM\n"
          + "As a use of $Usage\n"
          + "$Name";
    case 1:
      return "領収証\n"
          + "$Sighner_Name 様\n"
          + "代金 $cost XYM\n"
          + "$Usage 代として\n"
          + "$Name";
  }
  return "Wrong language setting";
}