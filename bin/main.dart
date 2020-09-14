
import './annotations.dart';

import './segmentedAnnotation.dart';
import 'testMirrors.dart';
import 'testMirrorsV2.dart';

void main(){

  //nessa versão se tiver algum subtipos estaticos dará um erro
  //testMirrors(FakeClass());

  //versão mais aprimorada que pode percorrer métodos e atributos com e sem metadata,
  //estaticos e não estaticos
  //testeMirrorsV2(FakeClass());
  
  //versão com uma segmentação de uma metadata e com fitragem de métodos e atributos estaticos e não estaticos
  segmentedAnnotation(FakeClass());
  
}

class FakeClass extends AnyClass{

  /// subtipos sem uma `@metadata`
  
  String name = 'Carlos';
  String email = 'carlos@gmail.com';
  int ago = 30;

  static void callFun2(){
    print('callFun2');
  }

  static String sName = 'Carlos';
  static String sEmail = 'carlos@gmail.com';
  static int sAgo = 30;

  static void callFun(){
    print('callFun');
  }

  /// com `@metadata`
  
  @override
  void anyCall() {
    super.anyCall();
  }
  @override
  dynamic anything = 'any value';

  @observable
  final String mName = 'Leticia';
  @observable
  String mEmail = 'leticia@gmail.com';
  @observable
  int mAgo = 45;
  
  @observable
  void mCustomCall(){
    print('customCall');
  }

  @observable
  void mCallWithParameter<T>(T value, {T anyValue}){
    print(value);
    print(anyValue);
  }

  // subtipos estaticos
  @observable
  static String mStatic = 'uma valor estatico';

  @observable
  static void aMethodStatic(){
    print('aMethodStatic');
  }

}

abstract class AnyClass{
  dynamic anything;
  void anyCall(){}
}




/*rascunhos
  //var value = element.value.metadata.first.getField(MirrorSystem.getSymbol(elementName)).reflectee;
  //element.value.metadata.first.getField(#start).reflectee(); //chamar o método
*/




