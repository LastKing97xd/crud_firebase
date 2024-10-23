
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:ui_flutter/domain/domains.dart';
import 'package:ui_flutter/infrastructure/infrastructures.dart';

class CrudProvider extends ChangeNotifier{

  final LocalStorageRepository localStorageRepository;
  List<People> peopleProvider = [];
  File? imageUpload;
  bool isLoading = true;
  String? errorMessage;

  CrudProvider({required this.localStorageRepository});

  Future<void> getPeople() async { 
    //se declara valores para limpiar los anteriores debido al Reintentar
    isLoading = true;
    errorMessage = null;
    notifyListeners();  // Para manejar el reintentar
    try{
      final people = await localStorageRepository.getPeople();
      //await Future.delayed(const Duration(seconds: 8));
      peopleProvider = people;
    } catch (e) {
      errorMessage = 'Error obteniendo personas de Firebase';
    } finally {
      isLoading = false;  // Finalizar el estado de carga
      notifyListeners();
    }
  }

  Future<void> addPeople(String name, String url) async {
    //False por uploadImage
    isLoading = true;  // Iniciar la carga
    errorMessage = null;
    notifyListeners(); 
    try{
      final String newId = await localStorageRepository.addPeople(PeopleResponse(name: name, url: url).toJson());  
      //await Future.delayed(const Duration(seconds: 3));
      final newPerson = People(id: newId, name: name, url: url);  // Usamos el ID generado por Firebase
      peopleProvider.add(newPerson);  // Agregamos el nuevo registro a la lista local
    } catch (e) {
      errorMessage = 'Error agregando persona';
    } finally {
      isLoading = false;
      notifyListeners();  // Notificar los cambios de estado
    }
  }

  Future<void> updatePeople(String uId, String newName, String? imageUrl) async {
    try{  
      await localStorageRepository.updatePeople( uId, PeopleResponse(name: newName, url: imageUrl).toJson());
      int index = peopleProvider.indexWhere((person) => person.id == uId);
      // Si la persona existe en la lista, actualizarla localmente
      if (index != -1) {
        peopleProvider[index] = People(id: uId, name: newName, url: imageUrl ?? peopleProvider[index].url);
        notifyListeners();
      }  // Notificar a la UI que los datos han cambiado
    } catch (e) {
      //print('Error actualizando persona: $e');
    }
  }

  Future<void> deletePeople(String uId) async {
    try{
      await localStorageRepository.deletePeople( uId);
      // Eliminar de la lista local
      peopleProvider.removeWhere((value) => value.id == uId);
      notifyListeners();
    } catch (e) {
      //print('Error eliminando persona: $e');
    }
  }

  Future<void> getImage() async {
    try{
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if(pickedImage != null)
      {
        imageUpload = File(pickedImage.path);
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Error seleccionando imagen';
    }
  }

  Future<String?> uploadImage(File image) async {
    //getPeople deja isloading en false
    isLoading = true;
    notifyListeners();
    try{
      final String? downloadUrl  = await localStorageRepository.uploadImage(image);
      return downloadUrl;
    } catch (e) {
      //print('Error subiendo imagen: $e');
      return null;
    } finally {
      isLoading = false;  // Asegurarse de finalizar la carga
      notifyListeners();  // Notificar al finalizar la operación
    }
  }
}