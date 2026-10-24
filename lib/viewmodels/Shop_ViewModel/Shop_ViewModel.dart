
import 'package:ahlachat/main.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/BageScrean/BageScrean.dart';
import 'package:ahlachat/view/Screans/MainScreans/ShopScrean/ShopScrean.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/Repositores/Shop_repositores/Shop_api.dart';
import 'package:ahlachat/models/MyItemModel.dart';
import 'package:ahlachat/models/ShopModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:provider/provider.dart';

class ShopViewmodel extends ChangeNotifier {
  bool showloading = false;
  bool showloading2 = false;
  bool showloading3 = false;
  List<Shop> AllShop=[];
  List<Salesmodel> AllMyItem=[];
  List SelectedPackage=[];
  int ?price;
  int ?day;
  int ?Id;
  int ?categoryid;
  Getid({id,CategoryId}){
    Id=id;
    categoryid=CategoryId;
    notifyListeners();
  }
  selectPackage({value,Priceitem,Dayitem }){
    SelectedPackage.clear();
    SelectedPackage.add(value);
    price=Priceitem;
    day=Dayitem;

    notifyListeners();
  }
  void showSpinner() {
     ;
    showloading = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void HiddenSpinner() {
     ;
    showloading = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void showSpinner2() {

    showloading2 = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void HiddenSpinner2() {

    showloading2 = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void showSpinner3() {
     ;
    showloading3 = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void HiddenSpinner3() {
     ;
    showloading3 = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }

  GetShop({context}) async {
    ShowGlopalLoading();
    await shopapi().getShop(context: context).then((value) {
      AllShop=value;
      navigateTo(context: context, screen: ShopScrean());
      DismissGlopalLoading();
    });
    notifyListeners();
  }

  GetBag({context}) async {
    ShowGlopalLoading();
    await shopapi().GetMyBag( ).then((value) {
      AllMyItem=value;
      navigateTo(context: context, screen: BagScrean());
      DismissGlopalLoading();
    });
    notifyListeners();
  }

  Future<void> getBag2({
  required BuildContext context,
}) async {
  ShowGlopalLoading();

  try {
    final api = shopapi();

    // Step 1: Get all shop categories dynamically.
    final categories = await api.getShop(context: context);

    final int userId = int.parse(UserId.toString());

    // Step 2: Fetch purchased items for every category.
    final List<Salesmodel> bagCategories = [];

    for (final category in categories) {
      final int? categoryId = category.id;

      if (categoryId == null) continue;

      final sales = await api.getMyItemsByCategory(
        userId: userId,
        categoryId: categoryId,
      );

      // Preserve the category-based structure expected by
      // the existing BagScrean.
      bagCategories.add(
        Salesmodel(
          id: category.id,
          name: category.name,
          status: category.status,
          createdAt: category.createdAt,
          updatedAt: category.updatedAt,
          sales: sales,
        ),
      );
    }

    AllMyItem = bagCategories;

    navigateTo(
      context: context,
      screen: BagScrean(),
    );
  } catch (e) {
    print('GetBag error: $e');
  } finally {
    DismissGlopalLoading();
    notifyListeners();
  }
}
  ByeShop({context}) async {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
    ShowGlopalLoading();

    await shopapi().ByeItem(day: day,itemId:Id ,price: price,context: context,categoryid:categoryid ).then((value) {
     if(value==true){



if((user.userinfo?.coins??0)<(price??0)){
  Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

}else{
  user.RemoveCoins(cost: price??0);
  Dialogs().showtoast('تم شراء العنصر بنجاح 🤝');
}

     }else{
       Dialogs().showtoast('You already have this item 🛄');
     }
     DismissGlopalLoading();
    });
    notifyListeners();
  }
  SendByeShop({context,userid}) async {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
    ShowGlopalLoading();

    await shopapi().SendByeShop(day: day,itemId:Id ,price: price,context: context,categoryid:categoryid,userid: userid ).then((value) {
      if(value==true){



        if((user.userinfo?.coins??0)<(price??0)){
          Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

        }else{
          user.RemoveCoins(cost: price??0);
          Dialogs().showtoast('تم شراء العنصر بنجاح 🤝');
        }

      }else{
        Dialogs().showtoast('You already have this item 🛄');
      }
      DismissGlopalLoading();
    });
    notifyListeners();
  }
  UserpdateFrame({context, Frame}) async {
    ShowGlopalLoading();
    await shopapi().
         UpdateFrame(Frame:Frame, context: context)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }
  UserpdateEnterbubles({context, Frame}) async {
    ShowGlopalLoading();
    await shopapi().
    UpdateEnterbubles(Frame:Frame, context: context)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }
  

Future<void> UserpdatepROFILEbubles({
  required BuildContext context,
  required String? Frame,
}) async {
  if (Frame == null || Frame.trim().isEmpty) {
    Dialogs().showtoast(
      getLang(
        context: NavigationService.navigatorKey.currentContext,
        key: 'Sorry',
      ),
    );
    return;
  }

  ShowGlopalLoading();

  try {
    final bool success = await shopapi().Updateprofilebubles(
      Frame: Frame,
      context: context,
    );

    if (!context.mounted) return;

    if (success) {
      final LoginViewmodel user =
          Provider.of<LoginViewmodel>(
        context,
        listen: false,
      );

      // The repository returns bool, not String.
      // Use the selected bubble filename to update local state.
      user.UpdateProfilebubles(frames: Frame);

      Dialogs().showtoast(
        getLang(
          context: NavigationService.navigatorKey.currentContext,
          key: 'Done_Succ',
        ),
      );
    } else {
      Dialogs().showtoast(
        getLang(
          context: NavigationService.navigatorKey.currentContext,
          key: 'Sorry',
        ),
      );
    }
  } catch (e, stackTrace) {
    debugPrint('Update profile bubble failed: $e');
    debugPrintStack(stackTrace: stackTrace);

    Dialogs().showtoast(
      getLang(
        context: NavigationService.navigatorKey.currentContext,
        key: 'Sorry',
      ),
    );
  } finally {
    DismissGlopalLoading();
    notifyListeners();
  }
}

Future<void> RemoveProfilebubles({
  required BuildContext context,
}) async {
  ShowGlopalLoading();

  try {
    final bool success = await shopapi().RemoveProfilebubles(
      context: context,
    );

    if (!context.mounted) return;

    if (success) {
      final LoginViewmodel user =
          Provider.of<LoginViewmodel>(
        context,
        listen: false,
      );

      // Clear the local bubble only after successful removal.
      user.removeProfilebubles();

      Dialogs().showtoast(
        getLang(
          context: NavigationService.navigatorKey.currentContext,
          key: 'Done_Succ',
        ),
      );
    } else {
      Dialogs().showtoast(
        getLang(
          context: NavigationService.navigatorKey.currentContext,
          key: 'Sorry',
        ),
      );
    }
  } catch (e, stackTrace) {
    debugPrint('Remove profile bubble failed: $e');
    debugPrintStack(stackTrace: stackTrace);

    Dialogs().showtoast(
      getLang(
        context: NavigationService.navigatorKey.currentContext,
        key: 'Sorry',
      ),
    );
  } finally {
    DismissGlopalLoading();
    notifyListeners();
  }
}


  RemoveFrame({context}) async {
    ShowGlopalLoading();
    await shopapi().
    RemoveFrame(  context: context)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }


  RemoveEntry({context}) async {
    ShowGlopalLoading();
    await shopapi().
    RemoveEntry(  context: context)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }
  RemoveEnterbubles({context}) async {
    ShowGlopalLoading();
    await shopapi().
    RemoveEnterbubles(  context: context)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }
  
  UserpdateEntry({context, Entry}) async {
    ShowGlopalLoading();
    await shopapi().UpdateEntry(Entry:Entry, context: context)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }

}