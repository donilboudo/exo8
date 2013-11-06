import 'package:unittest/unittest.dart';
import 'package:dartlero/dartlero.dart';
import 'package:repertoire_polymer/repertoire.dart';

testContacts() {
  Contacts contacts;
  group("Testing Contacts: ", () {
    setUp(() {
      ContactModel contactModel = new ContactModel();
      contactModel.init();
      contacts = contactModel.contacts;
    });
    tearDown(() {
      contacts.clear();
      expect(contacts.isEmpty, isTrue);
    });
    test('Add contact', () {
      var contact = new Contact();
      contact.code = '3';
      contact.nom = 'Lemelin';
      contact.prenom = 'binjamin';
      contact.numero = '456-789-0123';
      var added = contacts.add(contact);
      expect(added, isTrue);
      contacts.display('Add contact');
    });
    test('Add contact without data', () {
      var contact = new Contact();
      expect(contact, isNotNull);
      var added = contacts.add(contact);
      expect(added, isTrue);
      contacts.display('Add category without data');
    });
    test('Add contact which already exist', () {
      var contact = new Contact();
      contact.code = '1';
      var added = contacts.add(contact);
      expect(added, isFalse);
      contacts.display('Add not unique category');
    });
    test('Find contact by id', () {
      var searchCode = '2';
      var contact = contacts.find(searchCode);
      expect(contact, isNotNull);
      expect(contact.code, equals(searchCode));
      contact.display('Find contact by id');
    });
    test('Order contacts', () {
      var length = contacts.length;
      contacts.order();
      expect(contacts.length, equals(length));
      contacts.display('Contacts ordered by id');
    });
    test('From contacts to JSON', () {
      List<Map<String, Object>> json = contacts.toJson();
      expect(json, isNotNull);
      print(json);
    });
    test('From JSON to contacts', () {
      List<Map<String, Object>> json = contacts.toJson();
      contacts.clear();
      expect(contacts.isEmpty, isTrue);
      contacts.fromJson(json);
      expect(contacts.isEmpty, isFalse);
      contacts.display('From JSON to categories');
    });
  });
}

main() {
  testContacts();
}