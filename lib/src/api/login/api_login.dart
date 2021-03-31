
class ApiLogin{
  static bool isValid(String string){
    return string != null && string.length > 0;
  }

  static var UserData = {'admin': 'admin','admin1':'admin1'};

  static bool checkEmail(String email){
    return email.contains('@');
  }

  static bool numOfKey(String string){
    return string != null && string.length >= 5;
  }

  static bool checkUser(String user){
    return UserData.containsKey(user);
  }
  static bool checkPass(String user,String password){
    return UserData[user] == password;
  }
}