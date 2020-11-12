//Copyright 2020 Pedro Bissonho
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

import 'dart:io';

import 'package:fast/actions/add_main.dart';
import 'package:fast/actions/builder_action.dart';
import 'package:flunt_dart/flunt_dart.dart';
import 'package:path/path.dart';
import 'package:fast/yaml_manager.dart';
import '../../logger.dart';
import 'package:fast/actions/clear_structure.dart';
import 'package:fast/actions/create_structure.dart';
import 'package:fast/actions/creater_flutter_action.dart';
import 'package:fast/actions/setup_yaml.dart';
import 'package:fast/actions/show_folder_structure.dart';
import 'package:fast/core/process_extension.dart';
import '../command_base.dart';

class FlutterAppArgs {
  final String name;
  String description;
  String org;
  final bool useKotlin;
  final bool useSwift;
  final bool useAndroidX;

  FlutterAppArgs({
    this.useAndroidX = false,
    this.org = '',
    this.description = '',
    this.name,
    this.useKotlin = false,
    this.useSwift = false,
  }) {
    description ??= '';
    org ??= '';
  }
}

class FlutterCreaterComand extends CommandBase {
  final String scaffoldsPath;

  @override
  String get description => 'Create the app and folder structure';

  @override
  String get name => 'create';

  String get finishedDescription => 'Create the app and folder structure';

  FlutterCreaterComand(this.scaffoldsPath) {
    argParser.addOption('name', abbr: 'n', help: 'Project name.');
    argParser.addOption('scaffold', abbr: 's', help: 'Scaffold template name.');
    argParser.addOption('description', abbr: 'd', help: 'Project descritiopn.');
    argParser.addFlag('kotlin', abbr: 'a', help: 'User kotlin.');
    argParser.addFlag('swift', abbr: 'i', help: 'User Swift.');
    argParser.addFlag('androidx', abbr: 'x', help: 'Use AndroidX.');
  }

  @override
  Future<void> run() async {
    var appName = argResults['name'];
    var scaffoldName = argResults['scaffold'];
    var description = argResults['description'];
    var useKotlin = argResults.wasParsed('kotlin');
    var useSwift = argResults.wasParsed('swift');
    var useAndroidX = argResults.wasParsed('androidx');

    var flutterScaffoldArgs = FlutterAppArgs(
        useAndroidX: useAndroidX,
        name: appName,
        description: description,
        useKotlin: useKotlin,
        useSwift: useSwift);

    var scaffold =
        YamlManager.loadScaffold(normalize('$scaffoldsPath/$scaffoldName'));

    validate(
        Contract<FlutterAppArgs>(flutterScaffoldArgs, 'FlutterScaffoldArgs'));

    await CreaterFlutterAction(appName, flutterScaffoldArgs, FastProcessCLI())
        .execute();

    final cacheMainFile = await File('$appName/lib/main.dart').copy('$appName/tmp/main.dart');

    var actionBuilder = ActionBuilder([
      ClearScaffoldStructure('$appName/lib'),
      ClearScaffoldStructure('$appName/test'),
      CreateFolderStructure('$appName/lib', scaffold.structure.mainFolder,
          'Created /lib folder structure.'),
      ShowFolderStructure(scaffold.structure.mainFolder),
      CreateFolderStructure('$appName/test', scaffold.testStructure.mainFolder,
          'Created /test folder structure.'),
      ShowFolderStructure(scaffold.testStructure.mainFolder),
      SetupYaml('$appName/pubspec.yaml',
          normalize('$scaffoldsPath/$scaffoldName/scaffold.yaml')),
      AddMainFile(main: cacheMainFile, path: '$appName/lib/main.dart'),
    ]);

    await actionBuilder.execute();

    logger.d('All done. Application created and configured.');
  }
}
