part of repertoire;

class ContactModel extends ConceptModel {
  static final String contact= 'Contact';

  Map<String, ConceptEntities> newEntries() {
    var contacts = new Contacts();
    var map = new Map<String, ConceptEntities>();
    map[contact] = contacts;
    return map;
  }

  Contacts get contacts => getEntry(contact);

  init() {
    var contact = new Contact();
    contact.code = '1';
    contact.nom = 'ilboudo';
    contact.prenom = 'fabrice';
    contact.numero = '418-271-0361';
    contacts.add(contact);

    //webCategoryLinks.order();

    var contact2= new Contact();
    contact2.code = '2';
    contact2.nom = 'sanou';
    contact2.prenom = 'adama';
    contact2.numero = '518-271-0361';
    contacts.add(contact2);

    //categories.order();

  }

  display() {
    print('Category Links Model');
    print('====================');
    for (var contact in contacts) {
      print('  Category');
      print('  -----');
      print(contact.toString());
    }
    print(
      '============= ============= ============= '
      '============= ============= ============= '
    );
  }
}
