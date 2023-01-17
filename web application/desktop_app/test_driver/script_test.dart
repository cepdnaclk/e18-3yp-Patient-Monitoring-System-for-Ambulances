import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

//flutter drive --target=test_driver/e2e.dart

void main() {
  group('Patient App', () {
    final textField1 = find.byValueKey('userFinder');
    final textField2 = find.byValueKey('passwordFinder');
    final loginBtn = find.byValueKey('loginBtnFinder');
    final loginErrMsg = find.byValueKey('wrongLoginText');
    final closeDialog = find.byValueKey('OKBtn');
    final logoutIcon = find.byValueKey('logoutFinder');
    final logoutConfirmation = find.byValueKey('logoutConfirmationFinder');
    final logoutOKBtn = find.byValueKey('logoutOKBtn');
    final connectBtn = find.byValueKey('connectBtn');
    final disconnectBtn = find.byValueKey('disconnectBtn');
    final connectText = find.byValueKey('AWSconnect');
    final disconnectText = find.byValueKey('AWSdisconnect');

    late FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    Future<void> delay([int milliseconds = 250]) async {
      await Future<void>.delayed(Duration(milliseconds: milliseconds));
    }

    test('check flutter driver health', () async {
      Health health = await driver.checkHealth();
      print(health.status);
    });

    // test('Application launch', () async {
    //   // Find the 'appBarTitle' Text widget
    //   // final loginTitleFinder = find.byValueKey('loginPageFinder');
    //   //
    //   // // Wait for the 'appBarTitle' Text widget to appear
    //   // await driver.waitFor(loginTitleFinder);
    //
    //   // takeScreenshot("ss1");
    //   // Verify that the 'appBarTitle' Text widget has the correct text
    //   expect(await driver.getText(loginTitleFinder), 'Login');
    // });

    test('Check for wrong username password inputs', () async {
      final testMap = {
        "h001": 'password1',
        "H01": 'password1',
        "001": 'password2',
        "H002": 'password1',
        "H002": '*dg/97-5%',
      };

      for (final mapEntry in testMap.entries) {
        final key = mapEntry.key;
        final value = mapEntry.value;
        print('Key: $key, Value: $value'); // Key: a, Value: 1 ...

        await driver.tap(textField1); // acquire focus
        await driver.enterText('$key'); // enter text
        await driver.waitFor(find.text('$key')); // verify text appears on UI

        await driver.tap(textField2); // acquire focus
        await driver.enterText('$value'); // enter text
        await driver.waitFor(find.text('$value')); // verify text appears on UI
        await driver.tap(loginBtn);
        await delay(500);
        expect(await driver.getText(loginErrMsg), "Invalid Login");
        await driver.tap(closeDialog);
        await delay(500);
        expect(await driver.getText(textField1), "");
        expect(await driver.getText(textField2), "");
      }
    });

    test('Check for correct username password inputs', () async {
      final testMap = {
        "H001": 'password1',
        "H002": 'password2',
        "H003": 'password3',
        "H004": 'password4',
        "H005": 'password5'
      };

      for (final mapEntry in testMap.entries) {
        final key = mapEntry.key;
        final value = mapEntry.value;

        await driver.tap(textField1); // acquire focus
        await driver.enterText('$key'); // enter text
        await driver.waitFor(find.text('$key')); // verify text appears on UI

        await driver.tap(textField2); // acquire focus
        await driver.enterText('$value'); // enter text
        await driver.waitFor(find.text('$value')); // verify text appears on UI

        await driver.tap(loginBtn);
        await delay(300);
        await driver.tap(logoutIcon);
        await delay(300);
        expect(await driver.getText(logoutConfirmation),
            "Are you sure you want to logout ?");
        await delay(100);
        await driver.tap(logoutOKBtn);
      }
      await delay(200);
      await driver.tap(textField1); // acquire focus
      await driver.enterText('H001'); // enter text
      await driver.waitFor(find.text('H001')); // verify text appears on UI

      await driver.tap(textField2); // acquire focus
      await driver.enterText('password1'); // enter text
      await driver.waitFor(find.text('password1')); // verify text appears on UI
      await driver.tap(loginBtn);
    });
    test('Check for connect, disconnect  buttons', () async {
      await delay(300);
      await driver.tap(connectBtn);
      await delay(200);
      expect(await driver.getText(connectText), "Connected to AWS");
      await delay(200);
      await driver.tap(disconnectBtn);
      await delay(200);
      expect(await driver.getText(disconnectText), "Not Connected");
    });
  });
}
