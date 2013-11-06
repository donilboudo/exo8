part of repertoire;

class Contact extends ConceptEntity<Contact> {
  String _nom;
  String _prenom;
  String _numero;

  String get nom => _nom;
  set nom(value) {
    if (value != null && !value.isEmpty) _nom = value;
  }
  
  String get prenom => _prenom;
  set prenom(value) {
    if (value != null && !value.isEmpty) _prenom = value;
  }
  
  String get numero => _numero;
  set numero(value) {
    if (value != null && !value.isEmpty) _numero = value;
  }

  //String toString() => 'Contact: $nom $prenom $numero';

  String toString() {
    return '  {\n '
           '    ${super.toString()}, \n '
           '    Nom: ${nom}\n'
           '    Preom: ${prenom}\n'
           '    Numero: ${numero}\n'
           '  }\n';
  }


  //Contact newEntity() => new Contact();



  Map<String, Object> toJson() {
    Map<String, Object> entityMap = super.toJson();
    entityMap['nom'] = nom;
    entityMap['prenom'] = prenom;
    entityMap['numero'] = numero;
    return entityMap;
  }

  fromJson(Map<String, Object> entityMap) {
    super.fromJson(entityMap);
   // code = entityMap['code'];
    nom = entityMap['nom'];
    prenom = entityMap['prenom'];
    numero = entityMap['numero'];
  }

  ConceptEntityApi newEntity() {
    // TODO implement this method
  }
}

class Contacts extends ConceptEntities<Contact> {
  Contacts newEntities() => new Contacts();
  Contact newEntity() => new Contact();
}
