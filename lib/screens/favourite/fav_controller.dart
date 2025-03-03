import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/screens/favourite/models/favourite_res_model.dart';
import 'package:Cortex/screens/favourite/services/favourite_services_api.dart';
import 'package:Cortex/utils/app_common.dart';

class FavController extends GetxController {
  Rx<Future<RxList<FavData>>> getFavouriteListResponseFuture = Future(() => RxList<FavData>()).obs;
  RxList<FavData> favourites = RxList();
  RxBool isLastPage = false.obs;
  RxBool isLoading = false.obs;
  RxInt page = 1.obs;

  @override
  void onInit() {
    favouriteTemplateList();
    super.onInit();
  }

  Future<void> favouriteTemplateList({bool showLoader = false}) async {
    if(isLoggedIn.value)
      {
        if (showLoader) {
          isLoading(true);
        }
        await getFavouriteListResponseFuture(
          FavouriteServices.getFavouritesList(
            templateList: favourites,
            page: page.value,
            lastPageCallBack: (p0) {
              isLastPage(p0);
            },
          ),
        ).then((value) {}).catchError((e) {
          log('favouriteTemplateList E: $e');
        }).whenComplete(() => isLoading(false));
      }
  }
}
