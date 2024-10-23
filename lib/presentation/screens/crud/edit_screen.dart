import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ui_flutter/presentation/screens/providers/crud_provider.dart';
import 'package:ui_flutter/presentation/screens/widgets/crud_widget.dart';

class EditScreen extends StatefulWidget {
  final String id;
  final String nameId;
  final String url;

  const EditScreen({super.key, required this.nameId, required this.id, required this.url});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController nameController = TextEditingController();
  late CrudProvider crudProviderRead;
  
  @override
  void initState() {
    super.initState();
    nameController.text = widget.nameId; // Inicializar el texto del controlador
  }

  @override
  void didChangeDependencies() {
    //Te permite acceder al context de forma segura después de que el widget se ha montado. Al guardar una referencia a ese Provider en didChangeDependencies(), puedes usar esa referencia más adelante.
    super.didChangeDependencies();
    crudProviderRead = context.read<CrudProvider>(); 
  }

  @override
  void dispose() {
    crudProviderRead.imageUpload = null;
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final crudProvider = context.watch<CrudProvider>();
  
    return CRUDWidget(
      appBarTitle: 'Edit - FireStore',
      nameController: nameController,
      onImageSelect: () async {
        await crudProvider.getImage();
      },
      imageUpload: crudProvider.imageUpload,
      imageUrl: widget.url,
      onSavePressed: () async {
        String? updatedImageUrl = widget.url; // Inicializar con la URL existente
        // Si se seleccionó una nueva imagen, subirla y obtener la nueva URL
        if (crudProvider.imageUpload != null) {
          updatedImageUrl = await crudProvider.uploadImage(crudProvider.imageUpload!);
        }
        // Actualizar la persona con el nuevo nombre y la URL de la imagen (sea la nueva o la existente)
        await crudProvider.updatePeople(widget.id, nameController.text, updatedImageUrl);
        // Volver a la pantalla anterior si el contexto sigue montado
        if (context.mounted) {
          context.pop(); 
        }
      },
      isLoading: crudProvider.isLoading,
    );
  }
}
