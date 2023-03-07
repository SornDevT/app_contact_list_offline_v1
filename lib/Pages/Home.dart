import 'info.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _refreshItem();
  }

  // ປະກາດໂຕແປກ້ອນຂໍ້ມູນ
  final _contactBox = Hive.box('contacts_box');

  List<Map<String, dynamic>> _items = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _telController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List App'),
      ),
      body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final currentItem = _items[index];
            return Card(
                margin: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    // print(currentItem['key']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoPage(
                          contactID: currentItem['key'],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title:
                        //Container(
                        // child:
                        Row(
                      children: [
                        currentItem['gender'] == 'male'
                            ? Text('ທ່ານ ')
                            : Text('ທ່ານ ນ '),
                        Text(currentItem['name']),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(currentItem['lastname']),
                      ],
                    ),
                    // ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ທີ່ຢູ່: ' + currentItem['address']),
                        Text('ເບີໂທ: ' + currentItem['tel']),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _showForm(context, currentItem['key']);
                            // print('Edit data');
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            _deleteItem(currentItem['key']);
                            //print('Delete Data');
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: Icon(Icons.add),
      ),
    );
  }

  /// function ເພີ່ມຂໍ້ມູນໃໝ່

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _contactBox.add(newItem);
    _refreshItem();
  }

  /// function ອັບເດດຂໍ້ມູນ
  Future<void> _updateItem(int itemKey, Map<String, dynamic> updateItem) async {
    await _contactBox.put(itemKey, updateItem);
    _refreshItem();
  }

  /// function ລຶບຂໍ້ມູນ
  Future<void> _deleteItem(int itemKey) async {
    await _contactBox.delete(itemKey);
    _refreshItem();
  }

  /// function ອ່ານຂໍ້ມູນ ຈາກຖານຂໍ້ມູນ
  void _refreshItem() {
    final data = _contactBox.keys.map((key) {
      final value = _contactBox.get(key);
      return {
        "key": key,
        "name": value["name"],
        "lastname": value["lastname"],
        "gender": value["gender"],
        "address": value["address"],
        "tel": value["tel"],
      };
    }).toList();

    // ສະແດງຂໍ້ມູນອກທາງ console
    print(data.reversed.toList());

    setState(() {
      _items = data.reversed.toList();
    });
  }

  void _showForm(BuildContext context, int? itemKey) {
    print(itemKey);

    /// ນຳ itemkey ໄດຶງຂໍ້ມູນ
    ///
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['name'];
      _lastnameController.text = existingItem['lastname'];
      _genderController.text = existingItem['gender'];
      _addressController.text = existingItem['address'];
      _telController.text = existingItem['tel'];
    } else {
      _nameController.text = '';
      _lastnameController.text = '';
      _genderController.text = '';
      _addressController.text = '';
      _telController.text = '';
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 15,
                left: 15,
                right: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'ຊື່'),
                  ),
                  TextField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(hintText: 'ນາມສະກຸນ'),
                  ),
                  Row(
                    children: [
                      Text('ເພດ:'),
                      Radio(
                          value: 'male',
                          groupValue: _genderController.text,
                          onChanged: (value) {
                            print(_genderController);
                            setState(() {
                              _genderController.text = value!;
                            });
                          }),
                      Text('ຊາຍ'),
                      Radio(
                          value: 'female',
                          groupValue: _genderController.text,
                          onChanged: (value) {
                            print(_genderController);
                            setState(() {
                              _genderController.text = value!;
                            });
                          }),
                      Text('ຍິງ')
                    ],
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(hintText: 'ທີ່ຢູ່'),
                  ),
                  TextField(
                    controller: _telController,
                    decoration: const InputDecoration(hintText: 'ເບີໂທ'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (itemKey == null) {
                        // ເພີ່ມຂໍ້ມູນໃໝ່
                        _createItem({
                          "name": _nameController.text,
                          "lastname": _lastnameController.text,
                          "gender": _genderController.text,
                          "address": _addressController.text,
                          "tel": _telController.text,
                        });
                      } else {
                        // ອັບເດດຂໍ້ມູນ
                        _updateItem(itemKey, {
                          "name": _nameController.text,
                          "lastname": _lastnameController.text,
                          "gender": _genderController.text,
                          "address": _addressController.text,
                          "tel": _telController.text,
                        });
                      }

                      // ທຳການເຄຼຍຟອມ

                      _nameController.text = '';
                      _lastnameController.text = '';
                      _genderController.text = '';
                      _addressController.text = '';
                      _telController.text = '';

                      /// ປິດໜ້າ BottomSheet
                      Navigator.of(context).pop();

                      ///
                    },
                    child: Text(itemKey == null ? 'ສ້າງໃໝ່' : 'ອັບເດດ'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
