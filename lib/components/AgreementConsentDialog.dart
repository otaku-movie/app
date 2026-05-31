import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/service/agreement_service.dart';

/// 协议变更确认弹窗。
///
/// - 列出所有需要重新同意的协议，并允许用户点击查看详情；
/// - 顶部勾选「我已阅读并同意」后才能点击同意按钮；
/// - 含有 `isRequiredAccept == true` 的协议时禁用返回键、屏蔽点遮罩关闭。
class AgreementConsentDialog extends StatefulWidget {
  final List<AgreementInfo> agreements;

  const AgreementConsentDialog({super.key, required this.agreements});

  @override
  State<AgreementConsentDialog> createState() => _AgreementConsentDialogState();
}

class _AgreementConsentDialogState extends State<AgreementConsentDialog> {
  bool _checked = false;
  bool _submitting = false;

  bool get _hasRequired =>
      widget.agreements.any((e) => e.isRequiredAccept);

  String _displayTitle(BuildContext context, AgreementInfo info) {
    if (info.title.isNotEmpty) return info.title;
    switch (info.code) {
      case 'USER_TERMS':
        return S.of(context).user_userTerms;
      case 'PRIVACY_POLICY':
        return S.of(context).user_privateAgreement;
      case 'THIRD_PARTY_SDK':
        return S.of(context).user_thirdPartySdk;
      default:
        return info.code;
    }
  }

  Future<void> _agreeAll() async {
    if (!_checked || _submitting) return;
    setState(() => _submitting = true);
    try {
      for (final info in widget.agreements) {
        await AgreementService.instance.markAccepted(info);
      }
      if (mounted) Navigator.of(context).pop(true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _disagree() {
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return PopScope(
      canPop: !_hasRequired,
      child: Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 80.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 0.75.sh),
          child: Padding(
            padding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1989FA).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.shield_outlined,
                        color: const Color(0xFF1989FA),
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        s.agreement_consent_title,
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF323233),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  s.agreement_consent_subtitle,
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16.h),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: widget.agreements
                          .map((info) => _AgreementItem(
                                info: info,
                                title: _displayTitle(context, info),
                                versionLabel:
                                    '${s.agreement_consent_currentVersion}: v${info.version}',
                                viewDetailLabel: s.agreement_consent_viewDetail,
                                onTap: () {
                                  context.pushNamed(
                                    'agreement',
                                    pathParameters: {'code': info.code},
                                  );
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  child: InkWell(
                    onTap: () => setState(() => _checked = !_checked),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 6.h,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              color: _checked
                                  ? const Color(0xFF1989FA)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: _checked
                                    ? const Color(0xFF1989FA)
                                    : const Color(0xFFC8C9CC),
                                width: 1.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 150),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: _checked
                                  ? Icon(
                                      Icons.check_rounded,
                                      key: const ValueKey('checked'),
                                      size: 26.sp,
                                      color: Colors.white,
                                    )
                                  : const SizedBox.shrink(
                                      key: ValueKey('unchecked'),
                                    ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              s.agreement_consent_readAndAgree,
                              style: TextStyle(
                                fontSize: 22.sp,
                                color: Colors.grey.shade800,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _submitting ? null : _disagree,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                          foregroundColor: Colors.grey.shade700,
                        ),
                        child: Text(
                          s.agreement_consent_disagree,
                          style: TextStyle(fontSize: 22.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: (!_checked || _submitting) ? null : _agreeAll,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1989FA),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                          disabledBackgroundColor:
                              const Color(0xFF1989FA).withValues(alpha: 0.4),
                          disabledForegroundColor: Colors.white,
                        ),
                        child: _submitting
                            ? SizedBox(
                                width: 22.w,
                                height: 22.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : Text(
                                s.agreement_consent_agree,
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AgreementItem extends StatelessWidget {
  final AgreementInfo info;
  final String title;
  final String versionLabel;
  final String viewDetailLabel;
  final VoidCallback onTap;

  const _AgreementItem({
    required this.info,
    required this.title,
    required this.versionLabel,
    required this.viewDetailLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1989FA);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          splashColor: primaryColor.withValues(alpha: 0.08),
          highlightColor: primaryColor.withValues(alpha: 0.04),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFFEBEDF0),
                width: 1,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.description_outlined,
                    size: 24.sp,
                    color: primaryColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF323233),
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        versionLabel,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey.shade600,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        viewDetailLabel,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        Icons.chevron_right,
                        size: 20.sp,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
