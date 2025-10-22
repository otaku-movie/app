/// 信用卡验证工具类
class CreditCardValidator {
  /// Luhn算法验证卡号
  static bool validateCardNumber(String cardNumber) {
    String cleaned = cardNumber.replaceAll(' ', '');
    
    if (cleaned.isEmpty || cleaned.length < 13 || cleaned.length > 19) {
      return false;
    }
    
    // Luhn算法
    int sum = 0;
    bool alternate = false;
    
    for (int i = cleaned.length - 1; i >= 0; i--) {
      int digit = int.parse(cleaned[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    return (sum % 10 == 0);
  }
  
  /// 验证有效期
  static bool validateExpiryDate(String expiryDate) {
    if (expiryDate.isEmpty || expiryDate.length < 4) {
      return false;
    }
    
    // 移除斜杠
    String cleaned = expiryDate.replaceAll('/', '');
    
    if (cleaned.length != 4) {
      return false;
    }
    
    try {
      int month = int.parse(cleaned.substring(0, 2));
      int year = int.parse(cleaned.substring(2, 4));
      
      // 验证月份
      if (month < 1 || month > 12) {
        return false;
      }
      
      // 获取当前日期
      DateTime now = DateTime.now();
      int currentYear = now.year % 100; // 只取后两位
      int currentMonth = now.month;
      
      // 验证是否过期
      if (year < currentYear) {
        return false;
      }
      
      if (year == currentYear && month < currentMonth) {
        return false;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// 验证CVV
  static bool validateCVV(String cvv) {
    if (cvv.isEmpty) {
      return false;
    }
    
    // CVV 通常是 3-4 位数字
    if (cvv.length < 3 || cvv.length > 4) {
      return false;
    }
    
    // 确保都是数字
    return RegExp(r'^\d+$').hasMatch(cvv);
  }
  
  /// 获取卡片类型
  static String getCardType(String cardNumber) {
    String cleaned = cardNumber.replaceAll(' ', '');
    
    if (cleaned.startsWith('4')) {
      return 'Visa';
    } else if (cleaned.startsWith('5')) {
      return 'MasterCard';
    } else if (cleaned.startsWith('35')) {
      return 'JCB';
    } else if (cleaned.startsWith('62')) {
      return 'UnionPay';
    } else if (cleaned.startsWith('3')) {
      return 'American Express';
    }
    
    return '';
  }
}

