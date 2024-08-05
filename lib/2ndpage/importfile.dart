import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rate_list/homepage/list.dart';
import 'package:uni_links/uni_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImportManager {
  final Function(List<RateItem>) onImport;
  final Function() onSave;

  ImportManager({required this.onImport, required this.onSave});
void decodeAndImportList(String encodedString) {
  try {
    print("Decoding string: $encodedString");
    final jsonString = utf8.decode(base64Decode(encodedString));
    print("Decoded JSON string: $jsonString");
    final jsonList = json.decode(jsonString);
    print("Parsed JSON list: $jsonList");
    final newRateList = (jsonList as List).map((item) => RateItem.fromJson(item)).toList();
    print("Created new RateList: ${newRateList.length} items");
    onImport(newRateList);
    onSave();
  } catch (e) {
    print("Error decoding list: $e");
  }
}

 Future<void> initUniLinks() async {
  try {
    final initialUri = await getInitialUri();
    print("Initial URI: $initialUri"); 
    if (initialUri != null) {
      handleLink(initialUri);
    }
  } catch (e) {
    print('Error handling initial URI: $e');
  }

  uriLinkStream.listen((Uri? uri) {
    print("Received URI: $uri"); // Add this line
    if (uri != null) {
      handleLink(uri);
    }
  }, onError: (err) {
    print('Error processing incoming link: $err');
  });
}

void handleLink(Uri uri) {
  print("Handling link: $uri"); // Add this line
  String? encodedData;
  if (uri.path.startsWith('/import/')) {
    encodedData = uri.path.substring('/import/'.length);
  } else if (uri.host == 'import.app') {
    encodedData = uri.path.substring(1); // Remove leading '/'
  }

  if (encodedData != null) {
    print("Encoded data: $encodedData"); // Add this line
    decodeAndImportList(encodedData);
  } else {
    print("No encoded data found in the URI"); // Add this line
  }
}
}

// Example usage in a StatefulWidget:
class MyHomePage extends StatefulWidget {
  @override
  
  MyHomePageState createState() => MyHomePageState();

}

class MyHomePageState extends State<MyHomePage> {
  List<RateItem> rateList = [];
  late ImportManager importManager;

  @override
  void initState() {
    super.initState();
    importManager = ImportManager(
      onImport: (newList) {
        print("Importing new list: ${newList.length} items");
        setState(() {
          rateList.clear();
          rateList.addAll(newList);
        });
      },
      onSave: _saveItems,
    );
    importManager.initUniLinks();
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> itemList = rateList.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList('items', itemList);
  }
  
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text('My List'),
      ),
      body: rateList.isEmpty
          ? Center(child: Text('No items in the list'))
          : ListView.builder(
              itemCount: rateList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(rateList[index].itemName),
                  subtitle: Text('Rate: ${rateList[index].rate}'),
                );
              },
            ),
    );
  }
}