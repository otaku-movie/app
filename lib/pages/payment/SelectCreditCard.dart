import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/generated/l10n.dart';

class SelectCreditCard extends StatefulWidget {
  final String? orderId;
  
  const SelectCreditCard({super.key, this.orderId});

  @override
  State<SelectCreditCard> createState() => _SelectCreditCardState();
}

class _SelectCreditCardState extends State<SelectCreditCard> {
  List<CreditCardModel> _creditCards = [];
  int? _selectedCardId;
  bool _isLoading = false;
  bool _isPaying = false;
  Map<String, dynamic>? _tempCardData; // 临时信用卡数据（仅本次使用）

  @override
  void initState() {
    super.initState();
    _loadCreditCards();
  }

  // 加载用户的信用卡列表
  Future<void> _loadCreditCards() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: 调用获取信用卡列表的接口
      await Future.delayed(const Duration(seconds: 1)); // 模拟API调用
      
      if (!mounted) return;
      
      // 模拟数据
      setState(() {
        _creditCards = [
          CreditCardModel(
            id: 1,
            cardType: 'Visa',
            lastFourDigits: '4242',
            cardHolderName: 'TARO YAMADA',
            expiryDate: '12/25',
          ),
          CreditCardModel(
            id: 2,
            cardType: 'MasterCard',
            lastFourDigits: '5555',
            cardHolderName: 'TARO YAMADA',
            expiryDate: '10/26',
          ),
        ];
        if (_creditCards.isNotEmpty) {
          _selectedCardId = _creditCards[0].id;
        }
      });
    } catch (e) {
      if (!mounted) return;
      ToastService.showError(S.of(context).payment_selectCreditCard_loadFailed);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 支付
  Future<void> _pay() async {
    if (_selectedCardId == null && _tempCardData == null) {
      ToastService.showWarning(S.of(context).payment_selectCreditCard_pleaseSelectCard);
      return;
    }

    if (!mounted) return;
    
    setState(() {
      _isPaying = true;
    });

    try {
      // 准备支付数据
      Map<String, dynamic> paymentData = {
        'orderId': int.parse(widget.orderId!),
      };

      if (_tempCardData != null) {
        // 使用临时信用卡（仅本次使用）
        paymentData['tempCard'] = _tempCardData;
      } else {
        // 使用已保存的信用卡
        paymentData['creditCardId'] = _selectedCardId;
      }

      // 调用支付接口
      await ApiRequest().request<dynamic>(
        path: '/movieOrder/pay',
        method: 'POST',
        data: paymentData,
        fromJsonT: (json) => json,
      );

      if (!mounted) return;

      // 支付成功后清除临时卡片（如果使用的是临时卡片）
      if (_tempCardData != null) {
        _tempCardData = null;
      }

      ToastService.showSuccess(S.of(context).payment_selectCreditCard_paymentSuccess);
      
      // 跳转到支付成功页面
      context.pushReplacementNamed('paySuccess', queryParameters: {
        'orderId': widget.orderId!,
      });
    } catch (e) {
      if (!mounted) return;
      ToastService.showError(S.of(context).payment_selectCreditCard_paymentFailed);
    } finally {
      if (mounted) {
        setState(() {
          _isPaying = false;
        });
      }
    }
  }

  // 添加新卡
  Future<void> _addNewCard() async {
    final result = await context.pushNamed(
      'addCreditCard',
      queryParameters: {
        'orderId': widget.orderId,
      },
    );

    if (!mounted) return;

    if (result == true) {
      // 卡片已保存到数据库，重新加载信用卡列表
      // 不清除临时卡片，让用户可以在保存的卡和临时卡之间选择
      _loadCreditCards();
    } else if (result is Map<String, dynamic>) {
      // 仅本次使用的临时卡片
      setState(() {
        _tempCardData = result;
        _selectedCardId = null; // 取消选中已保存的卡片
      });
      ToastService.showInfo(S.of(context).payment_selectCreditCard_tempCardSelected);
    }
  }

  // 获取卡类型图标
  String _getCardIcon(String cardType) {
    switch (cardType) {
      case 'Visa':
        return 'assets/icons/pay/visa.svg';
      case 'MasterCard':
        return 'assets/icons/pay/master-card.svg';
      case 'JCB':
        return 'assets/icons/pay/jcb.svg';
      case 'UnionPay':
        return 'assets/icons/pay/yinlian.svg';
      default:
        return 'assets/icons/pay/visa.svg';
    }
  }

  // 构建临时卡片项
  Widget _buildTempCardItem() {
    final isSelected = _tempCardData != null && _selectedCardId == null;
    final cardNumber = _tempCardData!['cardNumber'] as String;
    final lastFour = cardNumber.substring(cardNumber.length - 4);
    final cardType = _tempCardData!['cardType'] as String;
    final cardHolderName = _tempCardData!['cardHolderName'] as String;
    final expiryDate = _tempCardData!['expiryDate'] as String;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCardId = null; // 取消已保存卡片的选择
          // _tempCardData 保持不变，表示选中临时卡片
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF7C3AED),
                    const Color(0xFFA855F7),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.purple.shade50,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF7C3AED)
                : Colors.purple.shade200,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.purple.shade200,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Column(
          children: [
            // 临时卡片标签和删除按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withOpacity(0.2) : Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 24.sp,
                        color: isSelected ? Colors.white : Colors.purple.shade700,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        S.of(context).payment_selectCreditCard_tempCard,
                        style: TextStyle(
                          fontSize: 22.sp,
                          color: isSelected ? Colors.white : Colors.purple.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // 删除按钮
                IconButton(
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        _tempCardData = null;
                        // 如果临时卡片被选中，清除选择
                        if (_selectedCardId == null && _creditCards.isNotEmpty) {
                          _selectedCardId = _creditCards[0].id;
                        }
                      });
                      ToastService.showInfo(S.of(context).payment_selectCreditCard_tempCardRemoved);
                    }
                  },
                  icon: Icon(
                    Icons.delete_outline,
                    color: isSelected ? Colors.white70 : Colors.purple.shade400,
                    size: 32.sp,
                  ),
                  tooltip: '移除临时卡片',
                ),
              ],
            ),
            SizedBox(height: 20.h),
            
            // 卡片信息
            Row(
              children: [
                // 卡类型图标
                Container(
                  width: 100.w,
                  height: 60.h,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: SvgPicture.asset(
                    _getCardIcon(cardType),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 24.w),
                
                // 卡信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$cardType •••• $lastFour',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        cardHolderName,
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: isSelected
                              ? Colors.white70
                              : Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '有效期: $expiryDate',
                        style: TextStyle(
                          fontSize: 22.sp,
                          color: isSelected
                              ? Colors.white60
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 选中标记
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 48.sp,
                  )
                else
                  Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.purple.shade300,
                    size: 48.sp,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(
        title: Text(S.of(context).payment_selectCreditCard_title, style: const TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 信用卡列表
                Expanded(
                  child: _creditCards.isEmpty && _tempCardData == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.credit_card_off,
                                size: 120.sp,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 32.h),
                              Text(
                                S.of(context).payment_selectCreditCard_noCreditCard,
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                S.of(context).payment_selectCreditCard_pleaseAddCard,
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(32.w),
                          itemCount: (_tempCardData != null ? 1 : 0) + _creditCards.length,
                          itemBuilder: (context, index) {
                            // 如果有临时卡片，第一个显示临时卡片
                            if (_tempCardData != null && index == 0) {
                              return _buildTempCardItem();
                            }
                            
                            // 显示已保存的卡片
                            final cardIndex = _tempCardData != null ? index - 1 : index;
                            final card = _creditCards[cardIndex];
                            final isSelected = card.id == _selectedCardId;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCardId = card.id;
                                  // 不清除临时卡片，只是取消选中状态
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 24.h),
                                padding: EdgeInsets.all(32.w),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(0xFF1E3A8A),
                                            const Color(0xFF3B82F6),
                                          ],
                                        )
                                      : null,
                                  color: isSelected ? null : Colors.white,
                                  borderRadius: BorderRadius.circular(24.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF3B82F6)
                                        : Colors.grey.shade300,
                                    width: isSelected ? 3 : 1,
                                  ),
                                  boxShadow: [
                                    if (isSelected)
                                      BoxShadow(
                                        color: Colors.blue.shade200,
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // 卡类型图标
                                    Container(
                                      width: 100.w,
                                      height: 60.h,
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: SvgPicture.asset(
                                        _getCardIcon(card.cardType),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(width: 24.w),
                                    
                                    // 卡信息
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${card.cardType} •••• ${card.lastFourDigits}',
                                            style: TextStyle(
                                              fontSize: 32.sp,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            card.cardHolderName,
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              color: isSelected
                                                  ? Colors.white70
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            '有效期: ${card.expiryDate}',
                                            style: TextStyle(
                                              fontSize: 22.sp,
                                              color: isSelected
                                                  ? Colors.white60
                                                  : Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // 选中标记
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 48.sp,
                                      )
                                    else
                                      Icon(
                                        Icons.radio_button_unchecked,
                                        color: Colors.grey.shade400,
                                        size: 48.sp,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                
                // 底部按钮区域
                Container(
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 添加新卡按钮
                      SizedBox(
                        width: double.infinity,
                        height: 88.h,
                        child: OutlinedButton.icon(
                          onPressed: _addNewCard,
                          icon: Icon(Icons.add, size: 32.sp),
                          label: Text(
                            S.of(context).payment_selectCreditCard_addNewCard,
                            style: TextStyle(fontSize: 28.sp),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF3B82F6),
                            side: BorderSide(
                              color: const Color(0xFF3B82F6),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      
                      // 支付按钮
                      SizedBox(
                        width: double.infinity,
                        height: 96.h,
                        child: ElevatedButton(
                          onPressed: _isPaying || (_creditCards.isEmpty && _tempCardData == null) ? null : _pay,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          child: _isPaying
                              ? SizedBox(
                                  width: 48.w,
                                  height: 48.w,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.payment,
                                      size: 32.sp,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 16.w),
                                    Text(
                                      S.of(context).payment_selectCreditCard_confirmPayment,
                                      style: TextStyle(
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// 信用卡数据模型
class CreditCardModel {
  final int id;
  final String cardType;
  final String lastFourDigits;
  final String cardHolderName;
  final String expiryDate;

  CreditCardModel({
    required this.id,
    required this.cardType,
    required this.lastFourDigits,
    required this.cardHolderName,
    required this.expiryDate,
  });
}

