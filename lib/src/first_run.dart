/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:dcli/windows.dart';

import 'constants.dart';
import 'settings.dart';

void firstRun() {
  if (!settingsExist) {
    createSettings();
    firstRunMessage();
  }
}

void checkIsFullyInstalled() {
  if (!isCurrentVersionInstalled) {
    print(red('A new version of dswitch has been activated. '
        'Please run dswitch_install and then try again.'));
    exit(1);
  }

  // final script = DartScript.self;
  // if (!script.isCompiled) {
  //   print(red('Please run dswitch_install and then try again.'));
  //   exit(1);
  // }
}

void firstRunMessage() {
  print('''

${green('Welcome to dswitch.')}

dswitch creates four symlinks (channels) that you can use from your IDE:
active: $activeSymlinkPath
stable: $stableSymlinkPath
beta: $betaSymlinkPath
dev: $devSymlinkPath
''');

  if (!Platform.isWindows) {
    print('''

The active symlink must be added to your path.
''');
  }

  print(blue('''

You can configure your IDE to use a different channel on a per project basis.
  '''));

  if (!exists(pathToSettings)) {
    if (Platform.isWindows) {
      windowsFirstRun();
    } else if (Platform.isLinux) {
      linuxFirstRun();
    } else if (Platform.isMacOS) {
      macosxFirstRun();
    }
  }
}

void macosxFirstRun() {}

void linuxFirstRun() {}

void windowsFirstRun() {
  final pre = Shell.current.checkInstallPreconditions();
  if (pre != null) {
    printerr(red(pre));
    exit(1);
  }

  if (!regIsOnUserPath(activeSymlinkPath)) {
    regPrependToPath(activeSymlinkPath);

    print(orange('Your PATH has been updated. Please restart your terminal.'));
  }
}
