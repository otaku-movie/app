import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/payment/credit_card_response.dart';

class SelectCreditCard extends StatefulWidget {
  final String? orderNumber;
  
  const SelectCreditCard({super.key, this.orderNumber});

  @override
  State<SelectCreditCard> createState() => _SelectCreditCardState();
}

class _SelectCreditCardState extends State<SelectCreditCard> {
  List<CreditCardResponse> _creditCards = [];
  int? _selectedCardId;
  bool _isLoading = false;
  bool _isPaying = false;
  TempCard? _tempCard; // 临时信用卡数据（仅本次使用）

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
      final response = await ApiRequest().request<List<dynamic>>(
        path: '/creditCard/list',
        method: 'GET',
        fromJsonT: (json) => json as List<dynamic>,
      );
      
      if (!mounted) return;
      
      setState(() {
        _creditCards = (response.data ?? [])
            .map((item) => CreditCardResponse.fromJson(item))
            .toList();
        
        // 选择默认信用卡或第一张卡
        if (_creditCards.isNotEmpty) {
          final defaultCard = _creditCards.firstWhere(
            (card) => card.isDefault == true,
            orElse: () => _creditCards.first,
          );
          _selectedCardId = defaultCard.id;
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
    if (_selectedCardId == null && _tempCard == null) {
      ToastService.showWarning(S.of(context).payment_selectCreditCard_pleaseSelectCard);
      return;
    }

    if (!mounted) return;
    
    setState(() {
      _isPaying = true;
    });

    final orderNumber = widget.orderNumber;
    if (orderNumber == null || orderNumber.isEmpty) {
      ToastService.showError('订单号无效');
      setState(() => _isPaying = false);
      return;
    }
    try {
      // 准备支付数据
      final paymentRequest = PaymentRequest(
        orderNumber: orderNumber,
        creditCardId: _tempCard == null ? _selectedCardId : null,
        tempCard: _tempCard,
      );

      // 调用支付接口
      final res = await ApiRequest().request<dynamic>(
        path: '/movieOrder/pay',
        method: 'POST',
        data: paymentRequest.toJson(),
        fromJsonT: (json) => json,
      );

      if (!mounted) return;

      // 仅当后端明确返回 code==200 时跳转成功页，否则一律跳失败页（含 code 为 null 或非 200）
      if (res.code == 200) {
        // 支付成功后清除临时卡片（如果使用的是临时卡片）
        if (_tempCard != null) {
          _tempCard = null;
        }
        ToastService.showSuccess(S.of(context).payment_selectCreditCard_paymentSuccess);
        context.pushReplacementNamed('paySuccess', queryParameters: {
          'orderNumber': orderNumber,
        });
      } else {
        context.pushReplacementNamed('payError', queryParameters: {
          'reason': res.message ?? S.of(context).payment_selectCreditCard_paymentFailed,
        });
      }
    } catch (e) {
      if (!mounted) return;
      context.pushReplacementNamed('payError', queryParameters: {
        'reason': S.of(context).payment_selectCreditCard_paymentFailed,
      });
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
        'orderNumber': widget.orderNumber,
      },
    );

    if (!mounted) return;

    if (result == true) {
      // 卡片已保存到数据库，重新加载信用卡列表
      // 不清除临时卡片，让用户可以在保存的卡和临时卡之间选择
      _loadCreditCards();
    } else if (result is TempCard) {
      // 仅本次使用的临时卡片
      setState(() {
        _tempCard = result;
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

  // 构建已保存信用卡项：主信息 + 右侧 [编辑] + 选中标记（删除在 AppBar）
  Widget _buildSavedCardItem(CreditCardResponse card, bool isSelected) {
    final isDefault = card.isDefault == true;

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              )
            : null,
        color: isSelected ? null : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE5E7EB),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
              blurRadius: 24,
              offset: const Offset(0, 10),
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedCardId = card.id;
              });
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(28.w, 28.h, 16.w, 28.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 卡 logo
                  Container(
                    width: 96.w,
                    height: 60.h,
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: SvgPicture.asset(
                      _getCardIcon(card.cardType ?? ''),
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 24.w),

                  // 卡信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${card.cardType ?? ''} •••• ${card.lastFourDigits ?? ''}',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : const Color(0xFF111827),
                                  letterSpacing: 0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isDefault) ...[
                              SizedBox(width: 12.w),
                              _buildDefaultBadge(isSelected),
                            ],
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          card.cardHolderName ?? '',
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: isSelected ? Colors.white70 : const Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '有效期 ${card.expiryDate ?? ''}',
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: isSelected ? Colors.white60 : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),

                  // 编辑按钮（紧贴选中标记左侧）
                  IconButton(
                    tooltip: S.of(context).creditCard_action_edit,
                    onPressed: () => _editCard(card),
                    splashRadius: 28.sp,
                    padding: EdgeInsets.all(8.w),
                    constraints: BoxConstraints(minWidth: 56.sp, minHeight: 56.sp),
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 32.sp,
                      color: isSelected ? Colors.white : const Color(0xFF3B82F6),
                    ),
                  ),

                  // 选中标记
                  Icon(
                    isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                    color: isSelected ? Colors.white : const Color(0xFFD1D5DB),
                    size: 40.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 「默认」徽标
  Widget _buildDefaultBadge(bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.18) : const Color(0xFFF59E0B),
        borderRadius: BorderRadius.circular(6.r),
        border: isSelected
            ? Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 22.sp,
            color: Colors.white,
          ),
          SizedBox(width: 4.w),
          Text(
            S.of(context).creditCard_badge_default,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  // 管理模式：用户中心进入（无 orderNumber）；下单流程下不开放"删除"
  bool get _isManageMode =>
      widget.orderNumber == null || widget.orderNumber!.isEmpty;

  // AppBar 删除按钮：删除当前选中卡；未选中给提示
  void _handleHeaderDelete() {
    final id = _selectedCardId;
    if (id == null) {
      ToastService.showWarning(S.of(context).creditCard_deleteHint_selectFirst);
      return;
    }
    _confirmDeleteCard(id);
  }

  // 跳转到 AddCreditCard 编辑模式
  Future<void> _editCard(CreditCardResponse card) async {
    final result = await context.pushNamed(
      'addCreditCard',
      queryParameters: {
        if (widget.orderNumber != null) 'orderNumber': widget.orderNumber!,
      },
      extra: card,
    );
    if (!mounted) return;
    if (result == true) {
      await _loadCreditCards();
    }
  }

  // 删除卡：弹确认
  Future<void> _confirmDeleteCard(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        titlePadding: EdgeInsets.fromLTRB(32.w, 32.h, 32.w, 16.h),
        contentPadding: EdgeInsets.fromLTRB(32.w, 0, 32.w, 16.h),
        actionsPadding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        title: Row(
          children: [
            Container(
              width: 56.sp,
              height: 56.sp,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: const Color(0xFFEF4444),
                size: 32.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                S.of(context).creditCard_deleteConfirm_title,
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ],
        ),
        content: Text(
          S.of(context).creditCard_deleteConfirm_content,
          style: TextStyle(
            fontSize: 24.sp,
            color: const Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text(
              S.of(context).creditCard_edit_cancel,
              style: TextStyle(
                fontSize: 26.sp,
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text(
              S.of(context).creditCard_action_delete,
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final res = await ApiRequest().request<dynamic>(
        path: '/creditCard/delete',
        method: 'DELETE',
        queryParameters: {'id': id},
        fromJsonT: (json) => json,
      );
      if (!mounted) return;
      if (res.code == 200) {
        // 如果删的就是当前选中卡，清掉选中
        if (_selectedCardId == id) {
          _selectedCardId = null;
        }
        await _loadCreditCards();
      } else {
        ToastService.showError(res.message ?? S.of(context).creditCard_operationFailed);
      }
    } catch (_) {
      if (!mounted) return;
      ToastService.showError(S.of(context).creditCard_operationFailed);
    }
  }

  // 构建临时卡片项
  Widget _buildTempCardItem() {
    final isSelected = _tempCard != null && _selectedCardId == null;
    final cardNumber = _tempCard!.cardNumber;
    final lastFour = cardNumber.substring(cardNumber.length - 4);
    final cardType = _tempCard!.cardType;
    final cardHolderName = _tempCard!.cardHolderName;
    final expiryDate = _tempCard!.expiryDate;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCardId = null; // 取消已保存卡片的选择
          // _tempCard 保持不变，表示选中临时卡片
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
                    color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.purple.shade100,
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
                        _tempCard = null;
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
        title: Text(
          (widget.orderNumber == null || widget.orderNumber!.isEmpty)
              ? S.of(context).user_creditCard
              : S.of(context).payment_selectCreditCard_title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: _isManageMode
            ? [
                IconButton(
                  tooltip: S.of(context).creditCard_action_delete,
                  onPressed: _creditCards.isEmpty ? null : _handleHeaderDelete,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: _creditCards.isEmpty ? Colors.white38 : Colors.white,
                    size: 40.sp,
                  ),
                ),
                SizedBox(width: 8.w),
              ]
            : null,
      ),
      body: AppErrorWidget(
        loading: _isLoading,
        // error: error,
        // empty: !_isLoading && !error && _creditCards.isEmpty && _tempCard == null,
        child:  Column(
              children: [
                // 信用卡列表
                Expanded(
                  child: _creditCards.isEmpty && _tempCard == null
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
                          itemCount: (_tempCard != null ? 1 : 0) + _creditCards.length,
                          itemBuilder: (context, index) {
                            // 如果有临时卡片，第一个显示临时卡片
                            if (_tempCard != null && index == 0) {
                              return _buildTempCardItem();
                            }
                            
                            final cardIndex = _tempCard != null ? index - 1 : index;
                            final card = _creditCards[cardIndex];
                            final isSelected = card.id == _selectedCardId;
                            return _buildSavedCardItem(card, isSelected);
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
                      if (widget.orderNumber != null && widget.orderNumber!.isNotEmpty) ...[
                        SizedBox(height: 24.h),
                        SizedBox(
                          width: double.infinity,
                          height: 96.h,
                          child: ElevatedButton(
                            onPressed: _isPaying || (_creditCards.isEmpty && _tempCard == null) ? null : _pay,
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
                    ],
                  ),
                ),
              ],
            ),
      )
    );
  }
}


