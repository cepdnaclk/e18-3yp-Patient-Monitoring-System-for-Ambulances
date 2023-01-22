import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

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
    final initialVal = find.byValueKey('initialParameterValue');
    final dStatus = find.byValueKey('realstatus');
    final pName = find.byValueKey('nameFinder');
    final pAge = find.byValueKey('ageFinder');
    final pCondition = find.byValueKey('conditionFinder');
    final hospitalField = find.byValueKey('hospitalFinder');
    final hospitalScroller = find.byValueKey('hospitalScroller');
    final stopOK = find.byValueKey('stopOk');
    final stopAlert = find.byValueKey('stopMsg');
    final stopContent = find.byValueKey('stopMsg2');
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
      final testMap = {
        "d001": 'password1',
        "D001": 'password2',
        "D01": 'password1',
        "001": 'password1',
        "D002": 'password1',
        "D002": '*dg/97-5%',
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
        expect(await driver.getText(loginErrMsg), "Incorrect login details");
        await driver.tap(closeDialog);
        expect(await driver.getText(textField1), "");
        expect(await driver.getText(textField2), "");
      }
    });

    test('Check for correct username password inputs', () async {
      final testMap = {
        "D002": 'password2',
        "D003": 'password3',
        "D004": 'password4',
        "D005": 'password5'
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

        await driver.scrollUntilVisible(listFinder, logoutIcon);
        await driver.tap(logoutIcon);
        expect(await driver.getText(logoutConfirmation),
            "Are you sure you want to logout ?");
        await delay(100);
        await driver.tap(logoutOKBtn);
      }
      await driver.tap(textField1); // acquire focus
      await driver.enterText('D001'); // enter text
      await driver.waitFor(find.text('D001')); // verify text appears on UI

      await driver.tap(textField2); // acquire focus
      await driver.enterText('password1'); // enter text
      await driver.waitFor(find.text('password1')); // verify text appears on UI
      await driver.tap(loginBtn);
    });

    test('Check for initial states of second page', () async {
      await driver.scrollUntilVisible(listFinder, dStatus);

      expect(await driver.getText(dStatus), 'Offline');
      expect(await driver.getText(hospitalID), '');
      expect(await driver.getText(pName), '');
      expect(await driver.getText(pAge), '');
      expect(await driver.getText(pCondition), '');
    });

    test( 'Check for entering details to initialize the connection with the hospital', () async {
      await driver.scrollUntilVisible(listFinder, hospitalID);
      await driver.tap(hospitalID);
      await driver.enterText('001');
      await driver.waitFor(find.text('001')); // verify text appears on UI

      await driver.tap(pName);
      await driver.enterText('John Doe');
      await driver.waitFor(find.text('John Doe')); // verify text appears on UI

      await driver.tap(pAge);
      await driver.enterText('30');
      await driver.waitFor(find.text('30')); // verify text appears on UI

      await driver.tap(pCondition);
      await driver.enterText('normal');
      await driver.waitFor(find.text('normal')); // verify text appears on UI

      await driver.tap(submitBtn);
      await delay(500);
    });

    test('Check after connecting with the hospital', () async {
      await delay(5000);
      expect(await driver.getText(dStatus), 'Active');
      await driver.scrollUntilVisible(listFinder, hospitalID);

      await driver.tap(pName);
      await driver.enterText('Jane Doe');
      await driver.waitFor(find.text('Jane Doe')); // verify text appears on UI

      await driver.tap(pAge);
      await driver.enterText('20');
      await driver.waitFor(find.text('20')); // verify text appears on UI

      await driver.tap(pCondition);
      await driver.enterText('critical');
      await driver.waitFor(find.text('critical')); // verify text appears on UI

      await driver.tap(submitBtn);
    });

    test('checking chat', () async {
      final testMap = {
        "msg1": 'this is a sample message 1',
        "msg2": 'this is a sample message 2',
        "msg3": 'this is a sample message 3',
        "msg4": 'this is a sample message 4',
        "msg5": 'this is a sample message 5'
      };

      await driver.scrollUntilVisible(listFinder, chatIcon);
      await delay(100);
      await driver.tap(chatIcon);

      for (final mapEntry in testMap.entries) {
        final value = mapEntry.value;

        await driver.tap(chatField);
        await driver.enterText('$value');
        await driver.waitFor(find.text('$value'));
        await delay(100);
        await driver.tap(chatSendBtn);
        expect(await driver.getText(chatField), "");
        await delay(100);
      }
      await driver.tap(find.pageBack());
    });

    test('stop the connection and check the status', () async {
      await driver.scrollUntilVisible(listFinder, stopIcon);
      await driver.tap(stopIcon);
      await delay(2000);
      expect(await driver.getText(stopAlert), "Stop Device");
      print('1');
      //expect(await driver.getText(stopContent), "Stopped Device: 001");
      await delay(200);
      await driver.tap(stopOK);
      await delay(20000);
      expect(await driver.getText(dStatus), "Offline");
      print('2');
      await delay(200);
      await driver.scrollUntilVisible(listFinder, logoutIcon);
      await driver.tap(logoutIcon);
      await delay(300);
      expect(await driver.getText(logoutConfirmation),
          "Are you sure you want to logout ?");
      await delay(300);
      await driver.tap(logoutOKBtn);
      print('3');
      await delay(300);
      expect(await driver.getText(textField1), "");
      expect(await driver.getText(textField2), "");
    });
  });
}
