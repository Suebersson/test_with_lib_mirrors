
import 'dart:mirrors';

//https://api.dart.dev/stable/2.9.1/dart-mirrors/dart-mirrors-library.html
//https://www.dartcn.com/articles/server/reflection-with-mirrors

void testMirrors<T>(T object){

  InstanceMirror ref = reflect(object);
  ClassMirror classMirror = ref.type;

  //ClassMirror refClass = reflectClass(StaticValues);//acessar os métodos e atrubos estáticos de uma classe
  //print(refClass.getField(#anyValue).reflectee);

  //print(ref.getField(#name).reflectee);
  //ref.setField(#name, 'Xuxa');//redefinir um valor
  //ref.getField(#customCall).reflectee();//chamar um método
  //ref.invoke(#mCustomCall, []);//outra forma
  //ref.invoke(Symbol('mCustomCall'), []);

  //print(classMirror.instanceMembers);

  //var parentObjectName = MirrorSystem.getName(classMirror.declarations.values.first.owner.simpleName);
  //var parentObjectName = classMirror.reflectedType.toString();

  //Map<Symbol, DeclarationMirror>
  classMirror.declarations.entries.forEach((element) {//ler todos os subtipos da classe espelhada

    //print(element.value.owner.simpleName);//nome do da classe pai
    //print(element.value.owner.qualifiedName);
    //print(element.value.owner.isPrivate);//bool
    //print(element.value.owner.location.sourceUri.path);//endereço do arquivo dart
    //print(element.value.simpleName); //nome do subtypo
    //print(MirrorSystem.getName(element.value.simpleName));
    //print(MirrorSystem.getSymbol('name'));

    ///ler apenas os métodos e atributos com annotation `@metadata`
    if(element.value.metadata.isNotEmpty){
      
      if(element.value.owner.simpleName != element.value.simpleName){
        //print('TypeMirror: ${element.value.runtimeType}');
        //print('Object metadata: ${element.value.metadata.first.type}');
        print('Object metadata: ${element.value.metadata.first.reflectee.runtimeType}');

        var path = element.value.owner.location.sourceUri.path;
        var parentObject = MirrorSystem.getName(element.value.owner.simpleName);
        var elementName = MirrorSystem.getName(element.value.simpleName);
        var value = ref.getField(element.value.simpleName).reflectee;

        print(
          'Path: $path\n'
          'parentObject: $parentObject\n'
          'ElementName: $elementName\n'
          'Value: $value\n'
          'Type: ${value.runtimeType}\n'
        );
    
        //se for um método, execute
        /*if(element.value.runtimeType.toString() == '_MethodMirror'){
          //formas de chamar um método
          //ref.invoke(Symbol('mCustomCall'), []);
          //ref.invoke(#mCustomCall, []);
          //ref.invoke(element.value.simpleName, []);
          //ref.invoke(element.value.simpleName, ['value'], {#anyValue: 'anyValue'});
          //ref.getField(element.value.simpleName).reflectee();

          if(MirrorSystem.getName(element.value.simpleName) == 'mCustomCall'){
            ref.invoke(element.value.simpleName, []);
          }else if(MirrorSystem.getName(element.value.simpleName) == 'mCallWithParameter'){
            ref.invoke(element.value.simpleName, ['argument'], {#anyValue: 'NamedValue'});
          }
        }*/

      }

    }else{

      if(element.value.owner.simpleName != element.value.simpleName){
        //print('TypeMirror: $element.value');

        var path = element.value.owner.location.sourceUri.path;
        var parentObject = MirrorSystem.getName(element.value.owner.simpleName);
        var elementName = MirrorSystem.getName(element.value.simpleName);
        var value = ref.getField(element.value.simpleName).reflectee;

        print(
          'Path: $path\n'
          'parentObject: $parentObject\n'
          'ElementName: $elementName\n'
          'Value: $value\n'
          'Type: ${value.runtimeType}\n'
        );
      }

    }

  });

}

abstract class StaticValues{
  static String anyValue = 'static value';
}


