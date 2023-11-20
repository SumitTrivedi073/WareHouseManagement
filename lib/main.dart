import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:REUZEIT/screens/addproduct/homePage.dart';
import 'package:REUZEIT/theme/color.dart';
import 'package:REUZEIT/theme/string.dart';
import 'package:REUZEIT/theme/theme.dart';
import 'package:REUZEIT/uiwidget/robotoTextWidget.dart';
import 'package:REUZEIT/utils/constant.dart';
import 'package:REUZEIT/utils/utility.dart';
import 'package:REUZEIT/webservice/APIDirectory.dart';

import 'login/loginModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? isLoggedIn =
  (sharedPreferences.getString(userID) == null) ? False : True;

  runApp(MyApp(isLoggedIn: isLoggedIn,));
}

class MyApp extends StatelessWidget {

  String? isLoggedIn;
   MyApp({super.key,required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home:  isLoggedIn == True
          ? MyHomePage(title: appName) :LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key,}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false, isLoading = false;
  String? osVersion,osAPI,deviceName,deviceModel,releaseVersion,
  brand,manufacturer,serialNumber;


  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/background.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
              child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: SvgPicture.asset('assets/svg/logo2.svg',
                      height: 200, width: 200),
                ),
                emailWidget(
                    emailController, TextInputType.emailAddress, enterEmail),
                SizedBox(
                  height: 10,
                ),
                passwordWidget(
                    passwordController, TextInputType.text, enterPassword),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Utility()
                        .checkInternetConnection()
                        .then((connectionResult) {
                      if (connectionResult) {
                        if (emailController.text.toString().isEmpty) {
                          Utility().showInSnackBar(
                              value: enterEmail, context: context);
                        } else if (passwordController.text.toString().isEmpty) {
                          Utility().showInSnackBar(
                              value: enterPassword, context: context);
                        } else {
                          signIn();
                        }
                      } else {
                        Utility().showInSnackBar(
                            value: checkInternetConnection, context: context);
                      }
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.themeColor),
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                color: AppColor.whiteColor,
                              ),
                            )
                          : robotoTextWidget(
                              textval: login,
                              colorval: Colors.white,
                              sizeval: 14,
                              fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ))),
    );
  }

  emailWidget(TextEditingController controller, TextInputType inputType,
      String hintTxt) {
    return Card(
        elevation: 5,
        shadowColor: Colors.black,
        color: Colors.white,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: TextField(
                controller: controller,
                style: const TextStyle(
                    color: AppColor.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto'),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintTxt,
                  hintStyle: const TextStyle(
                      color: AppColor.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto'),
                  prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.email,
                        color: AppColor.themeColor,
                      )),
                ),
                keyboardType: inputType,
                textInputAction: TextInputAction.next),
          ),
        ));
  }

  passwordWidget(TextEditingController controller, TextInputType inputType,
      String hintTxt) {
    return Card(
        elevation: 5,
        shadowColor: Colors.black,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: TextField(
            controller: passwordController,
            style: const TextStyle(
              color: AppColor.blackColor,
            ),
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintTxt,
              hintStyle: const TextStyle(
                  color: AppColor.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto'),
              prefixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.lock,
                    color: AppColor.themeColor,
                  )),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColor.darkGrey,
                ),
                onPressed: () {
                  setState(
                    () {
                      isPasswordVisible = !isPasswordVisible;
                    },
                  );
                },
              ),
              alignLabelWithHint: false,
            ),
            keyboardType: inputType,
            textInputAction: TextInputAction.done,
          ),
        ));
  }

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
   /*   osVersion = androidDeviceInfo.version.baseOS;
      releaseVersion = androidDeviceInfo.version.release;
      osAPI = androidDeviceInfo.version.sdkInt.toString();
      deviceName = androidDeviceInfo.device;
      deviceModel = androidDeviceInfo.model;
      brand = androidDeviceInfo.product;
      manufacturer = androidDeviceInfo.manufacturer;
   */
      serialNumber = androidDeviceInfo.id;
    /*  print('osVersion=====> ${androidDeviceInfo.version}'
          'releaseVersion=====> ${androidDeviceInfo.version.release}'
          'osAPI=====> ${androidDeviceInfo.version.sdkInt.toString()}'
          'deviceName=====>${androidDeviceInfo.model}'
          'deviceModel=====> ${androidDeviceInfo.model}'
          'brand=====> ${androidDeviceInfo.brand}'
          'manufacturer=====>${androidDeviceInfo.manufacturer}'
          'serialNumber=====> ${androidDeviceInfo.id}');*/

      print('serialNumber============>${serialNumber}');
    }else if(Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      /*  osVersion = iosDeviceInfo.utsname.version;
      releaseVersion = iosDeviceInfo.utsname.release;
      osAPI = iosDeviceInfo.utsname.nodename;
      deviceName = iosDeviceInfo.name;
      deviceModel = iosDeviceInfo.model;
      brand = "IOS";
      manufacturer = "IOS";
    */
      serialNumber = iosDeviceInfo.identifierForVendor;

    }

      var finalData = {
        "Email": emailController.text.toString().trim(),
        "Password": passwordController.text.toString().trim(),
        "deviceid":serialNumber,
        "txtaction": 'AuthDevice',
      };
      print('finalData========>${jsonEncode(finalData)}');
      var jsonData = null;
      try {
        var response = await http.post(loginAPI(), body: finalData);
        print(response.body.toString());
        jsonData = jsonDecode(response.body);

        LoginModel loginModel = LoginModel.fromJson(jsonData);
        if (loginModel.data[0].result == "Success") {
          Utility().showToast(loginModel.data[0].reason);
          setState(() {
            isLoading = false;
          Utility().setSharedPreference(userID, loginModel.data[0].userGuid);
          });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => MyHomePage(title: appName)),
                  (Route<dynamic> route) => false);
        } else {
          Utility().showToast(loginModel.data[0].reason);

          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        e.toString();
        print('error===>${e.toString()}');
        Utility().showToast(e.toString());
        setState(() {
          isLoading = false;
        });
      }
  }
}
