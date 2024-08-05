import 'package:flutter/material.dart';
import 'package:rate_list/homepage/list.dart';
class EditRateItemDialog extends StatefulWidget {
  final RateItem rateItem;

  const EditRateItemDialog({Key? key, required this.rateItem}) : super(key: key);

  @override

  State<EditRateItemDialog> createState() => _EditRateItemDialogState();
}

class _EditRateItemDialogState extends State<EditRateItemDialog> {
  late TextEditingController _itemNameController;
  late TextEditingController _rateController;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.rateItem.itemName);
    _rateController = TextEditingController(text: widget.rateItem.rate.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Rate Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _itemNameController,
            decoration: InputDecoration(labelText: 'Item Name'),
          ),
          TextField(
            controller: _rateController,
            decoration: InputDecoration(labelText: 'Rate'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, null); // Cancel editing
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final editedRateItem = RateItem(
              itemName: _itemNameController.text,
              rate: double.tryParse(_rateController.text) ?? 0.0,
            );
            Navigator.pop(context, editedRateItem); // Confirm editing
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _rateController.dispose();
    super.dispose();
  }
}
