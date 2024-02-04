import 'dart:convert';

import 'package:coaching_app/components/custom_appbar.dart';
import 'package:coaching_app/modules/journal/cubit/get_time_slots/get_time_slots_cubit.dart';
import 'package:coaching_app/modules/notes/cubit/add_notes/add_notes_cubit.dart';
import 'package:coaching_app/utils/display/display_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';

import '../../components/custom_back_button.dart';
import '../../components/primary_button.dart';
import '../../config/routes/nav_router.dart';
import '../../constants/app_colors.dart';
import '../../core/di/service_locator.dart';

class AddNotesPage extends StatefulWidget {
  AddNotesPage(
      {super.key,
      required this.date,
      required this.dayName,
      required this.hasNotes,
      required this.json,
      required this.storedNotes});

  final String date;
  final String dayName;
  final bool hasNotes;
  var json;
  AddNotesInput storedNotes;

  @override
  State<AddNotesPage> createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> {
  QuillController _controller = QuillController.basic();
  final _formKey = GlobalKey<EditorState>();

  @override
  void initState() {
    if (widget.hasNotes) {
      _controller = QuillController(
        document: Document.fromJson(widget.json),
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    if (widget.storedNotes.notes.isNotEmpty && !widget.hasNotes) {
      _controller = QuillController(
        document: Document.fromJson(jsonDecode(widget.storedNotes.notes)),
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    _controller.addListener(() {
      checkNotes();
    });

    super.initState();
  }

  checkNotes() async {
    GetTimeSlotsCubit getTimeSlotsCubit = context.read<GetTimeSlotsCubit>();

    if (!widget.hasNotes) {
      AddNotesInput? notesInput =
          await getTimeSlotsCubit.getLocalStoredNotes(widget.date);
      if (notesInput != null) {
        notesInput.notes = jsonEncode(_controller.document.toDelta().toJson());
        await getTimeSlotsCubit.addNotesToLocalDB(widget.date, notesInput);
        print(notesInput.toJson());
        print(widget.date);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddNotesCubit(sl()),
      child: Scaffold(
        appBar: CustomAppBar(
          title:
              "${widget.dayName} ${DateFormat('d/M/yy').format(DateTime.parse(widget.date))}",
          leading: CustomBackButton(
            onPressed: () {
              NavRouter.pop(context, false);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    QuillToolbar.basic(
                      controller: _controller,
                      showAlignmentButtons: true,
                      showSuperscript: false,
                      showSubscript: false,
                      showIndent: false,
                      showLink: false,
                      showCodeBlock: false,
                      showListCheck: false,
                      showBackgroundColorButton: false,
                      iconTheme: QuillIconTheme(
                        iconSelectedColor: Colors.amber,
                        iconUnselectedColor: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Expanded(
                      child: Container(
                        height: 500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.greyText,
                        ),
                        child: QuillEditor.basic(
                          controller: _controller,
                          padding: EdgeInsets.all(20),
                          readOnly: false,
                          autoFocus: false,
                          editorKey: _formKey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              BlocConsumer<AddNotesCubit, AddNotesState>(
                listener: (context, state) async {
                  if (state.addNotesStatus == AddNotesStatus.loading) {
                    DisplayUtils.showLoader();
                  }
                  if (state.addNotesStatus == AddNotesStatus.success) {
                    await context
                        .read<GetTimeSlotsCubit>()
                        .removeNoteFromLocalDB(widget.date);
                    DisplayUtils.removeLoader();
                    NavRouter.pop(context, true);
                    DisplayUtils.showToast(context, 'Notes saved Successfully');
                  } else if (state.addNotesStatus == AddNotesStatus.failure) {
                    DisplayUtils.removeLoader();
                    DisplayUtils.showSnackBar(context, state.failure.message);
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    title: widget.hasNotes ? 'Update' : 'Save',
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (_controller.document.length < 2) {
                        print(_controller.document.length);
                        DisplayUtils.showToast(context, 'Please Add Note');
                      } else {
                        if (json.encode(
                                _controller.document.toDelta().toJson()) ==
                            json.encode(widget.json)) {
                          NavRouter.pop(context, false);
                        } else {
                          AddNotesInput input = AddNotesInput(
                            date: widget.date,
                            notes: jsonEncode(
                                _controller.document.toDelta().toJson()),
                          );
                          context.read<AddNotesCubit>().addNewNotes(input);
                        }
                      }
                    },
                  );
                },
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
