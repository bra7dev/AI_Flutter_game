import 'package:coaching_app/constants/app_colors.dart';
import 'package:coaching_app/modules/journal/model/get_journal_model.dart';
import 'package:flutter/material.dart';

import '../model/time_slot_model.dart';

class JournalSlotSelection extends StatefulWidget {
  final List<TimeSlotModel> timeSlots;
  final List<HourlyPlanner> hourlyPlans;
  final Function(List<HourlyPlanner>) onUpdated;
  const JournalSlotSelection(
      {super.key,
      required this.timeSlots,
      required this.onUpdated,
      required this.hourlyPlans});

  @override
  State<JournalSlotSelection> createState() => _JournalSlotSelectionState();
}

class _JournalSlotSelectionState extends State<JournalSlotSelection> {
  late TimeSlotModel selectedSlot;

  List<TimeSlotModel> selectedSlots = [];
  List<HourlyPlanner> hourlyPlans = [];

  @override
  void initState() {
    widget.hourlyPlans.forEach((element) {
      selectedSlots.add(TimeSlotModel(
        id: element.slotId,
        slot: element.slot,
      ));
    });
    selectedSlot = widget.timeSlots[0];
    print(widget.timeSlots.length);
    hourlyPlans = widget.hourlyPlans;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('Hourly Planner:'),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Text('Select time slot:'),
            Spacer(),
            Container(
                color: AppColors.darkGrey3,
                child: DropdownButton<String>(
                  value: selectedSlot.slot,
                  onChanged: (newValue) {
                    try {
                      selectedSlots
                          .firstWhere((element) => element.slot == newValue);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Already selected')));
                    } catch (_) {
                      TimeSlotModel currentSlot = widget.timeSlots
                          .firstWhere((element) => element.slot == newValue);
                      selectedSlot = currentSlot;

                      setState(() {
                        selectedSlots.add(currentSlot);

                        hourlyPlans.add(HourlyPlanner(
                            slotId: currentSlot.id,
                            slot: currentSlot.slot,
                            task: '',
                            isComplete: 0));
                      });
                    }
                    // print(newValue);
                    // TimeSlotModel currentSlot = widget.timeSlots
                    //     .firstWhere((element) => element.slot == newValue);
                    // selectedSlot = currentSlot;
                    // TimeSlotModel newSlot = selectedSlots
                    //     .firstWhere((element) => element.slot == newValue);
                    // print(newSlot.toJson());
                    // print(currentSlot.toJson());
                    // print(selectedSlots.contains(currentSlot));
                    // if (selectedSlots.contains(currentSlot)) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(content: Text('Already selected')));
                    // } else {
                    //   setState(() {
                    //     selectedSlots.add(currentSlot);
                    //
                    //     hourlyPlans.add(HourlyPlanner(
                    //         slotId: currentSlot.id,
                    //         slot: currentSlot.slot,
                    //         task: '',
                    //         isComplete: 0));
                    //   });
                    // }
                  },
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  isDense: true,
                  isExpanded: false,
                  icon: Icon(Icons.keyboard_arrow_down),
                  underline: Container(),
                  items: widget.timeSlots.map((TimeSlotModel value) {
                    return DropdownMenuItem<String>(
                      value: value.slot,
                      child: Text(value.slot),
                    );
                  }).toList(),
                )),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        if (selectedSlots.isNotEmpty) ...[
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
            ],
          ),
          SizedBox(
            height: 2,
          ),
          ListView.builder(
              itemCount: selectedSlots.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Dismissible(
                      key: Key(selectedSlots[index].slot),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirm Deletion'),
                              content: Text(
                                  'Are you sure you want to delete this item?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Close the dialog and return true to confirm deletion
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Close the dialog and return false to cancel deletion
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('No'),
                                ),
                              ],
                            ),
                          );
                        }
                        return false; // Return false to prevent deletion for other directions
                      },
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          // Delete the item from the list
                          setState(() {
                            if (hourlyPlans.asMap().containsKey(index)) {
                              hourlyPlans.removeAt(index);
                              widget.onUpdated(hourlyPlans);
                            }
                            selectedSlots.removeAt(index);
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              color: AppColors.grey,
                              child: Text(
                                selectedSlots[index].slot,
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
                              initialValue:
                                  hourlyPlans.asMap().containsKey(index)
                                      ? hourlyPlans[index].task
                                      : null,
                              onChanged: (value) {
                                hourlyPlans[index].task = value;
                                widget.onUpdated(hourlyPlans);
                              },
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: 'Write task',
                                hintStyle: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                                fillColor: AppColors.grey,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  borderSide:
                                      BorderSide.none, // Remove the border
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0.0),

                                  borderSide:
                                      BorderSide.none, // Remove the border
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0.0),

                                  borderSide:
                                      BorderSide.none, // Remove the border
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  borderSide:
                                      BorderSide.none, // Remove the border
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                  ],
                );
              }),
        ],
      ],
    );
  }
}
