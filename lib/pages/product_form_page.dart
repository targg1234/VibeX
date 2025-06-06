import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../blocs/product_bloc.dart';
import '../blocs/product_event.dart';
import '../models/product.dart';

class ProductFormPage extends StatefulWidget {
  final VoidCallback onSuccess;
  final Product? product;
  final String? initialImagePath;

  const ProductFormPage({
    super.key,
    this.product,
    this.initialImagePath,
    required this.onSuccess,
  });

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  List<String> _avatarList = [];
  String? _selectedAvatar;
  bool _isLoadingAvatars = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');

    if (widget.product?.avatar != null &&
        widget.product!.avatar!.startsWith('http')) {
      _selectedAvatar = widget.product!.avatar;
    }

    _fetchAvatars();
  }

  Future<void> _fetchAvatars() async {
    setState(() => _isLoadingAvatars = true);

    try {
      final response = await http.get(
        Uri.parse('https://6832fa3cc3f2222a8cb483c3.mockapi.io/status'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        final avatars = data
            .map((item) => item['avatar'] as String? ?? '')
            .where((url) => url.isNotEmpty)
            .toSet()
            .toList();

        setState(() {
          _avatarList = avatars;
          if (_selectedAvatar != null &&
              !_avatarList.contains(_selectedAvatar)) {
            _selectedAvatar = null;
          }
        });
      } else {
        debugPrint('Failed to fetch avatars: ${response.statusCode}');
        _showSnackBar('Gagal memuat avatar default');
      }
    } catch (e) {
      debugPrint('Avatar fetch error: $e');
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() => _isLoadingAvatars = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedAvatar == null || _selectedAvatar!.isEmpty) {
      _showSnackBar('Avatar tidak boleh kosong');
      return;
    }

    final newProduct = Product(
      id: widget.product?.id ?? '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      avatar: _selectedAvatar!,
      createdAt: DateTime.now().toIso8601String(),
    );

    final productBloc = context.read<ProductBloc>();
    if (widget.product == null) {
      productBloc.add(AddProductEvent(newProduct));
    } else {
      productBloc.add(UpdateProductEvent(widget.product!.id!, newProduct));
    }

    widget.onSuccess();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Status' : 'Tambah Status'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar Preview
              CircleAvatar(
                radius: 35,
                backgroundImage: _selectedAvatar != null
                    ? NetworkImage(_selectedAvatar!)
                    : null,
                child: _selectedAvatar == null
                    ? const Icon(Icons.person, size: 35)
                    : null,
              ),
              const SizedBox(height: 16),

              // Avatar Picker
              _isLoadingAvatars
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(),
                    )
                  : DropdownButtonFormField<String>(
                      value: _selectedAvatar,
                      decoration: const InputDecoration(
                        labelText: 'Pilih Avatar',
                        border: OutlineInputBorder(),
                      ),
                      items: _avatarList.map((url) {
                        return DropdownMenuItem(
                          value: url,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(url),
                                radius: 15,
                              ),
                              const SizedBox(width: 10),
                              Text('Avatar ${_avatarList.indexOf(url) + 1}'),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedAvatar = value),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Avatar harus dipilih'
                          : null,
                    ),
              const SizedBox(height: 16),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Deskripsi tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: Icon(isEdit ? Icons.save : Icons.send),
                  label: Text(isEdit ? 'Simpan' : 'Posting'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
