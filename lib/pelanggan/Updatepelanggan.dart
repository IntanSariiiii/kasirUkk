
import 'package:flutter/material.dart';
import 'package:kasir/home.dart';
import 'package:kasir/pelanggan/indexpelanggan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPelanggan extends StatefulWidget {
  final int pelangganid;

  const EditPelanggan({super.key, required this.pelangganid});

  @override
  State<EditPelanggan> createState() => _EditPelangganState();
}

class _EditPelangganState extends State<EditPelanggan> {
  final _nmplg = TextEditingController();
  final _alamat = TextEditingController();
  final _notlp = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadPelangganData();
  }

  // Fungsi untuk memuat data pelanggan berdasarkan ID
  Future<void> _loadPelangganData() async {
    final data = await Supabase.instance.client
        .from('pelanggan')
        .select()
        .eq('pelangganid', widget.pelangganid)
        .single();

    setState(() {
      _nmplg.text = data['namapelanggan'] ?? '';
      _alamat.text = data['alamat'] ?? '';
      _notlp.text = data['nomortelepon'] ?? '';
    });
  }

// EditPelanggan.dart
Future<void> updatePelanggan() async {
  if (_formKey.currentState!.validate()) {
    // Melakukan update data pelanggan ke database
    await Supabase.instance.client.from('pelanggan').update({
      'namapelanggan': _nmplg.text,
      'alamat': _alamat.text,
      'nomortelepon': _notlp.text,
    }).eq('pelangganid', widget.pelangganid);

    // Navigasi ke PelangganTab setelah update, dengan menghapus semua halaman sebelumnya dari stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => PelangganTab()),
      (route) => false, // Hapus semua halaman sebelumnya
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pelanggan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nmplg,
                decoration: const InputDecoration(
                  labelText: 'nama pelanggan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _alamat,
                decoration: const InputDecoration(
                  labelText: 'alamat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notlp,
                decoration: const InputDecoration(
                  labelText: 'nomor telepon',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  onPressed: updatePelanggan,
                  child: const Text('Perbaruhi',style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}