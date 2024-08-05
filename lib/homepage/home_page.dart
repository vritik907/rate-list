import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rate_list/homepage/list.dart';

class GeneratePage extends StatefulWidget {
  final List<RateItem> rateList;

  GeneratePage({required this.rateList});

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  late TextEditingController _itemNameController;
  late TextEditingController _rateController;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _rateController = TextEditingController();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? itemList = prefs.getStringList('items');
    if (itemList != null) {
      if (mounted) {
        setState(() {
          widget.rateList.clear();
          widget.rateList.addAll(itemList.map((item) => RateItem.fromJson(json.decode(item))));
        });
      }
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> itemList = widget.rateList.map((item) => json.encode(item.toJson())).toList();
    prefs.setStringList('items', itemList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _itemNameController,
                  decoration: InputDecoration(labelText: 'Enter item name'),
                ),
                TextField(
                  controller: _rateController,
                  decoration: InputDecoration(labelText: 'Enter rate'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              String itemName = _itemNameController.text;
              double rate = double.tryParse(_rateController.text) ?? 0.0;

              if (itemName.isNotEmpty && rate > 0) {
                setState(() {
                  widget.rateList.add(RateItem(itemName: itemName, rate: rate));
                  _itemNameController.clear();
                  _rateController.clear();
                });
                _saveItems(); // Save items to SharedPreferences after adding
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter valid item name and rate')),
                );
              }
            },
            tooltip: 'Add to Rate List',
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _rateController.dispose();
    super.dispose();
  }
}
