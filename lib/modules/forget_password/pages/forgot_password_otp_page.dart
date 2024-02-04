import 'package:coaching_app/components/custom_appbar.dart';
import 'package:coaching_app/components/primary_button.dart';
import 'package:coaching_app/utils/extensions/extended_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../config/config.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';
import '../cubits/forgot_password_cubit.dart';
import 'new_password_page.dart';

class ForgotPasswordOtpPage extends StatefulWidget {
  final String verificationId;
  final String email;

  const ForgotPasswordOtpPage({
    Key? key,
    required this.verificationId,
    required this.email,
  }) : super(key: key);

  @override
  State<ForgotPasswordOtpPage> createState() => _ForgotPasswordOtpPageState();
}

class _ForgotPasswordOtpPageState extends State<ForgotPasswordOtpPage> {
  bool isFilled = false;
  String verificationId = "";
  String otp = '';

  @override
  void initState() {
    verificationId = widget.verificationId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(sl()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'OTP Verification',
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                "Enter OTP sent to\n${widget.email}",
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: PinCodeTextField(
                  appContext: context,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    color: AppColors.grey1,
                    fontWeight: FontWeight.w600,
                  ),
                  pastedTextStyle: const TextStyle(
                    color: AppColors.grey1,
                    fontWeight: FontWeight.w500,
                  ),
                  length: 4,
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    fieldHeight: 45,
                    borderWidth: 1.4,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    activeColor: AppColors.grey1,
                    selectedColor: Colors.amber,
                    inactiveColor: AppColors.grey1,
                    fieldWidth: 45,
                  ),
                  cursorColor: Colors.white,
                  animationDuration: const Duration(milliseconds: 300),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onCompleted: (otp) {
                    // todo :: on completion handler
                  },
                  onChanged: (otp) {
                    this.otp = otp;
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Text('OTP is: $verificationId'),
              const SizedBox(
                height: 14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Haven't received the verification code?"),
                  BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                    listener: (context, state) {
                      if (state.forgotPasswordStatus ==
                          ForgotPasswordStatus.resendLoading) {
                        DisplayUtils.showLoader();
                      }
                      if (state.forgotPasswordStatus ==
                          ForgotPasswordStatus.resent) {
                        DisplayUtils.removeLoader();
                        Fluttertoast.showToast(msg: "OTP sent again!");
                        verificationId = state.otp!;
                      } else if (state.forgotPasswordStatus ==
                          ForgotPasswordStatus.failure) {
                        DisplayUtils.removeLoader();
                        DisplayUtils.showSnackBar(
                            context, state.exception.message);
                      }
                    },
                    builder: (context, state) {
                      return TextButton(
                        onPressed: () {
                          context.read<ForgotPasswordCubit>().resendOtpToEmail(
                              widget.email);
                        },
                        child: Text(
                          "Resend",
                          style: TextStyle(color: Colors.amber),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                title: 'Verify',
                onPressed: () async {
                  debugPrint(verificationId);
                  if (otp.length < 4) {
                    Fluttertoast.showToast(msg: 'Please enter the OTP');
                    return;
                  }
                  if (otp == verificationId) {
                    NavRouter.push(context, NewPasswordPage(
                      otp: verificationId, email: widget.email,));
                  }
                  else {
                    Fluttertoast.showToast(msg: 'Invalid OTP');
                  }
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
