import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'country.dart';

import '../../widgets.dart';
import '../wizard_page.dart';

class WhereAreYouPage extends StatefulWidget {
  const WhereAreYouPage({Key? key}) : super(key: key);

  @override
  _WhereAreYouPageState createState() => _WhereAreYouPageState();
}

class _WhereAreYouPageState extends State<WhereAreYouPage> {
  List<Country> _countries = [];

  Future<List<Country>> getCountries() async {
    final response = await rootBundle.loadString('assets/countries.json');
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    _countries = parsed.map<Country>((json) => Country.fromJson(json)).toList();
    return _countries;
  }

  @override
  Widget build(BuildContext context) {
    getCountries();
    return LocalizedView(
        builder: (context, lang) => WizardPage(
              title: Text('Where are you currently?'),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: FutureBuilder<List<Country>>(
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                              children: snapshot.data!
                                  .map((country) => ListTile(
                                        onTap: () => print(country.name),
                                        title: Text(country.city.toString()),
                                      ))
                                  .toList());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                      future: getCountries(),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Autocomplete<String>(
                      optionsBuilder: (textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return _countries
                            .map((e) => e.city.toString())
                            .toList()
                            .where((option) {
                          return option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: print,
                    ),
                  ),
                ],
              ),
              actions: <WizardAction>[
                WizardAction(
                  label: lang.backButtonText,
                  onActivated: Navigator.of(context).pop,
                ),
                WizardAction(
                  label: lang.startInstallingButtonText,
                  highlighted: true,
                  onActivated: () async {},
                ),
              ],
            ));
  }
}

void main() => runApp(const AutocompleteExampleApp());

class AutocompleteExampleApp extends StatelessWidget {
  const AutocompleteExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Autocomplete Basic'),
        ),
        body: const Center(
          child: AutocompleteBasicExample(),
        ),
      ),
    );
  }
}

class AutocompleteBasicExample extends StatelessWidget {
  const AutocompleteBasicExample({Key? key}) : super(key: key);

  static const List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.where((option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (selection) {
        print('You just selected $selection');
      },
    );
  }
}
