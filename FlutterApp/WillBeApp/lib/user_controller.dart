import 'dart:js_util';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

///로그인한 유저의 정보에 접근하기 위한 getX클래스.
class UserController extends GetxController {
  final Rx<User> _firebaseUser = Rx<User>(newObject());

  User get user => _firebaseUser.value;

  set user(User value) => _firebaseUser.value = value;
}
