import 'package:ahlachat/models/GiveGifts.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

import '../../models/Usermodel.dart';
import '../../util/app_constants.dart';
import '../Gifts_Viewmodel/Gifts_Viewmodel.dart';

List svgas = [];

class SvgViewmodel extends ChangeNotifier {
  // ============================================================
  // ENTRY ANIMATION
  // ============================================================

  SVGAAnimationController? animationController;
  bool isLoading = false;

  // Prevents older asynchronous requests from replacing newer animations.
  int _entryAnimationGeneration = 0;

  Future<void> getcontroller({
    required String svga,
    dynamic enterImage,
    dynamic entername,
  }) async {
    final String animationUrl = svga.trim();

    if (animationUrl.isEmpty) {
      debugPrint('[ENTRY_ANIMATION] Skipped: empty animation URL');
      return;
    }

    final int generation = ++_entryAnimationGeneration;

    EnterImage = enterImage;
    Entername = entername;
    isLoading = false;
    notifyListeners();

    // Clean up the previous entry animation before replacing it.
    final previousController = animationController;
    animationController = null;

    if (previousController != null) {
      previousController.stop();
      previousController.clear();
      previousController.dispose();
    }

    final controller = SVGAAnimationController(vsync: thiss);
    animationController = controller;

    controller.addListener(() {
      if (generation != _entryAnimationGeneration ||
          !identical(animationController, controller)) {
        return;
      }

      if (controller.isCompleted) {
        controller.stop();
        isLoading = true;
        notifyListeners();
      }
    });

    try {
      debugPrint('[ENTRY_ANIMATION] Loading: $animationUrl');

      final videoItem = await loadVideoItem(animationUrl);

      // Ignore results from outdated requests or disposed controllers.
      if (generation != _entryAnimationGeneration ||
          !identical(animationController, controller)) {
        controller.dispose();
        return;
      }

      controller.clear();
      controller.videoItem = videoItem;

      await controller.forward();

      if (generation == _entryAnimationGeneration &&
          identical(animationController, controller)) {
        notifyListeners();
      }
    } catch (error, stackTrace) {
      debugPrint(
        '[ENTRY_ANIMATION] Failed to load/play $animationUrl: $error',
      );

      if (kDebugMode) {
        debugPrintStack(stackTrace: stackTrace);
      }

      if (generation == _entryAnimationGeneration &&
          identical(animationController, controller)) {
        animationController = null;
        isLoading = true;

        controller.stop();
        controller.clear();
        controller.dispose();

        notifyListeners();
      } else {
        // The failed controller is no longer the active controller.
        controller.dispose();
      }
    }
  }

  void addsvgtolist({required String svgaimage}) {
    svgas.add(svgaimage);
  }

  // ============================================================
  // SHARED SVGA LOADER
  // ============================================================

  Future loadVideoItem(String image) {
    final Future Function(String) decoder;

    if (image.startsWith(RegExp(r'https?://'))) {
      decoder = SVGAParser.shared.decodeFromURL;
    } else {
      decoder = SVGAParser.shared.decodeFromAssets;
    }

    return decoder(image);
  }

  // Retained for existing callers that use loadAnimation directly.
  Future<void> loadAnimation({dynamic image}) async {
    if (image == null || image.toString().trim().isEmpty) {
      debugPrint('[SVGA] Skipped: empty animation source');
      return;
    }

    final controller = animationController;
    if (controller == null) return;

    try {
      debugPrint('[SVGA] Loading animation: $image');

      final videoItem = await loadVideoItem(image.toString());

      // Do not apply the result if the controller changed while loading.
      if (!identical(animationController, controller)) return;

      controller.clear();
      controller.videoItem = videoItem;

      await playAnimation();
    } catch (error, stackTrace) {
      debugPrint('[SVGA] Failed to load animation $image: $error');

      if (kDebugMode) {
        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }

  Future<void> playAnimation() async {
    debugPrint('playAnimation');

    isLoading = false;
    notifyListeners();

    await animationController?.forward();

    notifyListeners();
  }

  // ============================================================
  // GIFT ANIMATION 2
  // ============================================================

  SVGAAnimationController? animationController2;
  bool isLoading2 = false;

  List<dynamic> Image = [];

  Future<void> getcontroller2({
    String? svga,
    dynamic context,
    givegifts? Give,
    usermodel? userinfo,
  }) async {
    if (svga != null) {
      Image.add({
        'SVGA': svga,
        'GIVE': Give,
      });
    }

    if (Image.isEmpty) return;

    if (animationController2 == null ||
        animationController2?.value == 0.0) {
      animationController2 = SVGAAnimationController(vsync: thiss)
        ..addListener(() {
          final controller = animationController2;

          if (controller?.isCompleted == true) {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).startmotion(
              ListUser: Give?.ListUser ?? [],
              image: Give?.image,
              name: Give?.name,
              quantity: Give?.quantity,
            );

            // Stop and dispose before removing the controller reference.
            controller?.stop();
            controller?.clear();
            controller?.dispose();
            animationController2 = null;

            if (Image.isNotEmpty) {
              Image.removeAt(0);
            }

            if (Image.isNotEmpty) {
              getcontroller2(
                context: context,
                Give: Image.first['GIVE'],
                userinfo: userinfo,
              );
            }

            isLoading2 = true;
            notifyListeners();
          }
        });

      final giftsViewModel = Provider.of<GiftsViewModel>(
        context,
        listen: false,
      );

      if (giftsViewModel.selected2 == true) {
        giftsViewModel.hidpanner2();

        Future.delayed(const Duration(seconds: 1), () {
          giftsViewModel.sidepanner2(
            user: userinfo,
            Give: Give,
          );
        });
      } else {
        giftsViewModel.sidepanner2(
          user: userinfo,
          Give: Give,
        );
      }

      await loadAnimation2(
        image: Image[0]['SVGA'],
        context: context,
        Give: Image[0]['GIVE'],
      );

      notifyListeners();
    }
  }

  Future loadVideoItem2(String image) {
    final Future Function(String) decoder;

    if (image.startsWith(RegExp(r'https?://'))) {
      decoder = SVGAParser.shared.decodeFromURL;
    } else {
      decoder = SVGAParser.shared.decodeFromAssets;
    }

    return decoder(image);
  }

  Future<void> loadAnimation2({
    dynamic image,
    dynamic context,
    dynamic Give,
  }) async {
    debugPrint('9');
    debugPrint(image.toString());

    try {
      final videoItem = await loadVideoItem2(image.toString());

      if (Give?.Sound != null) {
        Helper().PlaylinkMusic(path: Give?.Sound);
      }

      final controller = animationController2;
      if (controller == null) return;

      controller.clear();
      debugPrint('loadAnimation 1010101010101010101');

      controller.videoItem = videoItem;

      await playAnimation2(
        context: context,
        Give: Give,
      );

      notifyListeners();
    } catch (error, stackTrace) {
      debugPrint('[SVGA_GIFT_2] Failed to load animation: $error');

      if (kDebugMode) {
        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }

  Future<void> playAnimation2({
    dynamic context,
    givegifts? Give,
  }) async {
    isLoading2 = false;

    await animationController2?.forward();

    notifyListeners();
  }

  // ============================================================
  // LOOPING SVGA ANIMATION 3
  // ============================================================

  SVGAAnimationController? animationController3;

  Future<void> getcontroller3({String? Svga}) async {
    if (Svga == null || Svga.trim().isEmpty) return;

    animationController3 = SVGAAnimationController(vsync: thiss)
      ..addListener(() {
        if (animationController3?.isCompleted == true) {
          animationController3?.repeat();
        }
      });

    await loadAnimation3(image: Svga);

    notifyListeners();
  }

  Future loadVideoItem3(String image) {
    final Future Function(String) decoder;

    if (image.startsWith(RegExp(r'https?://'))) {
      decoder = SVGAParser.shared.decodeFromURL;
    } else {
      decoder = SVGAParser.shared.decodeFromAssets;
    }

    return decoder(image);
  }

  Future<void> loadAnimation3({dynamic image}) async {
    if (image == null || image.toString().trim().isEmpty) return;

    try {
      final videoItem = await loadVideoItem3(image.toString());
      final controller = animationController3;

      if (controller == null) return;

      controller.clear();
      controller.videoItem = videoItem;

      await playAnimation3();

      notifyListeners();
    } catch (error, stackTrace) {
      debugPrint('[SVGA_3] Failed to load animation: $error');

      if (kDebugMode) {
        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }

  Future<void> playAnimation3() async {
    await animationController3?.forward();
    notifyListeners();
  }

  // ============================================================
  // SVGA ANIMATION 4
  // ============================================================

  SVGAAnimationController? animationController4;
  bool loading5 = false;

  Future<void> getcontroller4({String? Svga}) async {
    if (Svga == null || Svga.trim().isEmpty) return;

    loading5 = true;

    animationController4 = SVGAAnimationController(vsync: thiss)
      ..addListener(() {
        if (animationController4?.isCompleted == true) {
          loading5 = false;
          animationController4?.stop();
          notifyListeners();
        }
      });

    await loadAnimation4(image: Svga);

    notifyListeners();
  }

  Future loadVideoItem4(String image) {
    final Future Function(String) decoder;

    if (image.startsWith(RegExp(r'https?://'))) {
      decoder = SVGAParser.shared.decodeFromURL;
    } else {
      decoder = SVGAParser.shared.decodeFromAssets;
    }

    return decoder(image);
  }

  Future<void> loadAnimation4({dynamic image}) async {
    if (image == null || image.toString().trim().isEmpty) return;

    debugPrint('image');
    debugPrint(image.toString());

    try {
      final videoItem = await loadVideoItem4(image.toString());
      final controller = animationController4;

      if (controller == null) return;

      controller.clear();

      debugPrint(
        'animationController4 1010101010101010101 animationController4',
      );

      controller.videoItem = videoItem;

      await playAnimation4();

      notifyListeners();
    } catch (error, stackTrace) {
      debugPrint('[SVGA_4] Failed to load animation: $error');

      if (kDebugMode) {
        debugPrintStack(stackTrace: stackTrace);
      }

      loading5 = false;
      notifyListeners();
    }
  }

  Future<void> playAnimation4() async {
    debugPrint('playAnimation animationController4 animationController4');

    await animationController4?.forward();

    notifyListeners();
  }

  // ============================================================
  // EMOJI SVGA ANIMATION 5
  // ============================================================

  SVGAAnimationController? animationController5;
  bool isLoading5 = false;

  List<dynamic> Image2 = [];

  Future<void> getcontroller5({
    String? svgas,
    dynamic userid,
  }) async {
    if (svgas != null) {
      Image2.add({
        'SVGA': svgas,
        'userid': userid,
      });

      debugPrint('svgassvgassvgassvgassvgassvgassvgassvgassvgas');
      debugPrint(Image2.toString());
      debugPrint('svgassvgassvgassvgassvgassvgassvgassvgassvgas');
    }

    if (Image2.isEmpty) return;

    if (animationController5 == null ||
        animationController5?.value == 0.0) {
      animationController5 = SVGAAnimationController(vsync: thiss)
        ..addListener(() {
          final controller = animationController5;

          if (controller?.isCompleted == true) {
            controller?.stop();
            controller?.clear();
            controller?.dispose();
            animationController5 = null;

            if (Image2.isNotEmpty) {
              Image2.removeAt(0);
            }

            if (Image2.isNotEmpty) {
              getcontroller5(
                userid: Image2.first['userid'],
              );
            }

            isLoading5 = true;
            notifyListeners();
          }
        });

      await loadAnimation5(
        image: Image2[0]['SVGA'],
        userid: Image2[0]['userid'],
      );

      notifyListeners();
    }
  }

  Future loadVideoItem5(String image) {
    final Future Function(String) decoder;

    if (image.startsWith(RegExp(r'https?://'))) {
      decoder = SVGAParser.shared.decodeFromURL;
    } else {
      decoder = SVGAParser.shared.decodeFromAssets;
    }

    return decoder(image);
  }

  Future<void> loadAnimation5({
    dynamic image,
    dynamic userid,
  }) async {
    if (image == null || image.toString().trim().isEmpty) return;

    try {
      final videoItem = await loadVideoItem5(image.toString());
      final controller = animationController5;

      if (controller == null) return;

      controller.clear();
      controller.videoItem = videoItem;

      await playAnimation5(userid: userid);

      notifyListeners();
    } catch (error, stackTrace) {
      debugPrint('[SVGA_5] Failed to load animation: $error');

      if (kDebugMode) {
        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }

  Future<void> playAnimation5({dynamic userid}) async {
    isLoading5 = false;
    ImojeSUserId = userid;

    await animationController5?.forward();

    notifyListeners();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    // Invalidate any entry animation still loading asynchronously.
    _entryAnimationGeneration++;

    final controllers = <SVGAAnimationController?>[
      animationController,
      animationController2,
      animationController3,
      animationController4,
      animationController5,
    ];

    // Clear references before disposing to prevent further use.
    animationController = null;
    animationController2 = null;
    animationController3 = null;
    animationController4 = null;
    animationController5 = null;

    for (final controller in controllers) {
      if (controller == null) continue;

      controller.stop();
      controller.clear();
      controller.dispose();
    }

    super.dispose();
  }
}
