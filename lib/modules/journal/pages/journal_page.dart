import 'dart:convert';

import 'package:coaching_app/components/calendar_view.dart';
import 'package:coaching_app/components/components.dart';
import 'package:coaching_app/config/routes/nav_router.dart';
import 'package:coaching_app/constants/app_colors.dart';
import 'package:coaching_app/modules/journal/cubit/get_journal/get_journal_cubit.dart';
import 'package:coaching_app/modules/journal/cubit/get_time_slots/get_time_slots_cubit.dart';
import 'package:coaching_app/modules/journal/widgets/journal_text_widget.dart';
import 'package:coaching_app/modules/notes/cubit/get_notes/get_notes_cubit.dart';
import 'package:coaching_app/utils/display/display_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../components/custom_appbar.dart';
import '../../../core/di/service_locator.dart';
import '../../notes/add_notes_page.dart';
import 'add_journal.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<String> selectionList = [
    '11am - 12pm',
    '2am - 3am',
    '3am - 4am',
    '4am - 5am',
  ];

  TextEditingController controller = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool journalFound = false;
  bool hasNotes = false;
  var myJSON = jsonDecode(r'{"insert":"hello\n"}');

  @override
  void initState() {
    super.initState();
    context.read<GetJournalCubit>()..fetchJournal(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    context.read<GetNotesCubit>().fetchNotes(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetJournalCubit, GetJournalState>(
      listener: (context, jState) {},
      builder: (context, jState) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Journal',
            actions: [
              BlocConsumer<GetTimeSlotsCubit, GetTimeSlotState>(listener: (context, getTimeSlotsState) {
                if (getTimeSlotsState.status == GetTimeSlotsStatus.loading) {
                  DisplayUtils.showLoader();
                }
                if (getTimeSlotsState.status == GetTimeSlotsStatus.success) {
                  setState(() {});

                  DisplayUtils.removeLoader();
                  jState.getJournalStatus == GetJournalStatus.failure
                      ? NavRouter.push(
                          context,
                          AddJournalScreen(
                            dayName: DateFormat('EEEE').format(selectedDate),
                            date: DateFormat('yyyy-MM-dd').format(selectedDate),
                            storedJournal: getTimeSlotsState.storedJournal,
                            storedNotes: getTimeSlotsState.storedNotes,
                            timeSlots: getTimeSlotsState.timeSlots,
                          )).then((value) {
                          if (value != null && value == true) {
                            context
                                .read<GetJournalCubit>()
                                .fetchJournal(DateFormat('yyyy-MM-dd').format(selectedDate));
                          }
                        })
                      : NavRouter.push(
                          context,
                          AddNotesPage(
                            date: DateFormat('yyyy-MM-dd').format(selectedDate),
                            dayName: DateFormat('EEEE').format(selectedDate),
                            hasNotes: hasNotes,
                            json: myJSON,
                            storedNotes: getTimeSlotsState.storedNotes,
                          )).then((value) {
                          if (value != null && value) {
                            setState(() {
                              context.read<GetNotesCubit>().fetchNotes(DateFormat('yyyy-MM-dd').format(selectedDate));
                            });
                          }
                        });
                }
                if (getTimeSlotsState.status == GetTimeSlotsStatus.failure) {
                  DisplayUtils.removeLoader();
                  DisplayUtils.showSnackBar(context, getTimeSlotsState.failure.message);
                }
              }, builder: (context, getTimeSlotsState) {
                return IconButton(
                  onPressed: () {
                    context.read<GetTimeSlotsCubit>().getTimeSlots(DateFormat('yyyy-MM-dd').format(selectedDate));
                  },
                  icon: jState.getJournalStatus == GetJournalStatus.success
                      ? Icon(Icons.note_alt)
                      : jState.getJournalStatus == GetJournalStatus.loading
                          ? EmptyWidget()
                          : SvgPicture.asset('assets/images/svg/ic-note.svg'),
                  tooltip: jState.getJournalStatus == GetJournalStatus.success ? 'Edit notes' : 'Journal',
                );
              }),
            ],
          ),
          body: Column(
            children: [
              HorizontalCalendarView(
                onDaySelected: (selectedDay, focusDay) {
                  print("Selected Day : ${selectedDay}");
                  print("Focus Day : ${focusDay}");
                  final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(selectedDay.toString()));
                  selectedDate = selectedDay!;
                  context.read<GetJournalCubit>()..fetchJournal(formattedDate);
                  context.read<GetNotesCubit>().fetchNotes(formattedDate).then((value) {});
                  setState(() {});
                },
                onTodayTap: () {
                  context.read<GetJournalCubit>()..fetchJournal(DateFormat('yyyy-MM-dd').format(DateTime.now()));
                  context.read<GetNotesCubit>().fetchNotes(DateFormat('yyyy-MM-dd').format(DateTime.now()));
                  setState(() {});
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<GetNotesCubit, GetNotesState>(
                        builder: (context, state) {
                          if (state.getNotesStatus == GetNotesStatus.success) {
                            hasNotes = true;
                            myJSON = jsonDecode(state.notes[state.notes.length - 1].note);
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
                                          jsonDecode(state.notes[state.notes.length - 1].note),
                                        ),
                                        selection: TextSelection.collapsed(offset: 0),
                                      ),
                                      padding: EdgeInsets.all(20),
                                      autoFocus: false,
                                      readOnly: true,
                                      keyboardAppearance: Brightness.light,
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
                      BlocConsumer<GetJournalCubit, GetJournalState>(
                        listener: (context, state) {
                          print(state.updatingStatus.name);
                          if (state.updatingStatus == GetJournalStatus.updateLoading) {
                            DisplayUtils.showLoader();
                          }
                          if (state.updatingStatus == GetJournalStatus.updated) {
                            DisplayUtils.removeLoader();
                          }
                          if (state.updatingStatus == GetJournalStatus.updateFailure) {
                            DisplayUtils.removeLoader();
                            DisplayUtils.showSnackBar(context, 'Not updated, try again');
                          }
                        },
                        builder: (context, state) {
                          if (state.getJournalStatus == GetJournalStatus.loading) {
                            journalFound = true;
                            return SizedBox(
                              height: 400,
                              child: Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            );
                          }
                          if (state.getJournalStatus == GetJournalStatus.success) {
                            return Column(
                              children: [
                                if (state.data != null) ...[
                                  state.data!.journal.endOfDayReview.isNotEmpty
                                      ? JournalTextWidget(
                                          title: 'End of Day Review:',
                                          text: state.data!.journal.endOfDayReview,
                                          //journal: state.data!.journal,
                                          textStyle: TextStyle(color: AppColors.greyText2),
                                          color: AppColors.darkGrey3,
                                        )
                                      : SizedBox.shrink(),
                                  state.data!.journal.dailyGoal.isNotEmpty
                                      ? JournalTextWidget(
                                          title: 'Daily goal:',
                                          text: state.data!.journal.dailyGoal,
                                          //journal: state.data!.journal,
                                          textStyle: TextStyle(color: AppColors.greyText2),
                                          color: AppColors.darkGrey3,
                                        )
                                      : SizedBox.shrink(),
                                  state.data!.journal.improveThings.isNotEmpty
                                      ? JournalTextWidget(
                                          title: 'Things I Can Improve Upon:',
                                          text: state.data!.journal.improveThings,
                                          //journal: state.data!.journal,
                                          textStyle: TextStyle(color: AppColors.greyText2),
                                          color: AppColors.darkGrey3,
                                        )
                                      : SizedBox.shrink(),
                                  state.data!.journal.positiveAffirmation.isNotEmpty
                                      ? JournalTextWidget(
                                          title: 'Positive Affirmations:',
                                          text: state.data!.journal.positiveAffirmation,
                                          //journal: state.data!.journal,
                                          textStyle: TextStyle(color: AppColors.greyText2),
                                          color: AppColors.darkGrey3,
                                        )
                                      : SizedBox.shrink(),
                                  state.data!.journal.morningRefinement.isNotEmpty
                                      ? JournalTextWidget(
                                          title: 'Morning Affirmations:',
                                          text: state.data!.journal.morningRefinement,
                                          //journal: state.data!.journal,
                                          textStyle: TextStyle(color: AppColors.greyText2),
                                          color: AppColors.darkGrey3,
                                        )
                                      : SizedBox.shrink(),
                                  state.data!.journal.tomorrowGoal.isNotEmpty
                                      ? JournalTextWidget(
                                          title: 'Tomorrow\'s Goal:',
                                          text: state.data!.journal.tomorrowGoal,
                                          //journal: state.data!.journal,
                                          textStyle: TextStyle(color: AppColors.greyText2),
                                          color: AppColors.darkGrey3,
                                        )
                                      : SizedBox.shrink(),
                                ],
                                if (state.data != null && state.data!.hourlyPlanner.isNotEmpty) ...[
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 6),
                                          color: AppColors.darkGrey3,
                                          child: Text(
                                            'Time Slot',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 6),
                                          color: AppColors.darkGrey3,
                                          child: Text(
                                            'Task',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 6),
                                          color: AppColors.darkGrey3,
                                          child: Text(
                                            'Mark',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: state.data!.hourlyPlanner.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, timeSlotIndex) {
                                        print(state.data!.hourlyPlanner[timeSlotIndex].task);

                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 6),
                                                    color: AppColors.grey,
                                                    child: Text(
                                                      state.data!.hourlyPlanner[timeSlotIndex].slot,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: AppColors.white,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: TextFormField(
                                                    controller: TextEditingController(
                                                        text: state.data!.hourlyPlanner[timeSlotIndex].task),
                                                    readOnly: true,
                                                    style: TextStyle(
                                                      color: AppColors.white,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    decoration: InputDecoration(
                                                      hintText: 'Write task',
                                                      hintStyle:
                                                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                                      fillColor: AppColors.grey,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(0.0),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(0.0),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(0.0),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      errorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(0.0),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 9),
                                                    child: GestureDetector(
                                                      child: Container(
                                                        child: Transform.scale(
                                                          scale: 1.3,
                                                          child: Checkbox(
                                                            key: Key(
                                                                state.data!.hourlyPlanner[timeSlotIndex].slot),
                                                            value: state.data!.hourlyPlanner[timeSlotIndex]
                                                                    .isComplete ==
                                                                1,
                                                            activeColor: AppColors.secondary.withOpacity(.4),
                                                            onChanged: (value) {
                                                              print(
                                                                  "---- ${state.data!.hourlyPlanner[timeSlotIndex].isComplete}");
                                                              context.read<GetJournalCubit>().updateJournal(
                                                                  state.data!.hourlyPlanner[timeSlotIndex].id!,
                                                                  DateFormat('yyyy-MM-dd')
                                                                      .format(state.data!.journal.date),
                                                                  state.data!.hourlyPlanner[timeSlotIndex]
                                                                              .isComplete ==
                                                                          1
                                                                      ? 0
                                                                      : 1);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                          ],
                                        );
                                      }),
                                ]
                              ],
                            );
                          }
                          if (state.getJournalStatus == GetJournalStatus.failure) {
                            if (state.failure.message == 'Add Journal Entry') {
                              return Center(
                                child: TextButton(
                                    onPressed: () {
                                      context.read<GetTimeSlotsCubit>().getTimeSlots(DateFormat('yyyy-MM-dd').format(selectedDate));
                                    },
                                    child: Text(
                                      state.failure.message,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                              );
                            } else {
                              return Center(
                                child: Text(state.failure.message),
                              );
                            }
                          }
                          return EmptyWidget();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
