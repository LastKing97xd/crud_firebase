import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ui_flutter/presentation/screens/providers/crud_provider.dart';
import 'package:ui_flutter/presentation/screens/widgets/crud_widget.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController nameController = TextEditingController();
  //late porque se inicializará posteriormente en didChangeDependencies().
  late CrudProvider crudProviderRead; 

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
      appBarTitle: 'Add - FireStore',
      nameController: nameController,
      onImageSelect: () async { 
        await crudProvider.getImage();
      }, 
      imageUpload: crudProvider.imageUpload,
      onSavePressed: () async {
        if (nameController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, ingresa un nombre.')),
          );
          return;
        }
        if (crudProvider.imageUpload == null) {            
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, selecciona una imagen primero.')),
          );
          return;    
        } else {
          final url = await crudProvider.uploadImage(crudProvider.imageUpload!);
          await crudProvider.addPeople(nameController.text, url!);
          if (context.mounted) {
            context.pop(); // Volver a la pantalla anterior
          }
        }
      }, 
      isLoading: crudProvider.isLoading,
    );
  }
}



/*class AddScreen extends StatefulWidget {
  
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController nameController = TextEditingController(text: '');

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final crudProvider = context.read<CrudProvider>();
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add - FireStore'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Ingrese un nombre'
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async{
                await crudProvider.addPeople(nameController.text);
                //if (context.mounted) context.pop(true);
                if (context.mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${nameController.text} agregado')),
                  );
                }
              },         
              child: const Text('Guardar')
            )
          ],
        ),
      ),
    );
  }
}*/