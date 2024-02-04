import 'package:coaching_app/components/components.dart';
import 'package:coaching_app/components/primary_button.dart';
import 'package:coaching_app/config/routes/nav_router.dart';
import 'package:coaching_app/modules/authentication/cubit/register_cubit/register_cubit.dart';
import 'package:coaching_app/modules/authentication/models/register_input.dart';
import 'package:coaching_app/modules/authentication/pages/login_page.dart';
import 'package:coaching_app/startup/dashboard/dashboard.dart';
import 'package:coaching_app/utils/extensions/extended_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';
import '../../../utils/validators/validation_utils.dart';
import '../widgets/password_suffix_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(sl()),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.registerStatus == RegisterStatus.submitting) {
            DisplayUtils.showLoader();
          }
          if (state.registerStatus == RegisterStatus.success) {
            DisplayUtils.removeLoader();
            NavRouter.pushAndRemoveUntil(context, Dashboard());
            DisplayUtils.showToast(context, 'Registered successfully');
          } else if (state.registerStatus == RegisterStatus.failure) {
            DisplayUtils.removeLoader();
            DisplayUtils.showSnackBar(context, state.failure.message);
          }
        },
        builder: (context, state) {
          return Builder(builder: (context) {
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: state.isAutoValidate
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/png/app-logo.png", height: 120,),
                          SizedBox(height: 46),
                          Center(
                            child: Text(
                              'Create Your Account'.toUpperCase(),
                              style: context.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            hintText: 'Full Name',
                            title: 'Full Name',
                            controller: nameController,
                            inputType: TextInputType.emailAddress,
                            onValidate: (val) =>
                                ValidationUtils.validateUserName(val),
                          ),
                          CustomTextField(
                            hintText: 'Email',
                            title: 'Email',
                            controller: emailController,
                            inputType: TextInputType.emailAddress,
                            onValidate: (val) =>
                                ValidationUtils.validateEmail(val),
                          ),
                          CustomTextField(
                            hintText: 'Password',
                            title: 'Password',
                            controller: passwordController,
                            inputType: TextInputType.visiblePassword,
                            obscureText: state.isPasswordHidden,
                            onValidate: (val) =>
                                ValidationUtils.validatePassword(val),
                            suffixWidget: PasswordSuffixWidget(
                              isPasswordVisible: state.isPasswordHidden,
                              onTap: () {
                                context.read<RegisterCubit>().toggleShowPassword();
                              },
                            ),
                          ),
                          CustomTextField(
                            hintText: 'Confirm Password',
                            title: 'Confirm Password',
                            controller: confirmPasswordController,
                            inputType: TextInputType.visiblePassword,
                            obscureText: state.isPasswordHidden,
                            onValidate: (val) =>
                                ValidationUtils.validateConfirmPassword(
                                    val, passwordController.text.toString()),
                            suffixWidget: PasswordSuffixWidget(
                              isPasswordVisible: state.isPasswordHidden,
                              onTap: () {
                                context.read<RegisterCubit>().toggleShowPassword();
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          PrimaryButton(
                            title: 'Register',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                RegisterInput input = RegisterInput(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  confirmPassword:
                                      confirmPasswordController.text,
                                );
                                context.read<RegisterCubit>().register(input);
                              } else {
                                context
                                    .read<RegisterCubit>()
                                    .enableAutoValidateMode();
                              }
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account? "),
                              GestureDetector(
                                onTap: () {
                                  NavRouter.pushReplacement(
                                      context, LoginPage());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0),
                                  child: Text("Login",
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.secondary,
                                      )),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
