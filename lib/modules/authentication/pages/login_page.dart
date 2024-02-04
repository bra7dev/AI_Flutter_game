import 'package:coaching_app/components/components.dart';
import 'package:coaching_app/components/primary_button.dart';
import 'package:coaching_app/config/routes/nav_router.dart';
import 'package:coaching_app/constants/app_colors.dart';
import 'package:coaching_app/modules/authentication/cubit/login_cubit/login_cubit.dart';
import 'package:coaching_app/startup/dashboard/dashboard.dart';
import 'package:coaching_app/utils/extensions/extended_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/display/display_utils.dart';
import '../../../utils/validators/validation_utils.dart';
import '../../forget_password/pages/forgot_password_page.dart';
import '../models/login_input.dart';
import '../widgets/password_suffix_widget.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLoginButtonPressed() {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      LoginInput loginInput = LoginInput(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      context.read<LoginCubit>().login(loginInput);
    } else {
      context.read<LoginCubit>().enableAutoValidateMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.loginStatus == LoginStatus.submitting) {
          DisplayUtils.showLoader();
        }
        if (state.loginStatus == LoginStatus.success) {
          DisplayUtils.removeLoader();
          NavRouter.pushAndRemoveUntil(context, Dashboard());
          DisplayUtils.showToast(context, 'Logged in successfully');
        } else if (state.loginStatus == LoginStatus.failure) {
          DisplayUtils.removeLoader();
          DisplayUtils.showSnackBar(context, state.failure.message);
        }
      },
      builder: (context, state) {
        return Builder(builder: (context) {
          return Scaffold(
            body: Center(
              child: Form(
                key: _formKey,
                autovalidateMode: state.isAutoValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/png/app-logo.png", height: 120,),
                      SizedBox(height: 46),
                      Center(
                        child: Text(
                          'Welcome Back'.toUpperCase(),
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Center(child: Text('Sign in to continue')),
                      SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Email',
                        title: 'Email',
                        controller: emailController,
                        inputType: TextInputType.emailAddress,
                        onValidate: (val) => ValidationUtils.validateEmail(val),
                      ),
                      CustomTextField(
                        hintText: 'Password',
                        title: 'Password',
                        controller: passwordController,
                        inputType: TextInputType.visiblePassword,
                        obscureText: state.isPasswordHidden,
                        onValidate: (val) =>
                            ValidationUtils.validatePassword(val),
                        onSaved: (val) {},
                        suffixWidget: PasswordSuffixWidget(
                          isPasswordVisible: state.isPasswordHidden,
                          onTap: () {
                            context.read<LoginCubit>().toggleShowPassword();
                          },
                        ),
                        bottomMargin: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          NavRouter.push(context, ForgotPasswordPage());
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              'Forgot Password?',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      PrimaryButton(
                        title: 'Login',
                        onPressed: () {
                          _onLoginButtonPressed();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Didn't have an account? "),
                          GestureDetector(
                            onTap: () {
                              NavRouter.pushReplacement(
                                  context, RegisterPage());
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: Text("Register",
                                  style: context.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600, color: AppColors.secondary,)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
