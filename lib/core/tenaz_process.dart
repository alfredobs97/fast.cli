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

class TenazProcess {
  Future<bool> executeProcess(
      String name, List<String> args, String path) async {
    var process = await Process.start(name, args,
        runInShell: true, workingDirectory: path);
    var result = await process.exitCode;
    if (result == 0) return true;
    return false;
  }

  Future<bool> executeProcessShellPath(
      String name, List<String> args, String path) async {
    var process = await Process.start(name, args, runInShell: true);
    var result = await process.exitCode;
    if (result == 0) return true;
    return false;
  }
}

class TenazProcessCli implements TenazProcess {
  @override
  Future<bool> executeProcess(
      String name, List<String> args, String path) async {
    var process = await Process.start(name, args,
        runInShell: true, workingDirectory: path);
    await stdout.addStream(process.stdout);
    await stderr.addStream(process.stderr);

    var result = await process.exitCode;
    if (result == 0) return true;
    return false;
  }

  @override
  Future<bool> executeProcessShellPath(
      String name, List<String> args, String path) async {
    var process = await Process.start(name, args, runInShell: true);
    await stdout.addStream(process.stdout);
    await stderr.addStream(process.stderr);

    var result = await process.exitCode;
    if (result == 0) return true;
    return false;
  }
}