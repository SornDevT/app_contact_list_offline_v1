import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List App'),
      ),
      body: ListView(children: [
        Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text('ທ່ານ ສີສົມພອນ'),
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
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showForm(BuildContext context) {
    // print('data----');
    showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setstate) {
            return Container(
              child: Text('data'),
            );
          },
        );
      },
    );
  }
}
