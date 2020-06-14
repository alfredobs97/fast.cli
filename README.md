# Tenaz CLI
 
An incredible command line interface for Flutter.

With this CLI, you can create your custom templates and define how your project will start.

The schemes are from the outside in, that is, the users create and define the templates, the CLI only creates them.

That way you are not forced to use the project structure set by someone else.

## Exemplo

### Template exemplo:

```dart
import 'package:flutter/material.dart';

class @NamePage extends StatefulWidget {
  @override
  _@NamePageState createState() => _@NamePageState();
}

class _@NamePageState extends State<@NamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("Hello"),
      ),
    );
  }
}
```
```yaml
#Yaml file for configuring the template.
#The template name
name: page
#The template description
description: Create_flutter_page.
#Path where files should be sent
to: lib/ui/pages/@name
#Arguments to be passed when executing this template
# You can define as many arguments as you want.
args:
  - name
# - other1
# - other2
# - other3
```

### Running the tempate

Run this command so that your template is generated.

run on cmd:
tenaz page --name home

### Result 

You will now have the following file in the path `lib/ui/pages/home`

```dart
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("Hello"),
      ),
    );
  }
}
```

# Setup

## Install

Install this package globally. To do this, you must have the Dart SDK [installed and configured](https://dart.dev/get-dart) 

run on cmd: 
pub global activate tenaz

## Config

Configure the path of the templates that will be used by the CLI.

run on cmd: 
tena config templates <tempates_path>
tena config projects <projects_path>

Exemplo: 

tena config templates /home/pedro/Documentos/templates/
tena config projects /home/pedro/Documentos/projects/

# License

[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).