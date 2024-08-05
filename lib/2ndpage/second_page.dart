import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rate_list/2ndpage/edit.dart';
import 'package:rate_list/2ndpage/importfile.dart';
import 'package:rate_list/homepage/list.dart';
import 'package:rate_list/2ndpage/listpage.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';


class FavoritesPage extends StatefulWidget {
  final List<RateItem> rateList;

  const FavoritesPage({Key? key, required this.rateList}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
   

    ImportManager(
    onImport: (newList) {
      print("Received new list in FavoritesPage: ${newList.length} items");
      setState(() {
        widget.rateList.clear();
        widget.rateList.addAll(newList);
      });
      _saveItems();
    },
    onSave: _saveItems,
  )
  .initUniLinks();

   _loadItems();
   
  
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? itemList = prefs.getStringList('items');
    if (itemList != null) {
      List<RateItem> updatedRateList = itemList.map((item) => RateItem.fromJson(json.decode(item))).toList();
      setState(() {
        widget.rateList.clear();
        widget.rateList.addAll(updatedRateList);
      });
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> itemList = widget.rateList.map((item) => json.encode(item.toJson())).toList();
    prefs.setStringList('items', itemList);
  }

  String encodeList() {
    final jsonList = widget.rateList.map((item) => item.toJson()).toList();
    final jsonString = json.encode(jsonList);
    return base64Encode(utf8.encode(jsonString));
  }

  

  void shareEncodedList() {
  final encodedList = encodeList();
  print("Sharing encoded list: $encodedList");
  final shareText = 'Here is my list: https://import.app/$encodedList';
  Share.share(shareText);
}
  Future<File> _saveListToFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/list.json');
    final jsonList = widget.rateList.map((item) => item.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
    return file;
  }

  Future<void> shareFile() async {
    try {
      final file = await _saveListToFile();
      final xFile = XFile(file.path);
      await Share.shareXFiles([xFile], text: 'Here is my list');
    } catch (e) {
      print("Error sharing file: $e");
    }
  }

  Future<void> _importFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File file = File(result.files.single.path!);
        String content = await file.readAsString();
        List<dynamic> jsonList = json.decode(content);
        List<RateItem> newRateList = jsonList.map((item) => RateItem.fromJson(item)).toList();

        setState(() {
          widget.rateList.clear();
          widget.rateList.addAll(newRateList);
        });
        _saveItems();
      }
    } catch (e) {
      print("Error importing file: $e");
    }
  }

    


  Future<void> _share(SocialMedia media) async {
    final encodedList = encodeList();
    final shareText = 'Here is my list: https://import.app/$encodedList';

    switch (media) {
      case SocialMedia.facebook:
        final url = Uri.parse("https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(shareText)}");
        await _launchUrl(url);
       
      case SocialMedia.twitter:
        final url = Uri.parse("https://twitter.com/intent/tweet?text=${Uri.encodeComponent(shareText)}");
        await _launchUrl(url);
      
      case SocialMedia.whatsapp:
        final url = Uri.parse("https://wa.me/?text=${Uri.encodeComponent(shareText)}");
        await _launchUrl(url);
       
      default:
        throw 'Unsupported social media platform';
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $url');
    }
  }

  void _navigateToListPage() async {
    final newRateList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Listpage(
          rateList: widget.rateList.toList(),
          onDelete: (int index) {
            setState(() {
              widget.rateList.removeAt(index);
            });
            _saveItems();
          },
          onEdit: (int index) {
            _navigateToEditPage(index);
          },
        ),
      ),
    );

    if (newRateList != null) {
      setState(() {
        widget.rateList.clear();
        widget.rateList.addAll(newRateList);
      });
      _saveItems();
    }
  }

  void _navigateToEditPage(int index) async {
    final editedRateItem = await showDialog<RateItem>(
      context: context,
      builder: (BuildContext context) {
        return EditRateItemDialog(rateItem: widget.rateList[index]);
      },
    );

    if (editedRateItem != null) {
      setState(() {
        widget.rateList[index] = editedRateItem;
      });
      _saveItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Center(
        child: Column(
          children: [
            // ... other content for FavoritesPage
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _navigateToListPage,
                  child: Text('List1'),
                ),
                SizedBox(width: 100),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () => _shareList(context),
                ),
                IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: _importFile,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _shareList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Share"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Share your list:"),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.facebook),
                    onPressed: () => _share(SocialMedia.facebook),
                  ),
                  IconButton(
                    icon: Icon(FeatherIcons.twitter),
                    onPressed: () => _share(SocialMedia.twitter),
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.whatsapp),
                    onPressed: () => _share(SocialMedia.whatsapp),
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: shareEncodedList,
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
    
  }
}

enum SocialMedia {
  facebook,
  twitter,
  whatsapp,
}

