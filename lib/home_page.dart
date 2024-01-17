import 'package:flutter/material.dart';
import 'package:flutter_crud_1/database.dart';
import 'package:flutter_crud_1/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _numberEditingController =
      TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Contacts List'),
      ),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayTextAddDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Column(
      children: [
        _messagesListView(),
      ],
    ));
  }

  Widget _messagesListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
          stream: _databaseService.getContact(),
          builder: (context, snapshot) {
            List contact = snapshot.data?.docs ?? [];
            if (contact.isEmpty) {
              return const Center(
                child: Text("Add to Contact"),
              );
            }
            return ListView.builder(
              itemCount: contact.length,
              itemBuilder: (context, index) {
                DatabaseContact database = contact[index].data();
                String databaseId = contact[index].id;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: ListTile(
                    tileColor: Theme.of(context).colorScheme.primaryContainer,
                    title: Text(database.name),
                    subtitle: Text(database.number.toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _displayTextEditDialog(databaseId, database);
                      },
                    ),
                    onLongPress: () {
                      _databaseService.deleteContact(databaseId);
                    },
                  ),
                );
              },
            );
          }),
    );
  }

  void _displayTextEditDialog(
      String databaseId, DatabaseContact existingContact) async {
    _nameEditingController.text = existingContact.name;
    _numberEditingController.text = existingContact.number;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierColor: Colors.black.withOpacity(0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 40,
              left: 50,
              right: 50,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(controller: _nameEditingController),
                SizedBox(height: 20),
                Text(
                  "Number",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(controller: _numberEditingController),
                SizedBox(height: 20),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  child: const Text('OK'),
                  onPressed: () {
                    DatabaseContact updatedContact = DatabaseContact(
                      name: _nameEditingController.text,
                      number: _numberEditingController.text,
                    );
                    _databaseService.updateContact(databaseId, updatedContact);

                    Navigator.pop(context);
                    _nameEditingController.clear();
                    _numberEditingController.clear();
                  },
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  void _displayTextAddDialog() async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierColor: Colors.black.withOpacity(0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 40,
              left: 50,
              right: 50,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(controller: _nameEditingController),
                SizedBox(height: 20),
                Text(
                  "Number",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(controller: _numberEditingController),
                SizedBox(height: 20),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Colors.white,
                  child: const Text('OK'),
                  onPressed: () {
                    DatabaseContact newContact = DatabaseContact(
                      name: _nameEditingController.text,
                      number: _numberEditingController.text,
                    );
                    _databaseService.addContact(newContact);

                    Navigator.pop(context);
                    _nameEditingController.clear();
                    _numberEditingController.clear();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
