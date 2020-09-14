
import 'dart:mirrors';

//referência: woolha.com/tutorials/dart-using-and-retrieving-metadata-annotation

void testExemplo(){

  MyClass myClass = new MyClass();
  InstanceMirror ref = reflect(myClass);
  ClassMirror classMirror = ref.type;

  classMirror.metadata.forEach((metadata) {
    if (metadata.reflectee is Todo) {
      print(metadata.reflectee.name);
      print(metadata.reflectee.description);
    }
  });

  /*for (var v in classMirror.declarations.values) {
    if (!v.metadata.isEmpty) {
      if (v.metadata.first.reflectee is Todo) {
        print(v.metadata.first.reflectee.name);
        print(v.metadata.first.reflectee.description);
      }
    }
  }*/

  //Map<Symbol, DeclarationMirror>
  classMirror.declarations.entries.forEach((element) {

    //print(element.value.owner.simpleName);//nome do da classe pai
    //print(element.value.owner.qualifiedName);
    //print(element.value.owner.isPrivate);//bool
    //print(element.value.owner.location.sourceUri.path);//endereço do arquivo dart
    //print(element.value.simpleName); //nome do objeto criado que esta usando a annotation
    //print(element.value.simpleName.toString().replaceAll('Symbol("', '').replaceAll('")', '')); 

    if(element.value.metadata.isNotEmpty){
      print(element.value.metadata.first.reflectee.name);
      print(element.value.metadata.first.reflectee.description);
    }

  });


}



class Todo {
  final String name;
  final String description;
  const Todo(this.name, this.description);
}

@Todo('Chibi', 'Rename class')
class MyClass{

  @Todo('Tuwaise', 'Change fielld type')
  int value;

  @Todo('Anyone', 'Change format')
  void printValue() {
    print('value: $value');
  }

  @Todo('Anyone', 'Remove this')
  MyClass();
}



