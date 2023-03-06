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
              child: ListTile(
                title: Text(currentItem['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ທີ່ຢູ່: ບ. ໜອງແມງດາ ມ. ໄຊ ຂ. ອຸດົມໄຊ'),
                    Text('ເບີໂທ: 020 2233445566'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        print('Edit data');
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        print('Delete Data');
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        child: Icon(Icons.add),
      ),
    );
  }

  /// function ເພີ່ມຂໍ້ມູນໃໝ່

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _contactBox.add(newItem);
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

  void _showForm(BuildContext context) {
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
                      _createItem({
                        "name": _nameController.text,
                        "lastname": _lastnameController.text,
                        "gender": _genderController.text,
                        "address": _addressController.text,
                        "tel": _telController.text,
                      });

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
                    child: Text('ສ້າງໃໝ່'),
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
