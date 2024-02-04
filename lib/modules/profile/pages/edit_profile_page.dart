import 'package:coaching_app/components/custom_appbar.dart';
import 'package:coaching_app/components/primary_button.dart';
import 'package:coaching_app/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/custom_back_button.dart';
import '../../../components/custom_textfield.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/dialogs/dialog_utils.dart';
import '../../../utils/display/display_utils.dart';
import '../../../utils/validators/validation_utils.dart';
import '../../authentication/repo/auth_repository.dart';
import '../cubit/image_picker/image_picker_cubit.dart';
import '../cubit/update_profile/update_profile_cubit.dart';
import '../repo/image_picker_repo.dart';
import '../repo/update_profile_repo.dart';
import '../widget/profile_picture_widget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  AuthRepository authRepository = sl<AuthRepository>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController personalInfoController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool updated = false;

  @override
  void initState() {
    super.initState();
    initTextFields();
  }

  void initTextFields() {
    fullNameController.text = authRepository.user.fullName;
    emailController.text = authRepository.user.email;
    personalInfoController.text = authRepository.user.personalInfo;
    locationController.text = authRepository.user.location;
  }

  isDataUpdated() {
    if ((fullNameController.text != authRepository.user.fullName) ||
        (locationController.text != authRepository.user.location))
      updated = true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ImagePickerCubit(ImagePickerRepo()),
        ),
        BlocProvider(
          create: (context) => UpdateProfileCubit(UpdateProfileRepo()),
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Edit Profile',
          leading: CustomBackButton(
            onPressed: () {
              NavRouter.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28.0),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        BlocBuilder<ImagePickerCubit, ImagePickerState>(
                          builder: (context, imageState) {
                            if (imageState.hasImage) updated = true;
                            return ProfilePictureWidget(
                              profileUrl: imageState.hasImage
                                  ? imageState.file!.path
                                  : authRepository.user.profile.isNotEmpty
                                      ? sl<Flavors>().config.imageBaseUrl +
                                          authRepository.user.profile
                                      : "assets/images/png/placeholder.jpg",
                              onTap: () async {
                                String res =
                                    await DialogUtils.uploadPictureDialog(
                                        context);
                                if (res == 'gallery')
                                  context
                                      .read<ImagePickerCubit>()
                                      .pickImage(ImageSource.gallery);
                                if (res == 'camera')
                                  context
                                      .read<ImagePickerCubit>()
                                      .pickImage(ImageSource.camera);
                                print(res);
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        CustomTextField(
                          title: 'Full Name',
                          hintText: 'Full Name',
                          controller: fullNameController,
                          onValidate: (val) =>
                              ValidationUtils.validateUserName(val),
                          onChange: (_) {
                            updated = true;
                          },
                        ),
                        CustomTextField(
                          title: 'Location',
                          hintText: 'Location',
                          controller: locationController,
                          onChange: (_) {
                            updated = true;
                          },
                        ),
                        CustomTextField(
                          title: 'Personal Info',
                          hintText: 'Personal Info',
                          controller: personalInfoController,
                          minLines: 3,
                          onChange: (_) {
                            updated = true;
                          },
                        ),
                        CustomTextField(
                          title: 'Email',
                          hintText: 'Email',
                          controller: emailController,
                          inputType: TextInputType.name,
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
                listener: (context, state) {
                  if (state.updateProfileStatus ==
                      UpdateProfileStatus.loading) {
                    DisplayUtils.showLoader();
                  }
                  if (state.updateProfileStatus ==
                      UpdateProfileStatus.success) {
                    DisplayUtils.removeLoader();
                    DisplayUtils.showSnackBar(
                        context, 'Profile Updated Successfully');
                    /*updated = false;*/
                    NavRouter.pop(context);
                  }

                  if (state.updateProfileStatus ==
                      UpdateProfileStatus.failure) {
                    DisplayUtils.removeLoader();
                    DisplayUtils.showSnackBar(context, state.exception.message);
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    title: 'Update',
                    onPressed: () async {
                      await isDataUpdated();
                      FocusManager.instance.primaryFocus?.unfocus();
                      _formKey.currentState?.save();
                      if (_formKey.currentState!.validate() && updated) {
                        var updateProfileInput = UpdateProfileInput(
                          name: fullNameController.text,
                          location: locationController.text,
                          personalInfo: personalInfoController.text
                        );
                        context.read<UpdateProfileCubit>().updateProfile(
                            updateProfileInput,
                            context.read<ImagePickerCubit>().state.file,);
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
