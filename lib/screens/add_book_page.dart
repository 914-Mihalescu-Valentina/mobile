import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class AddBookPage extends StatefulWidget {
  final Function(String, String, String, int, int) onSave;
  const AddBookPage({super.key, required this.onSave});

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController authorController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final int defaultReservedValue = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Book'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Book Title'),
              ),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Book Author'),
              ),
              TextField(
                controller: genreController,
                decoration: const InputDecoration(labelText: 'Book Genre'),
              ),
              TextField(
                controller: quantityController,
                decoration:
                const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              Text(
                defaultReservedValue.toString(),
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              const SizedBox(height: 8.0),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_validateForm()) {
                    ProgressDialog pr = ProgressDialog(context);
                    pr.style(message: 'Loading...');

                    await pr.show();

                    await widget.onSave(
                      titleController.text,
                      authorController.text,
                      genreController.text,
                      int.parse(quantityController.text),
                      defaultReservedValue,
                    );

                    await pr
                        .hide()
                        .then((_) => Navigator.pop(context));
                  }
                },
                child: const Text('Add Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    if (titleController.text.isEmpty ||
        authorController.text.isEmpty ||
        genreController.text.isEmpty ||
        quantityController.text.isEmpty
        ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
      return false;
    }
    return true;
  }
}
