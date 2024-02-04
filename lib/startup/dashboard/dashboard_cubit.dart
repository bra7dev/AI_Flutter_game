import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<int> {
  DashboardCubit() : super(1);
  int currentIndex = 1;

  void changeIndex(int index) {
    currentIndex = index;
    emit(currentIndex);
  }

  void resetInitialIndex(int index) {
    currentIndex = index;
    emit(currentIndex);
  }
}
