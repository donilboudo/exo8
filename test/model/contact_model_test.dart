import 'package:unittest/unittest.dart';
import 'package:dartlero/dartlero.dart';
import 'package:repertoire_polymer/repertoire.dart';

testModel() {
  ContactModel contactModel;
  Contacts contacts;
  group("Testing Model: ", () {
    setUp(() {
      contactModel = new ContactModel();
      contactModel.init();
      contacts = contactModel.contacts;
    });
    tearDown(() {
      contacts.clear();
      expect(contacts.isEmpty, isTrue);
    });
    test('Display model', () {
      contactModel.display();
    });
  });
}

main() {
  testModel();
}

