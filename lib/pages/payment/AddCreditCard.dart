import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/utils/credit_card_validator.dart';
import 'package:otaku_movie/response/payment/credit_card_response.dart';

class AddCreditCard extends StatefulWidget {
  final String? orderNumber;
  /// 非空时进入"编辑模式"：复用本页面但只允许改持卡人姓名 / 有效期 / 是否默认
  /// 卡号 / CVV 出于 PCI DSS 合规禁止回显与修改
  final CreditCardResponse? editCard;

  const AddCreditCard({super.key, this.orderNumber, this.editCard});

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
  bool _saveCard = true; // 默认保存到数据库（新增模式）
  bool _isDefault = false; // 编辑模式下的"设为默认"开关

  bool get _isEditMode => widget.editCard != null;

  @override
  void initState() {
    super.initState();
    final card = widget.editCard;
    if (card != null) {
      // 卡号/CVV 不回显：卡号字段只用于预览展示，存遮罩值
      _cardNumberController.text = '•••• •••• •••• ${card.lastFourDigits ?? '••••'}';
      _cardHolderController.text = card.cardHolderName ?? '';
      _expiryDateController.text = card.expiryDate ?? '';
      _cardType = card.cardType ?? '';
      _isDefault = card.isDefault == true;
    }
  }

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

    // 编辑模式走 update 接口
    if (_isEditMode) {
      try {
        final id = widget.editCard!.id;
        final res = await ApiRequest().request<dynamic>(
          path: '/creditCard/update',
          method: 'POST',
          data: {
            'id': id,
            'cardHolderName': _cardHolderController.text,
            'expiryDate': _expiryDateController.text,
            'isDefault': _isDefault,
          },
          fromJsonT: (json) => json,
        );

        if (!mounted) return;
        if (res.code == 200) {
          ToastService.showSuccess(S.of(context).payment_addCreditCard_cardSaved);
          Navigator.of(context).pop(true);
        } else {
          ToastService.showError(res.message ?? S.of(context).payment_addCreditCard_operationFailed);
        }
      } catch (_) {
        if (!mounted) return;
        ToastService.showError(S.of(context).payment_addCreditCard_operationFailed);
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
      return;
    }

    try {
      // 准备信用卡数据
      final cardRequest = CreditCardSaveRequest(
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        cardHolderName: _cardHolderController.text,
        expiryDate: _expiryDateController.text,
        cvv: _cvvController.text,
        cardType: _cardType,
        // 仅保存到账户的卡才有"默认"概念；临时卡固定 false
        isDefault: _saveCard && _isDefault,
        saveCard: _saveCard,
      );

      if (_saveCard) {
        // 保存到数据库
        await ApiRequest().request<Map<String, dynamic>>(
          path: '/creditCard/save',
          method: 'POST',
          data: cardRequest.toJson(),
          fromJsonT: (json) => json as Map<String, dynamic>,
        );
        
        if (!mounted) return;
        ToastService.showSuccess(S.of(context).payment_addCreditCard_cardSaved);
        
        // 返回 true 表示已保存
        Navigator.of(context).pop(true);
      } else {
        // 仅本次使用，不保存到数据库
        if (!mounted) return;
        ToastService.showSuccess(S.of(context).payment_addCreditCard_cardConfirmed);
        
        // 返回临时卡片对象，用于临时支付
        final tempCard = TempCard(
          cardNumber: _cardNumberController.text.replaceAll(' ', ''),
          cardHolderName: _cardHolderController.text,
          expiryDate: _expiryDateController.text,
          cvv: _cvvController.text,
          cardType: _cardType,
        );
        Navigator.of(context).pop(tempCard);
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
        title: Text(
          _isEditMode
              ? S.of(context).creditCard_edit_title
              : S.of(context).payment_addCreditCard_title,
          style: const TextStyle(color: Colors.white),
        ),
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
                      enabled: !_isEditMode,
                      inputFormatters: _isEditMode
                          ? []
                          : [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                            ],
                      decoration: InputDecoration(
                        hintText: S.of(context).payment_addCreditCard_cardNumberHint,
                        prefixIcon: const Icon(Icons.credit_card),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        filled: _isEditMode,
                        fillColor: _isEditMode ? Colors.grey.shade100 : null,
                      ),
                      style: TextStyle(fontSize: 28.sp),
                      onChanged: (value) {
                        if (_isEditMode) return;
                        _detectCardType(value);
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      validator: (value) {
                        if (_isEditMode) return null;
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
                                enabled: !_isEditMode,
                                inputFormatters: _isEditMode
                                    ? []
                                    : [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                decoration: InputDecoration(
                                  hintText: _isEditMode
                                      ? '•••'
                                      : S.of(context).payment_addCreditCard_cvvHint,
                                  prefixIcon: const Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  filled: _isEditMode,
                                  fillColor: _isEditMode ? Colors.grey.shade100 : null,
                                ),
                                style: TextStyle(fontSize: 28.sp),
                                validator: (value) {
                                  if (_isEditMode) return null;
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
                    
                    // 设为默认（编辑模式） / 保存到账户 + 设为默认（新增模式）
                    if (_isEditMode)
                      _buildToggleTile(
                        icon: Icons.star_rounded,
                        accent: const Color(0xFFF59E0B),
                        title: S.of(context).creditCard_action_setDefault,
                        subtitle: S.of(context).creditCard_setDefaultSubtitle,
                        value: _isDefault,
                        onChanged: (v) {
                          if (mounted) setState(() => _isDefault = v);
                        },
                      )
                    else ...[
                      _buildToggleTile(
                        icon: Icons.bookmark_added_rounded,
                        accent: const Color(0xFF3B82F6),
                        title: S.of(context).payment_addCreditCard_saveCard,
                        subtitle: _saveCard
                            ? S.of(context).payment_addCreditCard_saveToAccount
                            : S.of(context).payment_addCreditCard_useOnce,
                        value: _saveCard,
                        onChanged: (v) {
                          if (mounted) {
                            setState(() {
                              _saveCard = v;
                              // 仅本次使用的临时卡不应被设为默认
                              if (!v) _isDefault = false;
                            });
                          }
                        },
                      ),
                      // 仅"保存到账户"开启时才允许选择"设为默认"
                      if (_saveCard) ...[
                        SizedBox(height: 16.h),
                        _buildToggleTile(
                          icon: Icons.star_rounded,
                          accent: const Color(0xFFF59E0B),
                          title: S.of(context).creditCard_action_setDefault,
                          subtitle: S.of(context).creditCard_setDefaultSubtitle,
                          value: _isDefault,
                          onChanged: (v) {
                            if (mounted) setState(() => _isDefault = v);
                          },
                        ),
                      ],
                    ],
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
                            : Text(
                                _isEditMode
                                    ? S.of(context).creditCard_edit_save
                                    : S.of(context).payment_addCreditCard_confirmAdd,
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

  /// 统一开关项：左圆角 icon 背景 + 标题 + 副标题 + 右 Switch
  /// - `accent`：选中态强调色（活动 track、icon 背景）
  /// - `onChanged` 为 null 时显示为锁定/灰显
  /// - 整行可点击切换
  Widget _buildToggleTile({
    required IconData icon,
    required Color accent,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    final disabled = onChanged == null;
    final iconColor = disabled ? const Color(0xFF9CA3AF) : accent;
    final borderColor = (value && !disabled)
        ? accent.withValues(alpha: 0.4)
        : const Color(0xFFE5E7EB);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : () => onChanged(!value),
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          child: Row(
            children: [
              Container(
                width: 64.sp,
                height: 64.sp,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(icon, size: 32.sp, color: iconColor),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w600,
                        color: disabled ? const Color(0xFF6B7280) : const Color(0xFF111827),
                        height: 1.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: const Color(0xFF6B7280),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Transform.scale(
                scale: 0.95,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeThumbColor: Colors.white,
                  activeTrackColor: accent,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFF3F4F6),
                  trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.disabled)) {
                      return const Color(0xFFD1D5DB);
                    }
                    if (states.contains(WidgetState.selected)) return accent;
                    return const Color(0xFFD1D5DB);
                  }),
                  trackOutlineWidth: const WidgetStatePropertyAll(1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

