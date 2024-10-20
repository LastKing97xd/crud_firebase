
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ui_flutter/domain/entities/people.dart';
import 'package:ui_flutter/presentation/screens/providers/crud_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

@override
  void initState() {
    super.initState();
    // Se ejecuta después de que el widget se haya construido completamente. Llama a getPeople después de la fase de construcción inicial - para la primera carga
    //después de la primera fase de construcción, momento en el cual el widget ya está completamente montado y puedes acceder al context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CrudProvider>().getPeople();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('FireStore'),
        centerTitle: true,
      ),
      body: _PeopleList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/addScreen');     
        }, 
        child: const Icon(Icons.add)
      ),
    );
  }
}

class _PeopleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final crudProvider = context.watch<CrudProvider>();

    if (crudProvider.isLoading) {
      return Center(child: Column(
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
                fontSize:16,         // Ajustar el tamaño de fuente
                fontWeight: FontWeight.bold,  // Hacer el texto más claro y visible
              ),
            )
          ]
        ),);
    }

    if (crudProvider.errorMessage != null) {
      return Center(child: _RetryView(crudProvider: crudProvider));
    }

    if (crudProvider.peopleProvider.isEmpty) {
      return const Center(child: Text('No hay personas disponibles.'));
    }

    return ListView.builder(
      itemCount: crudProvider.peopleProvider.length,
      itemBuilder: (context, index) {
        final people = crudProvider.peopleProvider[index];
        return _DimissibleWidget(crudProvider: crudProvider, people: people);
      },
    );
  }
}

class _RetryView extends StatelessWidget {
  
  const _RetryView({
    required this.crudProvider,
  });

  final CrudProvider crudProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, color: Colors.red, size: 64),
        const SizedBox(height: 16),
        Text(crudProvider.errorMessage!, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Intentar cargar los datos nuevamente
            crudProvider.getPeople();
          },
          child: const Text('Reintentar'),
        ),
      ],
    );
  }
}

class _DimissibleWidget extends StatelessWidget {
  const _DimissibleWidget({
    required this.crudProvider,
    required this.people,
  });

  final CrudProvider crudProvider;
  final People people;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) async {
        await crudProvider.deletePeople(people.id);
      },
      confirmDismiss: (_) async {
        bool result = false;
        result = await dialogValidation(context);
        return result;
      },
      background: Container(
        color: Colors.red,
        child: const Icon(Icons.delete),
      ),
      direction: DismissDirection.startToEnd,
      key: ValueKey(people.id),
      child: ListTile(
        title: Text(people.name),
        subtitle: Text(people.url),
        onTap: () {
          context.push('/editScreen/${people.id}/${people.name}', extra: people.url);     
        },
      ),
    );
  }

  Future<dynamic> dialogValidation(BuildContext context) {
    return showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: Text('Estas seguro de eliminar a ${people.name} ?'),
            actions: [
              TextButton(
                onPressed: () {
                  return context.pop(true);
                }, 
                child: const Text('Aceptar')
              ),
              TextButton(
                onPressed: () {
                  return context.pop(false);
                }, 
                child: const Text('Cancelar')
              )
  
            ],
          );
        },
      );
  }
}


