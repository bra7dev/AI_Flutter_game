import 'package:coaching_app/components/custom_appbar.dart';
import 'package:coaching_app/components/custom_dropdown.dart';
import 'package:coaching_app/modules/goal/cubit/add_goal_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/custom_back_button.dart';
import '../../../components/primary_button.dart';
import '../../../config/routes/nav_router.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';
import '../../journal/widgets/journal_input_field.dart';

class AddGoal extends StatefulWidget {
  const AddGoal({super.key});

  @override
  State<AddGoal> createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<String> goalType = ['Short term', 'Long term'];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddGoalCubit(sl()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Add Goal',
          leading: CustomBackButton(
            onPressed: () {
              NavRouter.pop(context);
            },
          ),
        ),
        body: BlocConsumer<AddGoalCubit, AddGoalState>(
          listener: (context, state) {
            if (state.addGoalStatus == AddGoalStatus.loading) {
              DisplayUtils.showLoader();
            }
            if (state.addGoalStatus == AddGoalStatus.success) {
              DisplayUtils.removeLoader();
              NavRouter.pop(context);
              DisplayUtils.showToast(context, 'Goal added Successfully');
            } else if (state.addGoalStatus == AddGoalStatus.failure) {
              DisplayUtils.removeLoader();
              DisplayUtils.showSnackBar(context, state.failure.message);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomDropDown(
                      hint: 'Goal type',
                      items: goalType,
                      onSelect: (String value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    JournalInputField(
                        controller: descriptionController,
                        hintText: 'Write Your Goal',
                        maxLines: 4,
                        minLines: 4,
                        onChanged: (value) {  },
                        onValidate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is required';
                          } else {
                            return null;
                          }
                        }),
                    Spacer(),
                    PrimaryButton(
                      title: 'Save',
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if(selectedValue == null){
                          DisplayUtils.showToast(context, 'Please select Goal Type');
                        }else{
                          if(_formKey.currentState!.validate()){
                            AddGoalInput input = AddGoalInput(
                              description: descriptionController.text,
                              goalType: selectedValue == goalType[0] ? 0: 1,
                            );
                            context.read<AddGoalCubit>().addNewGoal(input);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
