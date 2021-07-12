import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets.dart';
import '../wizard_page.dart';
import 'city.dart';

class WhereAreYouPage extends StatefulWidget {
  const WhereAreYouPage({Key? key}) : super(key: key);

  @override
  _WhereAreYouPageState createState() => _WhereAreYouPageState();
}

class _WhereAreYouPageState extends State<WhereAreYouPage> {
  List<City> _cityList = [];
  late String? timeZone;

  Future<List<City>> getCities() async {
    final response = await rootBundle.loadString('assets/cities.json');
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    _cityList = parsed.map<City>((json) => City.fromJson(json)).toList();
    return _cityList;
  }

  @override
  void initState() {
    timeZone = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final factor = MediaQuery.of(context).size.width / 12;
    getCities();

    return LocalizedView(
        builder: (context, lang) => WizardPage(
              title: Text('Where are you currently?'),
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: factor, left: factor / 3, right: factor),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2.7,
                      child: Autocomplete<String>(
                        optionsBuilder: (textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return _cityList
                              .map((citiy) => citiy.name.toString())
                              .toList()
                              .where((option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (selectedString) {
                          var newTimeZone = _cityList
                              .where((city) => city.name
                                  .toLowerCase()
                                  .contains(selectedString.toLowerCase()))
                              .first
                              .timeZone
                              .first;

                          setState(() {
                            timeZone = newTimeZone;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: factor),
                    child: Icon(Icons.arrow_forward),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(
                        bottom: factor, left: factor / 3, right: factor),
                    child: Text(
                      timeZone ?? ' ',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  )),
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
