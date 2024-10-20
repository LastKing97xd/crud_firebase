
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:ui_flutter/domain/domains.dart';
import 'package:ui_flutter/infrastructure/infrastructures.dart';

class FirebaseDatasource extends LocalStorageDatasource {
  
  @override
  Future<List<People>> getPeople() async {
    try {
      final response = await FirebaseFirestore.instance.collection('people').get();   
      List<PeopleResponse> peopleResponse = response.docs
          .map((doc) { 
            return PeopleResponse.fromJson({
              
              'id': doc.id,
              ...doc.data(),         

            });
          }).toList();
      return peopleResponse.map((dto) => PeopleMapper.fireToEntity(dto)).toList();
    } catch (e) {
      throw Exception('Error obteniendo la lista de personas: $e');
    }
  }

  @override
  Future<String> addPeople(Map<String, dynamic> people) async {
    try{
      final docRef = await FirebaseFirestore.instance.collection('people').add(people);
      return docRef.id;
    } catch (e) {
      throw Exception('Error al agregar persona: $e');
    }
  }
  
  @override
  Future<void> updatePeople(String uId, Map<String, dynamic> newPeople) async {
    try{
      await FirebaseFirestore.instance.collection('people').doc(uId).set(newPeople);
    } catch (e) {
      throw Exception('Error actualizando persona con ID $uId: $e');
    }
  }

  @override
  Future<void> deletePeople(String uId) async {
    try{
      await FirebaseFirestore.instance.collection('people').doc(uId).delete();
    } catch (e) {
      throw Exception('Error eliminando persona con ID $uId: $e');
    }
  }

  @override
  Future<String?> uploadImage(File image) async {
    try {
      // Obtener el nombre del archivo
      final String nameFile = image.path.split('/').last;
      // Referencia al archivo en Firebase Storage
      final Reference ref = FirebaseStorage.instance.ref().child('yape').child(nameFile);  
      // Subir el archivo a Firebase Storage
      final UploadTask uploadTask = ref.putFile(image);     
      // Esperar a que se complete la subida
      final TaskSnapshot snapshot = await uploadTask;
      // Comprobar si la subida fue exitosa
      if (snapshot.state == TaskState.success) {
        // Obtener la URL de descarga del archivo
        final String downloadUrl = await ref.getDownloadURL();
        return downloadUrl;
      } else {
        return null; // Subida fallida
      }
    } catch (e) {
      // Manejo de errores, por ejemplo, conexión fallida o error en Firebase
      throw Exception('Error subiendo imagen: $e');
    }
  }
}