
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CRUDWidget extends StatelessWidget {
  final TextEditingController nameController;
  final String appBarTitle;
  final VoidCallback onSavePressed;
  final VoidCallback onImageSelect;
  final File? imageUpload;
  final String? imageUrl;
  final bool? isLoading;

  const CRUDWidget({
    super.key,
    required this.nameController,
    required this.appBarTitle,
    required this.onSavePressed,
    required this.onImageSelect,
    this.imageUpload,
    this.imageUrl, 
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final sized = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Ingrese un nombre',
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ImageView(sized: sized, imageUpload: imageUpload,imageUrl: imageUrl,),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: onImageSelect,
                    child: const Text('Seleccionar Imagen'),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: onSavePressed,
                    child: const Text('Guardar'),
                  ),
                  /*ElevatedButton(
                    onPressed: onImageUpload,
                    child: const Text('Subir a Firebase')
                  )*/
                ],
              ),
            ),
          ),
          if (isLoading!) 
          const _Loading(),
        ]
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Asegura que el Column ocupe solo el espacio necesario
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.inkDrop(
              color: Colors.white,
              size: 60,
            ),
            const SizedBox(height: 20,),
            const Text('Cargando...',
              style: TextStyle(
                color: Colors.white,  // Color blanco para asegurar visibilidad
                fontSize: 16,         // Ajustar el tamaño de fuente
                fontWeight: FontWeight.bold,  // Hacer el texto más claro y visible
              ),
            )
          ]
        ),
      ),
    );
  }
}

class _ImageView extends StatelessWidget {
  const _ImageView({
    required this.sized,
    required this.imageUpload, 
    required this.imageUrl,
  });

  final Size sized;
  final File? imageUpload;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: sized.height * 0.6,
        width: double.infinity,
        color: Colors.grey,
        child: imageUpload != null
          ? Image.file(
              imageUpload!,
              height: sized.height * 0.6,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          : imageUrl != null
            ? Image.network(
                imageUrl!,
                height: sized.height * 0.6,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // La imagen ha terminado de cargarse
                  }
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,  // Asegura que el Column ocupe solo el espacio necesario
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.inkDrop(
                          color: Colors.white,
                          size: 60,
                        ),
                        const SizedBox(height: 20,),
                        const Text('Cargando...',
                          style: TextStyle(
                            color: Colors.white,  // Color blanco para asegurar visibilidad
                            fontSize: 16,         // Ajustar el tamaño de fuente
                            fontWeight: FontWeight.bold,  // Hacer el texto más claro y visible
                          ),
                        )
                      ]
                    ),
                  );
                },
              )
            : const Icon(Icons.image, size: 100, color: Colors.black),
      ),
    );
  }
}

