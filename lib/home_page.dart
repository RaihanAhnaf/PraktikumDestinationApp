import 'package:destination_app/detail_screen.dart';
import 'package:destination_app/edit_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tiketController = TextEditingController();
  final TextEditingController _jamController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final CollectionReference _destinations =
  FirebaseFirestore.instance.collection('destination');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _imageController.text = documentSnapshot['image'];
      _nameController.text = documentSnapshot['name'];
      _descriptionController.text = documentSnapshot['description'];
      _tiketController.text = documentSnapshot['tiket'].toString();
      _jamController.text = documentSnapshot['jam'];
      _locationController.text = documentSnapshot['location'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: 'Image'),
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  controller: _tiketController,
                  decoration: const InputDecoration(labelText: 'Harga Tiket'),
                ),
                TextField(
                  controller: _jamController,
                  decoration: const InputDecoration(labelText: 'Jam Operasional'),
                ),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Lokasi Tempat'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? image = _imageController.text;
                    final String? name = _nameController.text;
                    final String? description = _descriptionController.text;
                    final double? tiket = double.tryParse(_tiketController.text);
                    final String? jam = _jamController.text;
                    final String? location = _locationController.text;
                    if (image != null &&
                        name != null &&
                        description != null &&
                        tiket != null &&
                        jam != null &&
                        location != null)
                    {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _destinations.add({
                          "image": image,
                          "name": name,
                          "description": description,
                          "tiket": tiket,
                          "jam": jam,
                          "location": location
                        });
                      }

                      if (action == 'update') {
                        // Update the product
                        await _destinations.doc(documentSnapshot!.id).update({
                          "image": image,
                          "name": name,
                          "description": description,
                          "tiket": tiket,
                          "jam": jam,
                          "location": location
                        });
                      }

                      // Clear the text fields
                      _imageController.text = '';
                      _nameController.text = '';
                      _descriptionController.text = '';
                      _tiketController.text = '';
                      _jamController.text = '';
                      _locationController.text = '';

                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  // Deleteing a product by id
  Future<void> _deleteProduct(String productId) async {
    await _destinations.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Destinasi berhasil di hapus')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indonesian Destination'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context){
                  return const EditPage();
                }),
              );
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: _destinations.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
            if (streamSnapshot.hasData){
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index){
                    final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                    return InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, DetailScreen.routeName,
                          arguments: documentSnapshot);
                      },
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                                child: Image.network(documentSnapshot['image']),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Text(
                                            documentSnapshot['name'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    documentSnapshot['location'],
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      // Add new Destination
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}