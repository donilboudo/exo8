import 'dart:html';
import 'package:repertoire_polymer/repertoire.dart';
import 'package:polymer/polymer.dart';

@CustomTag('contact-edit')
class ContactEdit extends PolymerElement {
  @published Contacts contacts;
  @published Contact contact;
  @published String code;
  @published String nom;
  @published String prenom;
  @published String numero;

  ContactEdit.created() : super.created();

  enteredView() {
    super.enteredView();
    code = contact.code;
    nom = contact.nom;
    prenom = contact.prenom;
    numero = contact.numero;
  }

  update(Event e, var detail, Node target) {
    contact.numero = numero;
    var polymerApp = querySelector('#polymer-app');
    var contactTable = polymerApp.shadowRoot.querySelector('#contact-table');
    contactTable.showEdit = false;    
  }
}