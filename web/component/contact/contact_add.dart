import 'dart:html';
import 'package:repertoire_polymer/repertoire.dart';
import 'package:polymer/polymer.dart';
import 'contact_table.dart';

@CustomTag('contact-add')
class ContactAdd extends PolymerElement {
  @published Contacts contacts;

  ContactAdd.created() : super.created();
  ContactTable ct;
  
  
  add(Event e, var detail, Node target) {
    //InputElement code = $['code'];
    var code = contacts.length + 1;
    InputElement nom = $['nom'];
    InputElement prenom = $['prenom'];
    InputElement numero = $['numero'];
    Element message = $['message'];
    
    var error = false;
    message.text = '';
    if ((nom.value.trim() == '')&&(numero.value.trim() == '')) {
     /* message.text = 'Name and number are requiered; ${message.text}';*/
      error = true;
      window.alert('Name and number are requiered');
    }
    if (!error) {
      var contact = new Contact();
      contact.code = code.toString();
      contact.nom = nom.value.toLowerCase();
      contact.prenom = prenom.value;
      contact.numero = numero.value;
      if (contacts.add(contact)) {
        message.text = 'added';
        /*var json = contacts.toJson();
        String json_string = json.toString();
        window.localStorage['polymer-contact'] = json_string;*/
        //categories.order();
      } else {
        message.text = 'contact is already existe';
      }
    }
    ct.showAdd = false;
  }
}