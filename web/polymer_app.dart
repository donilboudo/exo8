import 'dart:html';
import 'dart:convert';
import 'package:repertoire_polymer/repertoire.dart';
import 'package:polymer/polymer.dart';

@CustomTag('polymer-app')
class PolymerApp extends PolymerElement {
  static const String NAME = 'polymer-contact';
  @observable Contacts contacts;

  PolymerApp.created() : super.created() {
    var contactModel = new ContactModel();
    contacts = contactModel.contacts;

    // load data
    String json = window.localStorage[NAME];
    if (json == null) {
      contactModel.init();
    } else {
      contacts.fromJson(JSON.decode(json));
    }

    contacts.internalList = toObservable(contacts.internalList);
  }

  save(Event e, var detail, Node target) {
    window.localStorage[NAME] = JSON.encode(contacts.toJson());
  }
}