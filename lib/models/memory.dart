import 'package:flutter/material.dart';

class Memory {

  static const operations = const ['%', '/', 'X', '-', '+', '='];

  String _value = '0';
  int _bufferIndex = 0;
  String? _operation;
  final _buffer = [0.0, 0.0];
  bool _wipeValue = false;
  String? _lastCommand;

  void applyCommand(String command) {

    if(_isReplacingOperation(command)){ //Se o usuário troca de operação no meio do calculo

      _operation = command; //Substitui o operation pelo novo comando
      return;
    }

    if(command == 'AC'){

      _allClear();

    } else if(operations.contains(command)) {

      setOperations(command);

    }else {

      _addDigit(command);
    }

    _lastCommand = command;
  }

  _isReplacingOperation(String command) { //Se esta substituindo a operação

    return operations.contains(_lastCommand) //Se o ultimo comando tem em operations
      && operations.contains(command) //E o comando atual esta em oparetions
      && _lastCommand != '=' //E o ultimo comando não é igual
      && command != '='; //E o comando também não for igual
      //O usuário esta apenas trocando a operação
  }

  setOperations(String newOperation ){

    bool isEqualSign = newOperation == '=';

    if(_bufferIndex == 0) { //Indice 0
      if(!isEqualSign){ //Se não foi uma operação de '=' (igual)
      _operation = newOperation;  //Seta a operação
      _bufferIndex = 1; //Valor 1
      _wipeValue = true;
      }
    } else {

      _buffer[0] = _calculate(); //O resultado ele coloca no buffer 0
      _buffer[1] = 0.0;
      _value = _buffer[0].toString(); //Mostra no display o resultado
      //Se tiver numero quebrado, termina com ele, se for .0 ele anula
      _value = _value.endsWith('.0') ? _value.split('.')[0] : _value; 

      _operation = isEqualSign ? null : newOperation;
      _bufferIndex = isEqualSign ? 0 : 1;    
    } 

    _wipeValue = true; //Sempre limpa a operação
  }

  _addDigit(String digit) {

    final isDot = digit == '.';
    final wipeValue = (_value == '0' && !isDot) || _wipeValue; //Não limpa o display quando coloca ponto

    if(isDot && _value.contains('.') && !wipeValue) { //Não pode colocar + de 2 pontos 
      return;
    }

    final emptyValue = isDot ? '0' : ''; //Se digitar um ponto depois da ação repõe o zero
    final currentValue = wipeValue ? emptyValue : _value;
    _value = currentValue + digit; //Coloca o valor
    _wipeValue = false; //Não limpa mais o valor

    _buffer[_bufferIndex] = double.tryParse(_value) ?? 0; //Se não for um double valido considera zero
  }

  _allClear() {

    _value = '0'; //Zera o display
    _buffer.setAll(0, [0.0, 0.0]); //Zera os numeros 
    _operation = null; //Zera a operação
    _bufferIndex = 0; //Volta pro index 0
    _wipeValue = false; //Zera a memoria da calculadora
  }

  _calculate() {
    switch(_operation){

      case '%': return _buffer[0] % _buffer[1];
      case '/': return _buffer[0] / _buffer[1];
      case 'xX': return _buffer[0] * _buffer[1];
      case '-': return _buffer[0] - _buffer[1];
      case '+': return _buffer[0] + _buffer[1];

      default: return _buffer[0];

    }
  }

  String get value {

    return _value;
  }

}