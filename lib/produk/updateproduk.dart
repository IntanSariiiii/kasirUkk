import 'package:flutter/material.dart';
import 'package:kasir/home.dart';
import 'package:kasir/produk/indexproduk.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Updateproduk extends StatefulWidget {
  final int produkid;
  const Updateproduk({super.key, required this.produkid});

  @override
  State<Updateproduk> createState() => _UpdateprodukState();
}

class _UpdateprodukState extends State<Updateproduk> {
  final _nmprd = TextEditingController();
  final _harga = TextEditingController();
  final _stok = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _updateproduk();
  }
  Future<void> _updateproduk() async {
    try{
      final data = await Supabase.instance.client.from('kasirproduk').select().eq('produkid', widget.produkid).single();
      setState(() {
        _nmprd.text = data['namaproduk'] ?? '';
        _harga.text = data['harga']?.toString() ?? '';
        _stok.text = data['stok']?.toString() ?? '';
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error : $error')),
      );
    }
  }

  Future<void> updateproduk() async {
    if (_formKey.currentState!.validate()) {
      await Supabase.instance.client.from('kasirproduk').update({
        'namaproduk': _nmprd.text,
        'harga': _harga.text,
        'stok': _stok.text
      }).eq('produkid', widget.produkid);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ProdukTab()),
      (route) => false
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Produk'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nmprd,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder()
                ),
                validator: (value) {
                  if (value == null || value.isEmpty){
                    return "tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _harga,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty){
                    return 'tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _stok,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  onPressed: updateproduk,
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