
import 'dart:mirrors';

import './annotations.dart';

//https://api.dart.dev/stable/2.9.1/dart-mirrors/dart-mirrors-library.html
//https://www.dartcn.com/articles/server/reflection-with-mirrors

/// - O objetivo desse exemplo é trabalhar com anotações customizadas e filtrar os subtipos
/// dentro da classe espelhada através da `metadata` escificada
/// 
/// - A biblioteca `mirrors` nos permite basicamente tirar um raio-X de uma classe instânciada

void segmentedAnnotation<T>(T object){

  InstanceMirror ref = reflect(object);
  ClassMirror classMirror = ref.type;
  ClassMirror refStatic = reflectClass(classMirror.reflectedType);//acessar os métodos e atributos estáticos

  //print(classMirror.instanceMembers);
  //print(classMirror.declarations.values);
  //print('parentObjectName: ${classMirror.reflectedType.toString()}');

  /// Filtrar os subtipos que possui uma annotation ==> `metadata` 
  /// do tipo `@observable` dentro da classe espelhada
  Iterable<DeclarationMirror> listSubTypeWithMetadata = classMirror.declarations.values
  .where((e) => e.metadata.isNotEmpty)//retorna apenas as declarações que possui uma annotation
  .where((e) => e.metadata.first.reflectee.runtimeType == observable.runtimeType);//retorna apenas as annotation de um tipo específico
  
  //print('Total de anotações: ${listMetadata.length}');
  
  //filtrar e separar os métodos e atributos estaticos e não estaticos, 
  //dessa forma fica mais fácil fazer qualquer tratamento e qualquer coisa
  Iterable<MethodMirror> listMethod = listSubTypeWithMetadata.whereType<MethodMirror>().where((e) => !e.isStatic);
  Iterable<VariableMirror> listVariables = listSubTypeWithMetadata.whereType<VariableMirror>().where((e) => !e.isStatic);

  Iterable<MethodMirror> listMethodStatic = listSubTypeWithMetadata.whereType<MethodMirror>().where((e) => e.isStatic);
  Iterable<VariableMirror> listVariablesStatic = listSubTypeWithMetadata.whereType<VariableMirror>().where((e) => e.isStatic);

  /// Obs: A separação dos métodos e atributos estaticos e não estaticos serve para previnir erros de execução
  /// caso o subtipo não seja estatico deve ser acessado através da propriedade `ref`
  /// caso seja estatico deve ser acessado pela propriedade `refStatic`
  
  /*listSubTypeWithMetadata.forEach((element) {
    var path = element.owner.location.sourceUri.path;
    var parentObject = MirrorSystem.getName(element.owner.simpleName);
    var elementName = MirrorSystem.getName(element.simpleName);
    var value;

    try {//se o subtipo não for estatico
      value = ref.getField(element.simpleName).reflectee;
    } catch (e) {
      value = refStatic.getField(element.simpleName).reflectee;
    }

    print(
      'Path: $path\n'
      'parentObject: $parentObject\n'
      'ElementName: $elementName\n'
      'Value: $value\n'
      'Type: ${value.runtimeType}\n'
      'isPrivate: ${element.isPrivate}\n'
    );

  });*/


  listVariables.forEach((element) { //variaveis não estaticas
    var path = element.owner.location.sourceUri.path;
    var parentObject = MirrorSystem.getName(element.owner.simpleName);
    var elementName = MirrorSystem.getName(element.simpleName);
    //ref.setField(element.simpleName, 'anyValue');//redefinir o valor
    var value = ref.getField(element.simpleName).reflectee;//obter o valor

    print(
      'Path: $path\n'
      'parentObject: $parentObject\n'
      'ElementName: $elementName\n'
      'Value: $value\n'
      'Type: ${value.runtimeType}\n'
      'isFinal: ${element.isFinal}\n'
      'isConst: ${element.isConst}\n'
      'isPrivate: ${element.isPrivate}\n'
      'isExtensionMember: ${element.isExtensionMember}\n'
      'isStatic: ${element.isStatic}\n'
    );

  });


  listMethod.forEach((element) { //métodos não estaticos
    var path = element.owner.location.sourceUri.path;
    var parentObject = MirrorSystem.getName(element.owner.simpleName);
    var elementName = MirrorSystem.getName(element.simpleName);
    var value = ref.getField(element.simpleName).reflectee;//obter o valor

    print(
      'Path: $path\n'
      'parentObject: $parentObject\n'
      'ElementName: $elementName\n'
      'Value: $value\n'
      'Type: ${value.runtimeType}\n'
    );

    //formas de chamar um método
    //ref.invoke(Symbol('mCustomCall'), []);
    //ref.invoke(#mCustomCall, []);
    //ref.invoke(element.simpleName, []);
    //ref.invoke(element.simpleName, ['value'], {#anyValue: 'anyValue'});//com parâmetros
    //ref.getField(element.simpleName).reflectee();

    /*if(element.simpleName == Symbol('mCustomCall')){
      ref.invoke(element.simpleName, []);
    }else if(element.simpleName == Symbol('mCallWithParameter')){
      ref.invoke(element.simpleName, ['argument'], {#anyValue: 'NamedValue'});
    }*/
    
  });


  /// `Métodos e atributos estaticos`
  
  /*listVariablesStatic.forEach((element) { //variaveis estaticas
    var path = element.owner.location.sourceUri.path;
    var parentObject = MirrorSystem.getName(element.owner.simpleName);
    var elementName = MirrorSystem.getName(element.simpleName);
    //refStatic.setField(element.simpleName, 'anyValue');//redefinir o valor
    var value = refStatic.getField(element.simpleName).reflectee; //obter o valor

    print(
      'Path: $path\n'
      'parentObject: $parentObject\n'
      'ElementName: $elementName\n'
      'Value: $value\n'
      'Type: ${value.runtimeType}\n'
      'isFinal: ${element.isFinal}\n'
      'isConst: ${element.isConst}\n'
      'isPrivate: ${element.isPrivate}\n'
      'isExtensionMember: ${element.isExtensionMember}\n'
      'isStatic: ${element.isStatic}\n'
    );

  });*/

  /*listMethodStatic.forEach((element) { //métodos não estaticos
    /*var path = element.owner.location.sourceUri.path;
    var parentObject = MirrorSystem.getName(element.owner.simpleName);
    var elementName = MirrorSystem.getName(element.simpleName);
    var value = refStatic.getField(element.simpleName).reflectee;//obter o valor

    print(
      'Path: $path\n'
      'parentObject: $parentObject\n'
      'ElementName: $elementName\n'
      'Value: $value\n'
      'Type: ${value.runtimeType}\n'
    );*/

    if(element.simpleName == Symbol('aMethodStatic')){
      refStatic.invoke(element.simpleName, []);
    }
    
  });*/

}
