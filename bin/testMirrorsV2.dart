
import 'dart:mirrors';

//https://api.dart.dev/stable/2.9.1/dart-mirrors/dart-mirrors-library.html
//https://www.dartcn.com/articles/server/reflection-with-mirrors

/*
  - Nesse exemplo é feito testes com espelhamentos de uma classe
  - Com filtragem dos métodos e atributos com e sem metadata, estaticos e não estaticos
*/

void testeMirrorsV2<T>(T object){

  InstanceMirror ref = reflect(object);
  ClassMirror classMirror = ref.type;
  ClassMirror refStatic = reflectClass(classMirror.reflectedType);//acessar os métodos e atributos estáticos

  //print(classMirror.instanceMembers);
  //print(classMirror.reflectedType.toString());

  /// Filtrar todos subtipos sem `metadata` 
  Iterable<DeclarationMirror> listSubTypes = classMirror.declarations.values
  .where((e) => e.metadata.isEmpty)
  .where((e) => e.simpleName != Symbol(classMirror.reflectedType.toString()));
  //print('${listSubTypes.length} subtipos sem metadata');

  //filtrar e separar os métodos e atributos estaticos e não estaticos, 
  //dessa forma fica mais fácil fazer qualquer tratamento e qualquer coisa
  Iterable<MethodMirror> listMethod = listSubTypes.whereType<MethodMirror>().where((e) => !e.isStatic);
  Iterable<VariableMirror> listVariables = listSubTypes.whereType<VariableMirror>().where((e) => !e.isStatic);

  Iterable<MethodMirror> listMethodStatic = listSubTypes.whereType<MethodMirror>().where((e) => e.isStatic);
  Iterable<VariableMirror> listVariablesStatic = listSubTypes.whereType<VariableMirror>().where((e) => e.isStatic);

  /// Filtrar todos subtipos com `metadata` 
  Iterable<DeclarationMirror> listSubTypesWithMetadata = classMirror.declarations.values
  .where((e) => e.metadata.isNotEmpty)
  .where((e) => e.simpleName != Symbol(classMirror.reflectedType.toString()));
  //print('${listSubTypesWithMetadata.length} subtipos com metadata');

  Iterable<MethodMirror> listMethodWithMetadata = listSubTypesWithMetadata.whereType<MethodMirror>().where((e) => !e.isStatic);
  Iterable<VariableMirror> listVariablesWithMetadata = listSubTypesWithMetadata.whereType<VariableMirror>().where((e) => !e.isStatic);

  Iterable<MethodMirror> listMethodStaticWithMetadata = listSubTypesWithMetadata.whereType<MethodMirror>().where((e) => e.isStatic);
  Iterable<VariableMirror> listVariablesStaticWithMetadata = listSubTypesWithMetadata.whereType<VariableMirror>().where((e) => e.isStatic);

  /// Obs: A separação dos métodos e atributos estaticos e não estaticos serve para previnir erros de execução.
  /// Caso o subtipo não seja estatico deve ser acessado através da propriedade `ref`,
  /// caso seja estatico deve ser acessado pela propriedade `refStatic`


  /// `acessando métodos e atributos não estaticos sem uma @metadata`

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


  /*listMethod.forEach((element) { //métodos não estaticos
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
    
  });*/


  /// `acessando métodos e atributos estaticos sem uma @metadata`
  
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

    refStatic.invoke(element.simpleName, []);
    
  });*/















  /// `acessando métodos e atributos não estaticos com @metadata`

  /*listVariablesWithMetadata.forEach((element) { //variaveis não estaticas
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

  });*/


  /*listMethodWithMetadata.forEach((element) { //métodos não estaticos
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
    
  });*/


  /// `acessando métodos e atributos estaticos com @metadata`
  
  /*listVariablesStaticWithMetadata.forEach((element) { //variaveis estaticas
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

  }); */

  /*listMethodStaticWithMetadata.forEach((element) { //métodos não estaticos
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







