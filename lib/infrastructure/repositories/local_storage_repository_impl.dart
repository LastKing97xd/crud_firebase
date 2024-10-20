//*Repository puede cambiar de Datasources
import 'dart:io';
import 'package:ui_flutter/domain/domains.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository{
  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl({required this.datasource});

  @override
  Future<List<People>> getPeople() {
    return datasource.getPeople();
  }
  
  @override
  Future<String> addPeople(Map<String, dynamic> people) {
    return datasource.addPeople(people);
  }
  
  @override
  Future<void> updatePeople(String uId, Map<String, dynamic> newPeople) {
    return datasource.updatePeople(uId, newPeople);
  }
  
  @override
  Future<void> deletePeople(String uId) {
    return datasource.deletePeople(uId);
  }

  @override
  Future<String?> uploadImage(File image) {
    return datasource.uploadImage(image);
  }
 }