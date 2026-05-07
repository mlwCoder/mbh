import 'package:mbh/app/app.dart';
import 'package:mbh/app/bootstrap/app_runner.dart';
import 'package:mbh/app/config/flavor/app_flavor.dart';

Future<void> main() async {
  await AppRunner.run(
    flavor: AppFlavor.test,
    app: const App(),
  );
}
