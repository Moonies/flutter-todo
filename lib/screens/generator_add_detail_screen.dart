import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../state/store.dart';
import '../state/actions.dart';

class GeneratorAddDetailScreen extends StatefulWidget {
  final String id;
  const GeneratorAddDetailScreen({super.key, required this.id});

  @override
  State<GeneratorAddDetailScreen> createState() => _GeneratorAddDetailState();
}

class _GeneratorAddDetailState extends State<GeneratorAddDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _lastName;
  int? _age;
  DateTime? _birthday;
  String? _address;

  final TextEditingController _birthdayController = TextEditingController();

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _birthday = picked;
        _birthdayController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submit() {
    // Validate form
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final result = {
        'id': widget.id,
        'title': '$_name  $_lastName',
        'name': _name,
        'lastName': _lastName,
        'age': _age,
        'birthday': _birthday?.toIso8601String(),
        'address': _address,
      };
      final store = Provider.of<AppStore>(context, listen: false);

      store.dispatch(AddTemplateAction(result));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added new template: ${result['name']} ${result['lastname']}',
          ),
        ),
      );

      context.pop(); // Return data to parent
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Details for Template ${widget.id}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Last Name *'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a last name';
                    }
                    return null;
                  },
                  onSaved: (value) => _lastName = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  onSaved:
                      (value) =>
                          _age =
                              value != null && value.isNotEmpty
                                  ? int.tryParse(value)
                                  : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _birthdayController,
                  decoration: InputDecoration(
                    labelText: 'Birthday',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _pickDate(context),
                    ),
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  maxLines: 3,
                  onSaved: (value) => _address = value,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
