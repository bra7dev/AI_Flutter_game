import 'package:coaching_app/components/custom_appbar.dart';
import 'package:coaching_app/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/components.dart';
import '../../../components/custom_back_button.dart';
import '../../../config/routes/nav_router.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';
import '../../../utils/validators/validation_utils.dart';
import '../cubits/forgot_password_cubit.dart';
import 'forgot_password_otp_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(sl()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Forgot Password',
          leading: CustomBackButton(
            onPressed: () {
              NavRouter.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 14),
              const Text(
                'Please enter the email associated\nwith your account',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: CustomTextField(
                  hintText: 'Email',
                  title: 'Email',
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                  onValidate: (val) => ValidationUtils.validateEmail(val),
                ),
              ),
              const SizedBox(height: 12),
              BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                listener: (context, state) {
                  if (state.forgotPasswordStatus ==
                      ForgotPasswordStatus.loading) {
                    DisplayUtils.showLoader();
                  }
                  if (state.forgotPasswordStatus ==
                      ForgotPasswordStatus.success) {
                    DisplayUtils.removeLoader();
                    NavRouter.push(
                      context,
                      ForgotPasswordOtpPage(
                        verificationId: state.otp!,
                        email: emailController.text,
                      ),
                    );
                  } else if (state.forgotPasswordStatus ==
                      ForgotPasswordStatus.failure) {
                    DisplayUtils.removeLoader();
                    DisplayUtils.showSnackBar(context, state.exception.message);
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    title: 'Send OTP',
                    onPressed: () {
                      print(emailController.text);
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<ForgotPasswordCubit>()
                            .sendOtpToEmail(emailController.text);
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
