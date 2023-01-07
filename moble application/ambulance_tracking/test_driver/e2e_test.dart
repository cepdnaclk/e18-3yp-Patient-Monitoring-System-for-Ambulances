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
    final hospitalID = find.byValueKey('HospitalIDFinder');
    final submitBtn = find.byValueKey('submitBtnFinder');
    final chatIcon = find.byValueKey('chatIconFinder');
    final stopIcon = find.byValueKey('stopIconFinder');
    final logoutIcon = find.byValueKey('logoutFinder');
    final chatField = find.byValueKey('chatFieldFinder');
    final chatSendBtn = find.byValueKey('chatSendFinder');
    final listFinder = find.byValueKey('scrollFinder');
    final chatTitle = find.byValueKey('appbarChat');
    final logoutConfirmation = find.byValueKey('logoutConfirmationFinder');
    final logoutOKBtn = find.byValueKey('logoutOKBtn');

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

    test('Check for wrong username password inputs', () async {
      await driver.tap(textField1); // acquire focus
      await driver.enterText('D001'); // enter text
      await driver.waitFor(find.text('D001')); // verify text appears on UI

      await driver.tap(textField2); // acquire focus
      await driver.enterText('password2'); // enter text
      await driver.waitFor(find.text('password2')); // verify text appears on UI
      await driver.tap(loginBtn);
      expect(await driver.getText(loginErrMsg), "Incorrect login details");
      await driver.tap(closeDialog);
      expect(await driver.getText(textField1), "");
      expect(await driver.getText(textField2), "");
    });

    test('Check for correct username password inputs', () async {
      await driver.tap(textField1); // acquire focus
      await driver.enterText('D001'); // enter text
      await driver.waitFor(find.text('D001')); // verify text appears on UI

      await driver.tap(textField2); // acquire focus
      await driver.enterText('password1'); // enter text
      await driver.waitFor(find.text('password1')); // verify text appears on UI

      await driver.tap(loginBtn);
    });

    test('checking chat', () async {
      await driver.scrollUntilVisible(listFinder, chatIcon);
      await delay(100);
      await driver.tap(chatIcon);
      await driver.tap(chatField);
      await driver.enterText('hi this is a sample text msg 1');
      await driver.waitFor(find.text('hi this is a sample text msg 1'));
      await delay(100);
      await driver.tap(chatSendBtn);
      await delay(100);
      expect(await driver.getText(chatField), "");
      await delay(100);
      await driver.tap(find.pageBack());
    });
    test('checking logout', () async {
      await delay(100);
      await driver.tap(logoutIcon);
      expect(await driver.getText(logoutConfirmation),
          "Are you sure you want to logout ?");
      await delay(100);
      await driver.tap(logoutOKBtn);
    });
  });
}
