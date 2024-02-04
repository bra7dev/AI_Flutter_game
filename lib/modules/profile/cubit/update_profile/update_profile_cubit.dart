import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../../core/core.dart';
import '../../repo/update_profile_repo.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit(
    this.updateProfileRepo,
  ) : super(UpdateProfileState.initial());

  UpdateProfileRepo updateProfileRepo;

  Future<void> updateProfile(
      UpdateProfileInput updateProfileInput, File? file) async {
    // ================================ if user has picked the image ================================
    MultipartFile? image;

    // ================================ ============================ ================================

    try {
      emit(state.copyWith(updateProfileStatus: UpdateProfileStatus.loading));
      if (file != null) {

        XFile? compressedImage = await compressImage(file.path);
        if (compressedImage != null) {
          // Get the file size in bytes
          int fileSizeInBytes = File(compressedImage.path).lengthSync();

          // Convert bytes to megabytes (MB)
          double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

          // Check if the compressed image is less than 2MB
          if (fileSizeInMB < 2) {
            print(compressedImage.path);
            image = await MultipartFile.fromFile(
              compressedImage.path,
              filename: compressedImage.name,
            );
            updateProfileInput.profileImage = image;
          } else {
            emit(state.copyWith(
                updateProfileStatus: UpdateProfileStatus.failure,
                exception:
                HighPriorityException('Image should be less than 2MB')));
            return;
          }
        }
      }
      bool result = await updateProfileRepo
          .updateProfileApi(updateProfileInput.toFormData());
      if (result) {
        emit(state.copyWith(
          updateProfileStatus: UpdateProfileStatus.success,
        ));
      } else {
        emit(state.copyWith(
            updateProfileStatus: UpdateProfileStatus.failure,
            exception: const HighPriorityException(
                'Unknown Error, Please try again')));
      }
    } on BaseFailure catch (exception) {
      emit(state.copyWith(
          updateProfileStatus: UpdateProfileStatus.failure,
          exception: HighPriorityException(exception.message)));
    } catch (err) {
      emit(state.copyWith(
          updateProfileStatus: UpdateProfileStatus.failure,
          exception: HighPriorityException(err.toString())));
    }
  }

  Future<XFile?> compressImage(String imagePath) async {
  try{
    // Compress the image
    XFile? compressedImage = await FlutterImageCompress.compressAndGetFile(
      imagePath,
      imagePath.replaceAll('.jpg', '_compressed.jpg'),
      minWidth: 1024,
      minHeight: 1024,
      quality: 85,
    );
    return compressedImage;
  }catch(error){
    print(error);
    return null;
  }
  }
}

class UpdateProfileInput {
  final String name;
  final String location;
  final String personalInfo;
  MultipartFile? profileImage;

  UpdateProfileInput({
    required this.name,
    required this.personalInfo,
    required this.location,
    this.profileImage,
  });

  Map<String, dynamic> toJson() => {
        "full_name": name,
        "location": location,
        "personal_info": personalInfo,
        "image": profileImage,
      };

  FormData toFormData() => FormData.fromMap(
        {
          "full_name": name,
          "location": location,
          "personal_info": personalInfo,
          "image": profileImage,
        },
      );

  @override
  String toString() {
    return 'Image is :: $profileImage, name is :: $name,';
  }
}
