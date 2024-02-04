import 'package:coaching_app/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/custom_appbar.dart';
import '../../../components/custom_back_button.dart';
import '../../../components/custom_textfield.dart';
import '../../../config/routes/nav_router.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';
import '../../../utils/validators/validation_utils.dart';
import '../../authentication/repo/auth_repository.dart';
import '../../authentication/widgets/password_suffix_widget.dart';
import '../cubit/change_password/change_password_cubit.dart';
import '../cubit/change_password/change_password_state.dart';
import '../repo/change_password_repo.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  AuthRepository authRepository = sl<AuthRepository>();

  bool isAutoValidate = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordCubit(ChangePasswordRepository()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Change Password',
          leading: CustomBackButton(
            onPressed: () {
              NavRouter.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 12),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  autovalidateMode: isAutoValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        CustomTextField(
                          title: 'Old Password',
                          hintText: 'Enter Old Password',
                          controller: oldPasswordController,
                          obscureText: !oldPasswordVisible,
                          onValidate: (val) =>
                              ValidationUtils.validatePassword(val),
                          suffixWidget: PasswordSuffixWidget(
                            onTap: () => setState(() {
                              oldPasswordVisible = !oldPasswordVisible;
                            }),
                            isPasswordVisible: oldPasswordVisible,
                          ),
                        ),
                        CustomTextField(
                          title: 'New Password',
                          hintText: 'Enter New Password',
                          controller: newPasswordController,
                          onValidate: (val) => ValidationUtils.validatePassword(
                            val,
                          ),
                          obscureText: !newPasswordVisible,
                          suffixWidget: PasswordSuffixWidget(
                            onTap: () => setState(() {
                              newPasswordVisible = !newPasswordVisible;
                            }),
                            isPasswordVisible: newPasswordVisible,
                          ),
                        ),
                        CustomTextField(
                          title: 'Confirm Password',
                          hintText: 'Confirm New Password',
                          controller: confirmPasswordController,
                          onValidate: (val) =>
                              ValidationUtils.validateConfirmPassword(
                            val,
                            newPasswordController.text,
                          ),
                          obscureText: !confirmPasswordVisible,
                          suffixWidget: PasswordSuffixWidget(
                            onTap: () => setState(() {
                              confirmPasswordVisible = !confirmPasswordVisible;
                            }),
                            isPasswordVisible: confirmPasswordVisible,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
                listener: (context, state) {
                  if (state.changePasswordStatus ==
                      ChangePasswordStatus.loading) {
                    DisplayUtils.showLoader();
                  }
                  if (state.changePasswordStatus ==
                      ChangePasswordStatus.success) {
                    DisplayUtils.removeLoader();
                    DisplayUtils.showSnackBar(
                        context, 'Password Updated Successfully');
                    NavRouter.pop(context);
                  }

                  if (state.changePasswordStatus ==
                      ChangePasswordStatus.failure) {
                    DisplayUtils.removeLoader();
                    DisplayUtils.showSnackBar(context, state.failure.message);
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    title: 'Save',
                    horizontalPadding: 0,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _formKey.currentState!.save();

                      if (_formKey.currentState!.validate()) {
                        if (oldPasswordController.text ==
                            newPasswordController.text) {
                          DisplayUtils.showSnackBar(
                              context, 'Old and New Password cannot be Same');
                        } else {
                          var changePasswordInput = ChangePasswordInput(
                            newPassword: newPasswordController.text,
                            oldPassword: oldPasswordController.text,
                          );
                          context
                              .read<ChangePasswordCubit>()
                              .changePassword(changePasswordInput);
                        }
                      } else {
                        setState(() {
                          isAutoValidate = true;
                        });
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
