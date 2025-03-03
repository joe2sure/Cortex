import 'package:nb_utils/nb_utils.dart';
import 'package:rive/rive.dart';

class RiveUtils {
  static SMIBool getRiveInput(Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller = StateMachineController.fromArtboard(artboard, stateMachineName);

    artboard.addController(controller!);

    return controller.findInput<bool>("active") as SMIBool;
  }

  static void chnageSMIBoolStatefor1Sec(SMIBool input) {
    input.change(true);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        input.change(false);
      },
    );
  }

  static SMIBool getRiveInputbyKey(String statekey, Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller = StateMachineController.fromArtboard(artboard, stateMachineName);

    artboard.addController(controller!);

    return controller.findInput<bool>(statekey) as SMIBool;
  }

  static void toggleSMIBoolState(SMIBool input) {
    input.change(true);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        input.change(false);
      },
    );
  }

  static T? getRiveFindSMIbyKey<T>(String statekey, Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller = StateMachineController.fromArtboard(artboard, stateMachineName);
    artboard.addController(controller!);
    for (var input in controller.inputs) {
      log('sm $stateMachineName input name: ${input.name} SMI Type: ${input.type}');
    }
    return controller.findSMI(statekey);
  }
}
