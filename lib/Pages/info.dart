import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class InfoPage extends StatefulWidget {
  // ປະກາດໂຕແປ ຮັບ Key
  final int contactID;

  InfoPage({super.key, required this.contactID});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  void initState() {
    super.initState();
    _readItem(widget.contactID);
  }

  final _contactBox = Hive.box('contacts_box');

  late Map<dynamic, dynamic> _items;

  void _readItem(int Key) {
    final item = _contactBox.get(Key);
    setState(() {
      _items = item;
      print(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ຂໍ້ມຸນຜູ້ຕິດຕໍ່'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.blue,
            child: Icon(
              Icons.person,
              size: 190,
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Row(
                      children: [
                        _items['gender'] == 'male'
                            ? Text('ທ່ານ ')
                            : Text('ທ່ານ ນ '),
                        Text(_items['name']),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(_items['lastname']),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(_items['address']),
                  ),
                ),
                Card(
                  child: ListTile(
                      leading: Icon(Icons.phone), title: Text(_items['tel'])),
                ),
              ],
            ),
          ),
          Container(
            child: Expanded(
              child: Container(
                width: 150,
                child: Center(
                  child: ElevatedButton(
                      onPressed: () {
                        _callNumber(_items['tel']);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('ໂທເລີຍ'),
                        ],
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callNumber(String phonenumber) async {
    await FlutterPhoneDirectCaller.callNumber(phonenumber);
  }
}
