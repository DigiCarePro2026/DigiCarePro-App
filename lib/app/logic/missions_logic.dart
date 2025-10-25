import 'package:digi_care_pro/app/data/enum/page_status.dart';
import 'package:digi_care_pro/app/data/models/mission.dart';
import 'package:digi_care_pro/app/data/repositories/mission_repository.dart';
import 'package:get/get.dart';

class MissionsLogic extends GetxController {

  PageStatus pageStatus = PageStatus.loading;
  DateTime _selectedDateTime = DateTime.now();
  List<Mission> missions = [];

  @override
  Future<void> onInit() async {
    super.onInit();

    Future.delayed(Duration(seconds: 200),(){
      getMissions();
    });

  }

  getMissions() async {
    // pageStatus = PageStatus.loading;
    // update();

    var result = await MissionRepository.get().getMissions(
      year: _selectedDateTime.year,
      month: _selectedDateTime.month,
    );

    result.fold((error) {}, (response) {
      missions = response.data!;

      pageStatus = PageStatus.loaded;
      update();
    });
  }

  changeDate(DateTime dateTime){
    _selectedDateTime = dateTime;

    getMissions();
  }
}
