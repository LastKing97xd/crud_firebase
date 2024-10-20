
import 'dart:io';
import 'package:ui_flutter/domain/domains.dart';

abstract class LocalStorageRepository{
  Future<List<People>> getPeople();
  
  Future<String> addPeople(Map<String, dynamic> people);

  Future<void> updatePeople(String uId, Map<String, dynamic> newPeople);

  Future<void> deletePeople(String uId);

  Future<String?> uploadImage(File image);
}