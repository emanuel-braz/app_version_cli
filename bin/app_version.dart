import 'package:app_version_cli/app_version_cli.dart';
import 'package:args/args.dart';

const kAppIds = 'app-ids';

void main(List<String> arguments) async {
  final parser = ArgParser();
  parser.addOption(kAppIds, mandatory: true);
  final argResults = parser.parse(arguments);
  final appIds = (argResults[kAppIds] as String).split(',');

  await AppVersion(appIds: appIds).getInfo();
}
