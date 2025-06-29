import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/store.dart';
import '../state/actions.dart';

class GeneratorDetailScreen extends StatefulWidget {
  final String id;
  final Map<String, dynamic>? details; // Receive details from parent

  const GeneratorDetailScreen({Key? key, required this.id, this.details});

  @override
  State<GeneratorDetailScreen> createState() => _GeneratorDetailScreenState();
}

class _GeneratorDetailScreenState extends State<GeneratorDetailScreen> {
  Map<String, dynamic>? _details;
  bool _isEditMode = false;

  // Form controllers
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _selectedBirthday;

  @override
  void initState() {
    super.initState();
    // Initialize with details from parent
    _details = widget.details;
  }

  // Initialize controllers with existing data
  void _initializeControllers() {
    if (_details != null) {
      _nameController.text = _details!['name'] ?? '';
      _lastNameController.text = _details!['lastName'] ?? '';
      _ageController.text = _details!['age']?.toString() ?? '';
      _addressController.text = _details!['address'] ?? '';
      _selectedBirthday =
          _details!['birthday'] != null
              ? DateTime.parse(_details!['birthday'])
              : null;
    }
  }

  // Toggle edit mode
  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (_isEditMode) {
        _initializeControllers();
      }
    });
  }

  // Save updated details
  void _saveDetails() {
    _details ??= {};

    final updatedDetails = {
      'id': widget.id,
      'name': _nameController.text,
      'lastName': _lastNameController.text,
      'age':
          _ageController.text.isNotEmpty
              ? int.parse(_ageController.text)
              : null,
      'address': _addressController.text,
      'birthday': _selectedBirthday?.toIso8601String(),
      'title': '${_nameController.text} ${_lastNameController.text}',
    };

    setState(() {
      _details = updatedDetails;
      _isEditMode = false;
    });

    Provider.of<AppStore>(
      context,
      listen: false,
    ).dispatch(UpdateTemplateAction(widget.id, updatedDetails));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Details updated for ${_details!['name']} ${_details!['lastName']}',
        ),
      ),
    );

    // In a real app, you would save the updated details back to the parent
    // For example, using a callback function passed from the parent
  }

  // Select birthday
  Future<void> _selectBirthday() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    // Check if context is still mounted before using it
    if (!context.mounted) return;

    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Template Details #${widget.id}'),
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.cancel : Icons.edit),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _details == null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Template #${widget.id} Details',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('No details available for this template'),
                    ],
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child:
                          _isEditMode ? _buildEditForm() : _buildViewDetails(),
                    ),
                    if (_isEditMode)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveDetails,
                            child: const Text('Save Changes'),
                          ),
                        ),
                      ),
                  ],
                ),
      ),
    );
  }

  // View-only mode
  Widget _buildViewDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            'Name',
            '${_details?['name']} ${_details?['lastName']}',
          ),
          _buildDetailRow(
            'Age',
            _details?['age']?.toString() ?? 'Not specified',
          ),
          _buildDetailRow(
            'Birthday',
            _details?['birthday'] != null
                ? DateTime.parse(_details!['birthday']).toString().split(' ')[0]
                : 'Not specified',
          ),
          _buildDetailRow('Address', _details?['address'] ?? 'Not specified'),
        ],
      ),
    );
  }

  // Edit mode form
  Widget _buildEditForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ageController,
            decoration: const InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _selectBirthday,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedBirthday != null
                        ? _selectedBirthday!.toString().split(' ')[0]
                        : 'Select Birthday',
                    style: TextStyle(
                      color:
                          _selectedBirthday != null
                              ? Colors.black
                              : Colors.grey,
                    ),
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
