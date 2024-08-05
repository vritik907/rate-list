import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rate_list/homepage/list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Listpage extends StatefulWidget {
  final List<RateItem> rateList;
  final Function(int) onDelete;
  final Function(int) onEdit;

  Listpage({
    required this.rateList,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<Listpage> createState() => _ListpageState();
}

class _ListpageState extends State<Listpage> {
  late List<RateItem> filteredList;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _loadItems();
    filteredList = widget.rateList;
    _searchController = TextEditingController();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? itemList = prefs.getStringList('items');
    if (itemList != null) {
      setState(() {
        widget.rateList.clear();
        widget.rateList.addAll(itemList.map((item) => RateItem.fromJson(json.decode(item))));
        filteredList = widget.rateList;
      });
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> itemList = widget.rateList.map((item) => json.encode(item.toJson())).toList();
    prefs.setStringList('items', itemList);
  }

  void _deleteItem(int index) {
    setState(() {
      widget.rateList.removeAt(index);
      filteredList = widget.rateList;
    });
    _saveItems();
  }

    void _editItem(int index) {
    setState(() {
      widget.onEdit(index);
      filteredList = widget.rateList;
    });
    _saveItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _searchItem(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          if (filteredList.isEmpty)
            Center(
              child: Text('No items found.'),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteItem(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editItem(index);
                          },
                        ),
                        Icon(Icons.currency_rupee_sharp),
                      ],
                    ),
                    title: Text(
                      '${filteredList[index].itemName} - ${filteredList[index].rate.toStringAsFixed(1)} per/kg',
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _searchItem(String value) {
    setState(() {
      if (value.isEmpty) {
        filteredList = widget.rateList;
      } else {
        filteredList = widget.rateList
            .where((item) => item.itemName.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
