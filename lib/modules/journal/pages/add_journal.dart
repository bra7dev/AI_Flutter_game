import 'dart:convert';

import 'package:coaching_app/components/custom_appbar.dart';
import 'package:coaching_app/components/primary_button.dart';
import 'package:coaching_app/constants/app_colors.dart';
import 'package:coaching_app/modules/journal/cubit/create_journal/create_journal_cubit.dart';
import 'package:coaching_app/modules/journal/cubit/get_time_slots/get_time_slots_cubit.dart';
import 'package:coaching_app/modules/journal/model/get_journal_model.dart';
import 'package:coaching_app/modules/notes/add_notes_page.dart';
import 'package:coaching_app/modules/notes/cubit/add_notes/add_notes_cubit.dart';
import 'package:coaching_app/utils/extensions/extended_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../components/custom_back_button.dart';
import '../../../components/empty_widget.dart';
import '../../../config/routes/nav_router.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/display_utils.dart';
import '../../../utils/validators/validation_utils.dart';
import '../../notes/cubit/get_notes/get_notes_cubit.dart';
import '../model/time_slot_model.dart';
import '../widgets/journal_input_field.dart';
import '../widgets/journal_slot_selection.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class AddJournalScreen extends StatefulWidget {
  final String dayName;
  final String date;
  final CreateJournalInput? storedJournal;
  final List<TimeSlotModel> timeSlots;
  final AddNotesInput storedNotes;

  const AddJournalScreen(
      {super.key,
      required this.dayName,
      required this.date,
      required this.timeSlots,
      required this.storedNotes,
      this.storedJournal});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  TextEditingController endOfDayController = TextEditingController();
  TextEditingController thingsImproveController = TextEditingController();
  TextEditingController positiveAffirmationController = TextEditingController();
  TextEditingController morningAffirmationController = TextEditingController();
  TextEditingController tomorrowGoalsController = TextEditingController();
  TextEditingController dailyGoalsController = TextEditingController();

  List<HourlyPlanner> hourlyPlans = [];
  final _formKey = GlobalKey<FormState>();

  bool hasNotes = false;
  var myJSON = jsonDecode(r'{"insert":"hello\n"}');

  @override
  void initState() {
    super.initState();

    if (widget.storedJournal != null) {
      endOfDayController.text = widget.storedJournal!.endOfDayReview;
      thingsImproveController.text = widget.storedJournal!.improveThings;
      positiveAffirmationController.text =
          widget.storedJournal!.positiveAffirmation;
      morningAffirmationController.text =
          widget.storedJournal!.morningAffirmation;
      tomorrowGoalsController.text = widget.storedJournal!.tomorrowGoal;
      dailyGoalsController.text = widget.storedJournal!.dailyGoal;
      hourlyPlans = widget.storedJournal!.hourlyPlanner;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateJournalCubit(sl()),
      child: Scaffold(
        appBar: CustomAppBar(
          title:
              "${widget.dayName} ${DateFormat('d/M/yy').format(DateTime.parse(widget.date))}",
          leading: CustomBackButton(
            onPressed: () {
              NavRouter.pop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: () async {
                AddNotesInput? storedNotes = await context
                    .read<GetTimeSlotsCubit>()
                    .getLocalStoredNotes(widget.date);
                NavRouter.push(
                    context,
                    AddNotesPage(
                      date: widget.date,
                      dayName: widget.dayName,
                      hasNotes: hasNotes,
                      storedNotes:
                          storedNotes ?? AddNotesInput(date: '', notes: ''),
                      json: myJSON,
                    )).then((value) {
                  if (value) {
                    setState(() {
                      context.read<GetNotesCubit>().fetchNotes(widget.date);
                    });
                  }
                });
              },
              icon: Icon(
                Icons.note_alt,
              ),
              tooltip: 'Note',
              iconSize: 30,
            ),
          ],
        ),
        body: BlocConsumer<CreateJournalCubit, CreateJournalState>(
          listener: (context, state) {
            if (state.createJournalStatus == CreateJournalStatus.loading) {
              DisplayUtils.showLoader();
            }
            if (state.createJournalStatus == CreateJournalStatus.success) {
              context
                  .read<GetTimeSlotsCubit>()
                  .removeJournalFromLocalDB(widget.date);
              DisplayUtils.removeLoader();
              NavRouter.pop(context, true);
              DisplayUtils.showToast(context, 'Journal created Successfully');
            } else if (state.createJournalStatus ==
                CreateJournalStatus.failure) {
              DisplayUtils.removeLoader();
              DisplayUtils.showSnackBar(context, state.failure.message);
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  children: [
                    BlocBuilder<GetNotesCubit, GetNotesState>(
                      builder: (context, notesState) {
                        if (notesState.getNotesStatus ==
                            GetNotesStatus.success) {
                          hasNotes = true;
                          myJSON = jsonDecode(notesState
                              .notes[notesState.notes.length - 1].note);
                          return Column(
                            children: [
                              IgnorePointer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.secondary,
                                  ),
                                  child: quill.QuillEditor.basic(
                                    controller: quill.QuillController(
                                      document: quill.Document.fromJson(
                                        jsonDecode(notesState
                                            .notes[notesState.notes.length - 1]
                                            .note),
                                      ),
                                      selection:
                                          TextSelection.collapsed(offset: 0),
                                    ),
                                    padding: EdgeInsets.all(20),
                                    autoFocus: false,
                                    readOnly: true,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          );
                        }
                        return EmptyWidget();
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    JournalInputField(
                      hintText: 'End-of-Day Review',
                      controller: endOfDayController,
                      onChanged: (value) async {
                        if (widget.storedJournal != null) {
                          widget.storedJournal!.endOfDayReview = value ?? "";
                          context.read<GetTimeSlotsCubit>().addJournalToLocalDB(
                              widget.date, widget.storedJournal!);
                        }
                      },
                      onValidate: (val) =>
                          ValidationUtils.validateEmptyField(val),
                    ),
                    JournalInputField(
                      hintText: 'Things I Can Improve Upon',
                      controller: thingsImproveController,
                      onChanged: (value) {
                        if (widget.storedJournal != null) {
                          widget.storedJournal!.improveThings = value ?? "";
                          context.read<GetTimeSlotsCubit>().addJournalToLocalDB(
                              widget.date, widget.storedJournal!);

                        }
                      },
                      onValidate: (val) =>
                          ValidationUtils.validateEmptyField(val),
                    ),
                    JournalInputField(
                      hintText: 'Positive Affirmations',
                      controller: positiveAffirmationController,
                      onChanged: (value) {
                        if (widget.storedJournal != null) {
                          widget.storedJournal!.positiveAffirmation =
                              value ?? "";
                          context.read<GetTimeSlotsCubit>().addJournalToLocalDB(
                              widget.date, widget.storedJournal!);

                        }
                      },
                      onValidate: (val) =>
                          ValidationUtils.validateEmptyField(val),
                    ),
                    JournalInputField(
                      hintText: 'Tomorrow\'s Goal',
                      controller: tomorrowGoalsController,
                      onChanged: (value) {
                        if (widget.storedJournal != null) {
                          widget.storedJournal!.tomorrowGoal = value ?? "";
                          context.read<GetTimeSlotsCubit>().addJournalToLocalDB(
                              widget.date, widget.storedJournal!);
                        }
                      },
                      onValidate: (val) =>
                          ValidationUtils.validateEmptyField(val),
                    ),
                    JournalSlotSelection(
                      timeSlots: widget.timeSlots,
                      hourlyPlans: hourlyPlans,
                      onUpdated: (returnedPlans) {
                        hourlyPlans = returnedPlans;
                        if (widget.storedJournal != null) {
                          widget.storedJournal!.hourlyPlanner = returnedPlans;
                          context.read<GetTimeSlotsCubit>().addJournalToLocalDB(
                              widget.date, widget.storedJournal!);
                        }
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Complete The Next Morning',
                      style: context.textTheme.titleMedium!
                          .copyWith(color: AppColors.greyText1, fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    JournalInputField(
                      hintText: 'Morning Refinement',
                      controller: morningAffirmationController,
                      onChanged: (value) {
                        if (widget.storedJournal != null) {
                          widget.storedJournal!.morningAffirmation =
                              value ?? "";
                          context.read<GetTimeSlotsCubit>().addJournalToLocalDB(
                              widget.date, widget.storedJournal!);
                        }
                      },
                      onValidate: (val) =>
                          ValidationUtils.validateEmptyField(val),
                    ),
                    JournalInputField(
                      hintText: 'Daily Goal',
                      controller: dailyGoalsController,
                      onChanged: (value) {
                        if (widget.storedJournal != null) {
                          widget.storedJournal!.dailyGoal = value ?? "";
                          context.read<GetTimeSlotsCubit>().addJournalToLocalDB(
                              widget.date, widget.storedJournal!);
                        }
                      },
                      onValidate: (val) =>
                          ValidationUtils.validateEmptyField(val),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    PrimaryButton(
                      isEnabled: true,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          CreateJournalCubit createJournalCubit =
                              context.read<CreateJournalCubit>();
                          FocusManager.instance.primaryFocus?.unfocus();
                          hourlyPlans
                              .removeWhere((element) => element.task.isEmpty);
                          CreateJournalInput input = CreateJournalInput(
                              date: widget.date,
                              endOfDayReview: endOfDayController.text,
                              improveThings: thingsImproveController.text,
                              positiveAffirmation:
                                  positiveAffirmationController.text,
                              tomorrowGoal: tomorrowGoalsController.text,
                              morningAffirmation:
                                  morningAffirmationController.text,
                              dailyGoal: dailyGoalsController.text,
                              hourlyPlanner: hourlyPlans);
                          createJournalCubit.createJournal(input);
                        } else {
                          context.read<CreateJournalCubit>()
                            ..enableAutoValidateMode();
                        }
                      },
                      title: 'Create Journal',
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
