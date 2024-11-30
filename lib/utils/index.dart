String formatNumberToTime(int totalMinutes) {
  int hours = totalMinutes ~/ 60;  // 计算小时数
  int minutes = totalMinutes % 60; // 计算剩余的分钟数
  
  // 格式化小时和分钟，确保它们是两位数
  String formattedHours = hours.toString().padLeft(2, '0');
  String formattedMinutes = minutes.toString().padLeft(2, '0');
  
  return '$formattedHours:$formattedMinutes';
}

  // 邮箱格式验证
  bool isValidEmail(String email) {
    RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  // 密码格式验证
  bool isValidPassword(String password) {
    RegExp passwordRegExp = RegExp(r'^[a-zA-Z0-9_]{6,16}$');
    // 密码长度6-16位，且包含数字、字母和下划线
    // RegExp passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*_).{6,16}$');
    
    return passwordRegExp.hasMatch(password);
  }