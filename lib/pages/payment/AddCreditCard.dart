import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/utils/credit_card_validator.dart';

class AddCreditCard extends StatefulWidget {
  final String? orderId;
  
  const AddCreditCard({super.key, this.orderId});

  @override
  State<AddCreditCard> createState() => _AddCreditCardState();
}

class _AddCreditCardState extends State<AddCreditCard> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  
  bool _isLoading = false;
  String _cardType = '';
  bool _saveCard = true; // 默认保存到数据库

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  // 检测卡类型
  void _detectCardType(String cardNumber) {
    if (!mounted) return;
    
    setState(() {
      _cardType = CreditCardValidator.getCardType(cardNumber);
    });
  }

  // 格式化卡号（每4位加空格）
  String _formatCardNumber(String value) {
    String cleaned = value.replaceAll(' ', '');
    List<String> parts = [];
    for (int i = 0; i < cleaned.length; i += 4) {
      int end = (i + 4 < cleaned.length) ? i + 4 : cleaned.length;
      parts.add(cleaned.substring(i, end));
    }
    return parts.join(' ');
  }

  // 格式化有效期（MM/YY）
  String _formatExpiryDate(String value) {
    String cleaned = value.replaceAll('/', '');
    
    // 验证月份不能超过12
    if (cleaned.length >= 2) {
      int month = int.tryParse(cleaned.substring(0, 2)) ?? 0;
      // 如果月份大于12，限制为12
      if (month > 12) {
        cleaned = '12${cleaned.substring(2)}';
      }
      // 如果第一位是0，第二位不能是0
      if (cleaned[0] == '0' && cleaned.length > 1 && cleaned[1] == '0') {
        cleaned = '01${cleaned.substring(2)}';
      }
      return '${cleaned.substring(0, 2)}/${cleaned.substring(2)}';
    }
    
    // 如果第一位输入就大于1，自动补0
    if (cleaned.length == 1) {
      int firstDigit = int.tryParse(cleaned) ?? 0;
      if (firstDigit > 1) {
        return '0$cleaned/';
      }
    }
    
    return cleaned;
  }

  // 提交信用卡信息
  Future<void> _submitCard() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      // 准备信用卡数据
      final cardData = {
        'cardNumber': _cardNumberController.text.replaceAll(' ', ''),
        'cardHolderName': _cardHolderController.text,
        'expiryDate': _expiryDateController.text,
        'cvv': _cvvController.text,
        'cardType': _cardType,
        'saveCard': _saveCard, // 是否保存到数据库
      };

      if (_saveCard) {
        // 保存到数据库
        await ApiRequest().request<dynamic>(
          path: '/api/creditCard/save',
          method: 'POST',
          data: cardData,
          fromJsonT: (json) => json,
        );
        
        if (!mounted) return;
        ToastService.showSuccess(S.of(context).payment_addCreditCard_cardSaved);
        
        // 返回 true 表示已保存
        Navigator.of(context).pop(true);
      } else {
        // 仅本次使用，不保存到数据库
        if (!mounted) return;
        ToastService.showSuccess(S.of(context).payment_addCreditCard_cardConfirmed);
        
        // 返回信用卡数据，用于临时支付
        Navigator.of(context).pop(cardData);
      }
    } catch (e) {
      if (!mounted) return;
      ToastService.showError(S.of(context).payment_addCreditCard_operationFailed);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(
        title: Text(S.of(context).payment_addCreditCard_title, style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 信用卡预览
            Container(
              margin: EdgeInsets.all(32.w),
              height: 400.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1E3A8A),
                    const Color(0xFF3B82F6),
                  ],
                ),
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(40.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 卡类型和芯片
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 80.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade700,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        // 根据卡类型显示对应的 logo
                        if (_cardType == 'Visa')
                          Container(
                            width: 100.w,
                            height: 60.h,
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/pay/visa.svg',
                              fit: BoxFit.contain,
                            ),
                          )
                        else if (_cardType == 'MasterCard')
                          Container(
                            width: 100.w,
                            height: 60.h,
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/pay/master-card.svg',
                              fit: BoxFit.contain,
                            ),
                          )
                        else if (_cardType == 'JCB')
                          Container(
                            width: 100.w,
                            height: 60.h,
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/pay/jcb.svg',
                              fit: BoxFit.contain,
                            ),
                          )
                        else if (_cardType == 'UnionPay')
                          Container(
                            width: 100.w,
                            height: 60.h,
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/pay/yinlian.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                      ],
                    ),
                    
                    // 卡号
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _cardNumberController.text.isEmpty
                            ? '•••• •••• •••• ••••'
                            : _formatCardNumber(_cardNumberController.text),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42.sp,
                          letterSpacing: 2,
                          fontFamily: 'Courier',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    
                    // 持卡人和有效期
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CARD HOLDER',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 20.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              _cardHolderController.text.isEmpty
                                  ? 'YOUR NAME'
                                  : _cardHolderController.text.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'EXPIRES',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 20.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              _expiryDateController.text.isEmpty
                                  ? 'MM/YY'
                                  : _expiryDateController.text,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // 表单
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32.w),
              padding: EdgeInsets.all(40.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 卡号
                    Text(
                      S.of(context).payment_addCreditCard_cardNumber,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                      ],
                      decoration: InputDecoration(
                        hintText: S.of(context).payment_addCreditCard_cardNumberHint,
                        prefixIcon: const Icon(Icons.credit_card),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      style: TextStyle(fontSize: 28.sp),
                      onChanged: (value) {
                        _detectCardType(value);
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).payment_addCreditCard_cardNumberError;
                        }
                        // 使用Luhn算法验证卡号
                        if (!CreditCardValidator.validateCardNumber(value)) {
                          return S.of(context).payment_addCreditCard_cardNumberLength;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32.h),
                    
                    // 持卡人姓名
                    Text(
                      S.of(context).payment_addCreditCard_cardHolderName,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _cardHolderController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: S.of(context).payment_addCreditCard_cardHolderNameHint,
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      style: TextStyle(fontSize: 28.sp),
                      onChanged: (_) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).payment_addCreditCard_cardHolderNameError;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32.h),
                    
                    // 有效期和CVV
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).payment_addCreditCard_expiryDate,
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              TextFormField(
                                controller: _expiryDateController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                decoration: InputDecoration(
                                  hintText: S.of(context).payment_addCreditCard_expiryDateHint,
                                  prefixIcon: const Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                style: TextStyle(fontSize: 28.sp),
                                onChanged: (value) {
                                  String formatted = _formatExpiryDate(value);
                                  if (formatted != value) {
                                    _expiryDateController.value = TextEditingValue(
                                      text: formatted,
                                      selection: TextSelection.collapsed(offset: formatted.length),
                                    );
                                  }
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return S.of(context).payment_addCreditCard_expiryDateError;
                                  }
                                  if (!CreditCardValidator.validateExpiryDate(value)) {
                                    return S.of(context).payment_addCreditCard_expiryDateExpired;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 32.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).payment_addCreditCard_cvv,
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              TextFormField(
                                controller: _cvvController,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                decoration: InputDecoration(
                                  hintText: S.of(context).payment_addCreditCard_cvvHint,
                                  prefixIcon: const Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                style: TextStyle(fontSize: 28.sp),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return S.of(context).payment_addCreditCard_cvvError;
                                  }
                                  if (!CreditCardValidator.validateCVV(value)) {
                                    return S.of(context).payment_addCreditCard_cvvLength;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    
                    // 保存选项
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.save,
                            color: Colors.blue.shade700,
                            size: 32.sp,
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).payment_addCreditCard_saveCard,
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  _saveCard 
                                    ? S.of(context).payment_addCreditCard_saveToAccount
                                    : S.of(context).payment_addCreditCard_useOnce,
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _saveCard,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  _saveCard = value;
                                });
                              }
                            },
                            activeColor: const Color(0xFF3B82F6),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 48.h),
                    
                    // 提交按钮
                    SizedBox(
                      width: double.infinity,
                      height: 96.h,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitCard,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 48.w,
                                height: 48.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            :                             Text(
                                S.of(context).payment_addCreditCard_confirmAdd,
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 48.h),
          ],
        ),
      ),
    );
  }
}

