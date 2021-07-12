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
  late String? _timeZone;

  Future<List<City>> getCities() async {
    final response = await rootBundle.loadString('assets/cities.json');
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    _cityList = parsed.map<City>((json) => City.fromJson(json)).toList();
    return _cityList;
  }

  @override
  void initState() {
    _timeZone = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getCities();

    return LocalizedView(
        builder: (context, lang) => WizardPage(
              title: Text('Where are you currently?'),
              content: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Search for your city:'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Autocomplete<String>(
                              optionsBuilder: (textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<String>.empty();
                                }
                                return _cityList
                                    .map((citiy) => citiy.name.toString())
                                    .toList()
                                    .where((option) {
                                  return option.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase());
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
                                  _timeZone = newTimeZone;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 60, right: 8, bottom: 14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Timezone:'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${_timeZone!}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
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
