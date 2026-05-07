import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/logging/log.dart';
import 'package:mbh/app/modules/auth/controllers/login_controller.dart';
import 'package:mbh/app/shared/shared.dart';

import '../../../core/localization/locale_keys.dart';
import '../../../core/theme/tokens/spacing.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPink = Color(0xFFFF4B73);
    const Color pageBackground = Colors.white;
    const Color fieldBackground = Color(0xFFF8F8F8);
    const Color hintColor = Color(0xFFB6BAC3);
    const Color titleColor = Color(0xFF252A35);
    const Color subtitleColor = Color(0xFF6F7684);
    const Color linkColor = Color(0xFF3D5A98);

    return Scaffold(
      backgroundColor: pageBackground,
      body: Obx(
        () => BaseStatePage(
          isLoading: controller.isLoading.value,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.xl,
                vertical: Spacing.lg,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _LoginTopBar(iconColor: titleColor),
                    const SizedBox(height: 72),
                    const _LoginLogo(),
                    const SizedBox(height: Spacing.lg),
                    Text(
                      'MBH',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      LocaleKeys.loginSubtitle.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 36),
                    _LoginInput(
                      hintText: LocaleKeys.loginEmailPlaceholder.tr,
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (String value) => controller.account.value = value,
                    ),
                    const SizedBox(height: Spacing.lg),
                    _LoginInput(
                      hintText: LocaleKeys.loginPasswordPlaceholder.tr,
                      icon: Icons.lock_outline_rounded,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onChanged: (String value) => controller.password.value = value,
                    ),
                    const SizedBox(height: Spacing.xl),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: controller.canSubmit
                            ? () {
                                Log.i('login', '点击登录按钮');
                                controller.login();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: primaryPink,
                          disabledBackgroundColor: primaryPink.withValues(alpha: 0.45),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                LocaleKeys.loginTitle.tr,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    const Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _LoginLink(
                              textKey: LocaleKeys.loginForgotPassword,
                              color: linkColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _LoginLink(
                              textKey: LocaleKeys.loginRegister,
                              color: linkColor,
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
      ),
    );
  }
}

class _LoginTopBar extends StatelessWidget {
  const _LoginTopBar({required this.iconColor});

  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: iconColor, size: 20),
          splashRadius: 20,
        ),
        Expanded(
          child: Text(
            LocaleKeys.loginTitle.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: iconColor,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.home_outlined, color: iconColor, size: 22),
          splashRadius: 20,
        ),
      ],
    );
  }
}

class _LoginLogo extends StatelessWidget {
  const _LoginLogo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 96,
        height: 96,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF7ED4FF), Color(0xFF5EC4F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 8,
              bottom: 10,
              child: Container(
                width: 80,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE53C),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(44),
                    bottomRight: Radius.circular(44),
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
              ),
            ),
            const Icon(
              Icons.flutter_dash_rounded,
              size: 42,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginInput extends StatelessWidget {
  const _LoginInput({
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onChanged,
  });

  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFC9CDD5), size: 22),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xFFB6BAC3),
        ),
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFF4B73), width: 1.2),
        ),
      ),
    );
  }
}

class _LoginLink extends StatelessWidget {
  const _LoginLink({required this.textKey, required this.color});

  final String textKey;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        textKey.tr,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
