import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'city.dart';

import '../../widgets.dart';
import '../wizard_page.dart';

class WhereAreYouPage extends StatefulWidget {
  const WhereAreYouPage({Key? key}) : super(key: key);

  @override
  _WhereAreYouPageState createState() => _WhereAreYouPageState();
}

class _WhereAreYouPageState extends State<WhereAreYouPage> {
  List<City> _cities = [];

  Future<List<City>> getCities() async {
    final response = await rootBundle.loadString('assets/countries.json');
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    _cities = parsed.map<City>((json) => City.fromJson(json)).toList();
    return _cities;
  }

  @override
  void initState() {
    final client = Provider.of<SubiquityClient>(context, listen: false);
    // client.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _factor = MediaQuery.of(context).size.width / 12;
    getCities();
    return LocalizedView(
        builder: (context, lang) => WizardPage(
              title: Text('Where are you currently?'),
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: _factor, left: _factor / 3, right: _factor),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2.7,
                      child: Autocomplete<String>(
                        optionsBuilder: (textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return _cities
                              .map((citiy) => citiy.name.toString())
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
                  ),
                  Expanded(
                    child: FutureBuilder<List<City>>(
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                              children: snapshot.data!
                                  .map((city) => ListTile(
                                        onTap: () => print(city.name),
                                        title: Text(city.name.toString()),
                                      ))
                                  .toList());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                      future: getCities(),
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
