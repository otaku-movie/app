String formatNumberToTime(int totalMinutes) {
  int hours = totalMinutes ~/ 60;  // 计算小时数
  int minutes = totalMinutes % 60; // 计算剩余的分钟数
  
  // 格式化小时和分钟，确保它们是两位数
  String formattedHours = hours.toString().padLeft(2, '0');
  String formattedMinutes = minutes.toString().padLeft(2, '0');
  
  return '$formattedHours:$formattedMinutes';
}
