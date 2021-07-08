import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subiquity_client/subiquity_client.dart';
import 'package:ubuntu_desktop_installer/pages/wizard_page.dart';
import 'package:ubuntu_desktop_installer/widgets/localized_view.dart';
import 'package:yaru/yaru.dart' as yaru;

import '../routes.dart';

class WhoAreYouPage extends StatefulWidget {
  const WhoAreYouPage({Key? key}) : super(key: key);

  @override
  _WhoAreYouPageState createState() => _WhoAreYouPageState();
}

enum LoginStrategy { REQUIRE_PASSWORD, AUTO_LOGIN }

class _WhoAreYouPageState extends State<WhoAreYouPage> {
  final avatars = [1, 2, 3, 4, 5];
  late LoginStrategy loginStrategy;
  late TextEditingController realNameController;
  late TextEditingController computerNameController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    realNameController = TextEditingController();
    computerNameController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    loginStrategy = LoginStrategy.REQUIRE_PASSWORD;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
        builder: (context, lang) => WizardPage(
              title: Text('Who are you?'),
              content: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextFormField(
                                  controller: realNameController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Your name'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.check_circle,
                                  color: yaru.Colors.green),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextFormField(
                                  controller: computerNameController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Your Computers name'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.check_circle,
                                  color: yaru.Colors.green),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                                'The name it uses when it talks to other computers.'),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextFormField(
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Pick a username'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(Icons.check_circle,
                                  color: yaru.Colors.green),
                            )
                          ],
                        ),
                        loginStrategy == LoginStrategy.REQUIRE_PASSWORD
                            ? Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: TextFormField(
                                        controller: passwordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Choose a password'),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(Icons.check_circle,
                                        color: yaru.Colors.green),
                                  )
                                ],
                              )
                            : Padding(padding: EdgeInsets.all(1)),
                        loginStrategy == LoginStrategy.REQUIRE_PASSWORD
                            ? Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: TextFormField(
                                        controller: confirmPasswordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Confirm your password'),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(Icons.check_circle,
                                        color: yaru.Colors.green),
                                  )
                                ],
                              )
                            : Padding(padding: EdgeInsets.all(1)),
                        Row(
                          children: [
                            Radio<LoginStrategy>(
                                value: LoginStrategy.AUTO_LOGIN,
                                groupValue: loginStrategy,
                                onChanged: (_) => setState(() {
                                      loginStrategy = LoginStrategy.AUTO_LOGIN;
                                    })),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text('Log in automatically'),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Radio<LoginStrategy>(
                                value: LoginStrategy.REQUIRE_PASSWORD,
                                groupValue: loginStrategy,
                                onChanged: (_) => setState(() {
                                      loginStrategy =
                                          LoginStrategy.REQUIRE_PASSWORD;
                                    })),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  const Text('Require my password to log in'),
                            )
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Optional: Select a picture',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width -
                                MediaQuery.of(context).size.width / 1.4,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height:
                                    MediaQuery.of(context).size.height / 2.3,
                                viewportFraction: 0.6,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 300),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                onPageChanged: (index, _) => print(index),
                                scrollDirection: Axis.horizontal,
                              ),
                              items: avatars.map((i) {
                                return Builder(
                                  builder: (context) {
                                    return CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width /
                                              14,
                                      backgroundColor: yaru.Colors.porcelain,
                                      child: CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.width /
                                                14.5,
                                        foregroundImage: NetworkImage(
                                            'https://picsum.photos/250?image=1'
                                            '$i'),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
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
                  onActivated: () async {
                    final client =
                        Provider.of<SubiquityClient>(context, listen: false);

                    await client.setIdentity(IdentityData(
                        hostname: computerNameController.text,
                        realname: realNameController.text,
                        username: usernameController.text,
                        cryptedPassword: passwordController.text));

                    Navigator.pushNamed(context, Routes.chooseYourLook);
                  },
                ),
              ],
            ));
  }
}
