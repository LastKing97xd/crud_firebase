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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      crudProviderRead = context.read<CrudProvider>();
    });
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
        if (crudProvider.imageUpload == null) {
          // Mostrar un mensaje al usuario si no se ha seleccionado una imagen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, selecciona una imagen primero.')),
          );
        } else {
          final newImageUrl = await crudProvider.uploadImage(crudProvider.imageUpload!);
          await crudProvider.updatePeople(widget.id, nameController.text, newImageUrl);
        }
        /*if(widget.url != null){
          await crudProvider.updatePeople(widget.id, nameController.text , '');
        }*/
        if (context.mounted) {
            context.pop(); // Volver a la pantalla anterior
          }
      },
      isLoading: crudProvider.isLoading,
    );
  }
}


/*class EditScreen extends StatefulWidget {
  
  final String id;
  final String nameId;

  const EditScreen({super.key, required this.nameId, required this.id});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController nameController = TextEditingController(text: '');  

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final crudProvider = context.watch<CrudProvider>();
    final sized = MediaQuery.of(context).size;
    
    nameController.text = widget.nameId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit - FireStore'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async{
                await crudProvider.updatePeople(widget.id,nameController.text);
                if (context.mounted) context.pop();
              },         
              child: const Text('Actualizar')
            ),
            const SizedBox(height: 10,),
            _buildImageDisplay(sized, crudProvider.imageUpload),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async {
                await crudProvider.getImage();
              }, 
              child: const Text('Seleccionar Imagen')
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async {
                final uploader = await crudProvider.uploadImage(crudProvider.imageUpload!);
                //if(uploader){
                  if(context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Imagen subida correctamente'))
                    );
                  }
                //}
              }, 
              child: const Text('Subir a Firebase')
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImageDisplay(Size size, File? imageUpload) {
    final double containerHeight = size.height * 0.6;

    return Container(
      height: containerHeight, // Tamaño fijo del contenedor
      width: double.infinity,  // Ocupa todo el ancho
      color: Colors.grey[300], // Color de fondo para placeholder
      child: imageUpload != null 
        ? Image.file(
            imageUpload,
            height: containerHeight,
            width: double.infinity,
            fit: BoxFit.cover, // Ajusta la imagen para cubrir el contenedor
          )
        : const Icon(Icons.image, size: 100, color: Colors.grey),
    );
  }
}*/