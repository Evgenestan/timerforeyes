// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_variable.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Enable on EnableBase, Store {
  final _$isEnableAtom = Atom(name: 'EnableBase.isEnable');

  @override
  bool get isEnable {
    _$isEnableAtom.reportRead();
    return super.isEnable;
  }

  @override
  set isEnable(bool value) {
    _$isEnableAtom.reportWrite(value, super.isEnable, () {
      super.isEnable = value;
    });
  }

  final _$EnableBaseActionController = ActionController(name: 'EnableBase');

  @override
  void getFalse() {
    final _$actionInfo =
        _$EnableBaseActionController.startAction(name: 'EnableBase.getFalse');
    try {
      return super.getFalse();
    } finally {
      _$EnableBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getTrue() {
    final _$actionInfo =
        _$EnableBaseActionController.startAction(name: 'EnableBase.getTrue');
    try {
      return super.getTrue();
    } finally {
      _$EnableBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isEnable: ${isEnable}
    ''';
  }
}
