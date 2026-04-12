import 'package:digi_care_pro/app/logic/login_logic.dart';
import 'package:digi_care_pro/app/routes/app_pages.dart';
import 'package:digi_care_pro/app/routes/app_routes.dart';
import 'package:digi_care_pro/app/ui/theme/app_colors.dart';
import 'package:digi_care_pro/app/ui/theme/app_dimens.dart';
import 'package:digi_care_pro/app/ui/theme/app_theme.dart';
import 'package:digi_care_pro/app/ui/widgets/app_text_field.dart';
import 'package:digi_care_pro/app/ui/widgets/primary_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  LoginLogic logic = LoginLogic();
  bool _isKeyboardVisible = false;

  final _emailController = TextEditingController(text: kDebugMode ? 'ahmad.ab1993@gmail.com' : '');
  final _passwordController = TextEditingController(text: kDebugMode ? '123456' : '');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Get.put(logic);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginLogic>(
      builder: (logic) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(bodyPadding),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_isKeyboardVisible)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Image.asset('assets/images/logo2.png', height: 50)],
                          ),
                        SizedBox(height: 50),
                        Text(
                          'log_in'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text('login_caption'.tr, style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 32),
                        AutofillGroup(
                          child: Column(
                            children: [
                              AppTextField(
                                controller: _emailController,
                                title: 'email'.tr,
                                hint: 'email_hint'.tr,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                              ),
                              SizedBox(height: 16),
                              AppTextField(
                                controller: _passwordController,
                                title: 'password'.tr,
                                hint: 'password_hint'.tr,
                                keyboardType: TextInputType.visiblePassword,
                                autofillHints: const [AutofillHints.password],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => Get.toNamed(Routes.FORGET_PASSWORD),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'forget_pass'.tr,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        PrimaryButton(
                          label: 'login'.tr,
                          onPressed: () {
                            logic.getCompaniesAndLogin(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (!_isKeyboardVisible)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => launchUrl(
                            Uri.parse('https://www.instagram.com/digicarepro?igsh=MWpueGV5Z3FrOXlibQ=='),
                            mode: LaunchMode.externalApplication,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SvgPicture.asset(
                              'assets/icons/instagram.svg',
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => launchUrl(
                            Uri.parse('https://www.facebook.com/share/16gba7n8fi/?mibextid=wwXIfr'),
                            mode: LaunchMode.externalApplication,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SvgPicture.asset(
                              'assets/icons/facebook.svg',
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
