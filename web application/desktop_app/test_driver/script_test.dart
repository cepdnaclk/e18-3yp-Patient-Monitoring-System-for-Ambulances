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
    final adminBtnFinder = find.byValueKey('AdminBtn');
    final adminID = find.byValueKey('adminID');
    final adminPassword = find.byValueKey('adminPwd');
    final loginErrAdmin = find.byValueKey('loginErr');
    final loginBtnAdmin = find.byValueKey('adminLoginBtn');
    final hospitalIDField = find.byValueKey('hospitalIDField');
    final hospitalNameField = find.byValueKey('hospitalNameField');
    final hospitalContactField = find.byValueKey('hospitalContactField');
    final hospitalLattitude = find.byValueKey('hospitalLattField');
    final hospitalLongitude = find.byValueKey('hospitalLongField');
    final addHospitalBtn = find.byValueKey('addHospitalBtn');
    final addHospitalMsg = find.byValueKey('newHospitalPopup');
    final hospitaladdedOK = find.byValueKey('hospitaladdedOK');
    final desktopHomeScroller = find.byValueKey('desktopHomeScroller');
    final hospitalRemoveBtn = find.byValueKey('hospitalRemoveBtn');
    final hospitalRemoveField = find.byValueKey('hospitalRemoveField');
    final hospitalRemovingConf = find.byValueKey('hospitalRemovingConf');
    final hRemoveCancel = find.byValueKey('hRemoveCancel');
    final hRemoveOK = find.byValueKey('hRemoveOK');

    final userIDField = find.byValueKey('userIDField');
    final userPasswordField = find.byValueKey('userPasswordField');
    final addUserBtn = find.byValueKey('userAddingBtn');
    final addUserMsg = find.byValueKey('newUserPopup');
    final UseraddedOK = find.byValueKey('UseraddedOK');
    final UserRemoveBtn = find.byValueKey('userRemoveBtn');
    final UserRemoveField = find.byValueKey('userRemoveField');
    final UserRemovingConf = find.byValueKey('userRemovingConf');
    final uRemoveCancel = find.byValueKey('uRemoveCancel');
    final uRemoveOK = find.byValueKey('uRemoveOK');

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

    test('Check for Admin Privileges', () async {
      await driver.tap(logoutIcon);
      await delay(300);
      expect(await driver.getText(logoutConfirmation),
          "Are you sure you want to logout ?");
      await delay(100);
      await driver.tap(logoutOKBtn);
      final testMap = {
        "A002": 'password2',
        "A003": 'password3',
      };

      for (final mapEntry in testMap.entries) {
        final key = mapEntry.key;
        final value = mapEntry.value;

        await driver.tap(adminBtnFinder);
        await delay(300);

        await driver.tap(adminID); // acquire focus
        await driver.enterText('$key'); // enter text
        await driver.waitFor(find.text('$key')); // verify text appears on UI

        await driver.tap(adminPassword); // acquire focus
        await driver.enterText('$value'); // enter text
        await driver.waitFor(find.text('$value')); // verify text appears on UI

        await driver.tap(loginBtnAdmin);
        await delay(500);
        await driver.tap(find.pageBack());
        await delay(300);
      }
      await driver.tap(adminBtnFinder);
      await delay(300);

      await driver.tap(adminID); // acquire focus
      await driver.enterText('A001'); // enter text
      await driver.waitFor(find.text('A001')); // verify text appears on UI

      await driver.tap(adminPassword); // acquire focus
      await driver.enterText('password1'); // enter text
      await driver.waitFor(find.text('password1')); // verify text appears on UI

      await driver.tap(loginBtnAdmin);
      await delay(500);
    });

    test('Check for hospital adding ', () async {
      await driver.tap(hospitalIDField);
      await driver.enterText('H100'); // enter text
      await driver.waitFor(find.text('H100')); // verify text appears on UI

      await driver.tap(hospitalNameField); // acquire focus
      await driver.enterText('new hospital1'); // enter text
      await driver
          .waitFor(find.text('new hospital1')); // verify text appears on UI

      await driver.tap(hospitalContactField); // acquire focus
      await driver.enterText('0123456789'); // enter text
      await driver
          .waitFor(find.text('0123456789')); // verify text appears on UI

      await driver.tap(hospitalLattitude); // acquire focus
      await driver.enterText('7.2333'); // enter text
      await driver.waitFor(find.text('7.2333')); // verify text appears on UI

      await driver.tap(hospitalLongitude); // acquire focus
      await driver.enterText('80.569'); // enter text
      await driver.waitFor(find.text('80.569')); // verify text appears on UI

      await driver.tap(addHospitalBtn);
      await delay(500);
      expect(await driver.getText(addHospitalMsg), "New Hospital Added");
      await delay(300);
      await driver.tap(hospitaladdedOK);
      await delay(200);
    });
    test('Check for hospital removing', () async {
      await driver.scrollUntilVisible(desktopHomeScroller, hospitalRemoveBtn);
      await driver.tap(hospitalRemoveField);
      await driver.enterText('H100'); // enter text
      await driver.waitFor(find.text('H100')); // verify text appears on UI

      await driver.tap(hospitalRemoveBtn); // acquire focus
      await delay(500);
      expect(await driver.getText(hospitalRemovingConf),
          "Are you sure you want to remove H100 from the System");
      await driver.tap(hRemoveOK);
      await delay(300);
    });

    test('Check for user adding ', () async {
      await driver.scrollUntilVisible(desktopHomeScroller, userIDField);
      await driver.tap(userIDField);
      await driver.enterText('D100'); // enter text
      await driver.waitFor(find.text('D100')); // verify text appears on UI

      await driver.tap(userPasswordField); // acquire focus
      await driver.enterText('pwd100'); // enter text
      await driver.waitFor(find.text('pwd100')); // verify text appears on UI

      await driver.tap(addUserBtn);
      await delay(500);
      expect(await driver.getText(addUserMsg), "New User Added");
      await delay(300);
      await driver.tap(UseraddedOK);
      await delay(200);
    });
    test('Check for user removing', () async {
      await driver.tap(UserRemoveField);
      await driver.enterText('D100'); // enter text
      await driver.waitFor(find.text('D100')); // verify text appears on UI

      await driver.tap(UserRemoveBtn); // acquire focus
      await delay(500);
      expect(await driver.getText(UserRemovingConf),
          "Are you sure you want to remove D100 from the System");
      await driver.tap(uRemoveOK);
      await delay(300);
    });
  });
}
