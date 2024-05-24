import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moo/services/firebase_service_Animal.dart';
import 'package:moo/services/firebase_service_Batch.dart';

class AddAnimal extends StatefulWidget {
  final String lote;
  final String finca;
  final int dataLength;

  const AddAnimal({
    Key? key,
    required this.finca,
    required this.lote,
    required this.dataLength,
  }) : super(key: key);

  @override
  State<AddAnimal> createState() => _AddAnimalState();
}

class _AddAnimalState extends State<AddAnimal> {
  final TextEditingController _nombreController =
      TextEditingController(text: '');
  final TextEditingController _razaController = TextEditingController(text: '');
  final TextEditingController _fechaController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime(
          DateTime.now().year - 3, DateTime.now().month, DateTime.now().day)));

  String? imageUrl;

  @override
  void dispose() {
    _nombreController.dispose();
    _razaController.dispose();
    _fechaController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  DateTime dateTime = DateTime.now();

  void _selectImageSource() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Cámara'),
                onTap: () async {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Galería'),
                onTap: () async {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    String fileName = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDireImages = referenceRoot.child('images');
    Reference referenceImageUpload = referenceDireImages.child(fileName);

    try {
      await referenceImageUpload.putFile(File(pickedFile.path));
      String downloadUrl = await referenceImageUpload.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
    } catch (e) {
      // Manejo de errores
    }
  }

  List<String> razas = [
    'Gyroland F1 (Gyr + Holstein)',
    'Simmbrah F1 (Simmental + Brahman)',
    'Brahamoland F1 (Brahman + Holstein)',
    // Add other breeds here
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Agregar Animal'),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                enableSuggestions: true,
                controller: _nombreController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingrese el nombre del Animal',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el nombre del animal';
                  }
                  return null;
                },
              ),
              DropdownSearch<String>(
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Raza",
                    hintText: "Selecciona una Raza",
                  ),
                ),
                items: razas,
                selectedItem: _razaController.text, // Set the initial selection
                onChanged: (String? selectedRaza) {
                  setState(() {
                    _razaController.text =
                        selectedRaza ?? ''; // Update the controller value
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      DateTime currentDate = DateTime.now();
                      DateTime initialDate = DateTime(currentDate.year - 3,
                          currentDate.month, currentDate.day);
                      DateTime minDate = DateTime(currentDate.year - 15,
                          currentDate.month, currentDate.day);
                      DateTime maxDate = DateTime(currentDate.year - 3,
                          currentDate.month, currentDate.day);

                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => SizedBox(
                          height: 250,
                          child: CupertinoDatePicker(
                            backgroundColor: Colors.white,
                            initialDateTime: initialDate,
                            minimumDate: minDate,
                            maximumDate: maxDate,
                            minimumYear: 2009,
                            maximumYear: 2021,
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                dateTime = newTime;
                                _fechaController.text =
                                    DateFormat('yyyy-MM-dd').format(newTime);
                              });
                            },
                            use24hFormat: true,
                            mode: CupertinoDatePickerMode.date,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_month),
                  ),
                ),
                readOnly: true,
                controller: _fechaController,
                keyboardType: TextInputType.datetime,
              ),
              IconButton(
                onPressed: _selectImageSource,
                icon: const Icon(Icons.add_photo_alternate),
              ),
              const Text(
                'Opcional',
                style: TextStyle(fontSize: 13, color: Colors.blue),
              ),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      const Text(
                        'Selccionar Novilla',
                        style: TextStyle(color: Colors.green, fontSize: 16),
                      ),
                      IconButton(onPressed: (){},
                       icon: const FaIcon(Icons.info,color: Colors.lightBlueAccent,),
                       tooltip: 'Aqui puedes seleccionar una novilla criada aqui',
                       
                       
                       ),
                       
                    ],
                  )),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Procesando Datos')),
              );
              DateTime fechaNacimiento = DateTime.parse(_fechaController.text);

              await addAnimal(
                      _nombreController.text,
                      _razaController.text,
                      fechaNacimiento,
                      widget.lote,
                      widget.finca,
                      imageUrl,
                      true)
                  .then((_) {
                setState(() {
                  Navigator.pop(context);
                  updateBatchLenght(widget.lote, widget.dataLength + 1);
                });
              });
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
