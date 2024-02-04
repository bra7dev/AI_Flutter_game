import 'package:coaching_app/components/custom_appbar.dart';
import 'package:coaching_app/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../components/components.dart';
import '../../../config/routes/nav_router.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';
import '../../authentication/pages/login_page.dart';
import '../../authentication/widgets/password_suffix_widget.dart';
import '../cubits/reset_password_cubit.dart';

class NewPasswordPage extends StatefulWidget {
  final String otp;
  final String email;

  const NewPasswordPage({
    Key? key,
    required this.otp,
    required this.email,
  }) : super(key: key);

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  bool isAutoValidate = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(sl()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Reset password',
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: isAutoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    title: 'New Password',
                    hintText: 'New Password',
                    controller: newPasswordController,
                    obscureText: !isPasswordVisible,
                    suffixWidget: PasswordSuffixWidget(
                      isPasswordVisible: isPasswordVisible,
                      onTap: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    onValidate: (val) {
                      if (val!.isEmpty) {
                        return 'Password is required';
                      } else if (val.length < 8) {
                        return 'Password must be 8 characters long';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    title: 'Confirm Password',
                    hintText: 'Confirm Password',
                    obscureText: !isConfirmPasswordVisible,
                    controller: confirmPasswordController,
                    suffixWidget: PasswordSuffixWidget(
                      isPasswordVisible: isConfirmPasswordVisible,
                      onTap: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                    ),
                    onValidate: (val) {
                      if (val!.isEmpty) {
                        return 'Password is required';
                      } else if (confirmPasswordController.text !=
                          newPasswordController.text) {
                        return 'Password must be same';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                    listener: (context, state) {
                      if (state.resetPasswordStatus ==
                          ResetPasswordStatus.loading) {
                        DisplayUtils.showLoader();
                      }
                      if (state.resetPasswordStatus ==
                          ResetPasswordStatus.success) {
                        DisplayUtils.removeLoader();
                        Fluttertoast.showToast(
                            msg: "Reset Password Successfully!");
                        NavRouter.pushAndRemoveUntil(
                          context,
                          const LoginPage(
                          ),
                        );
                      } else if (state.resetPasswordStatus ==
                          ResetPasswordStatus.failure) {
                        DisplayUtils.removeLoader();
                        DisplayUtils.showSnackBar(
                          context,
                          state.exception.message,
                        );
                      }
                    },
                    builder: (context, state) {
                      return PrimaryButton(
                        title: 'Continue',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ResetPasswordInput input = ResetPasswordInput(
                              otp: widget.otp,
                              email: widget.email,
                              newPassword: newPasswordController.text,
                              confirmPassword: newPasswordController.text,
                            );
                            context
                                .read<ResetPasswordCubit>()
                                .resetUserPassword(input);
                          } else {
                            isAutoValidate = true;
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 25)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
