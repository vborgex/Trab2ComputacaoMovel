import 'dart:io';
import 'package:agenda_viagem/view/entry_page.dart';
import 'package:intl/intl.dart';
import 'package:agenda_viagem/helper/traveldiary_helper.dart';
import 'package:flutter/material.dart';
enum OrderOptions{orderDateAsc, orderDateDesc}
class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TravelDiaryHelper helper = TravelDiaryHelper();
  List<TravelDiaryEntry> entries = List();

  @override
  void initState() {
    super.initState();
    _getAllEntries();
  }
  void _getAllEntries(){
    helper.getAllTravelDiaryEntries().then((list) {
      setState(() {
        entries = list;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Centraliza o título corretamente
        title: Row(
          mainAxisSize: MainAxisSize.min, // Faz o Row ocupar apenas o espaço necessário
          children: const [
            Icon(
              Icons.landscape,
              color: Color.fromARGB(255, 235, 235, 235),
            ),
            SizedBox(width: 8),
            Text(
              "Diário de Viagem",
              style: TextStyle(
                color: Color.fromARGB(255, 235, 235, 235),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
        actions: <Widget> [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Mais antigos primeiro"),
                value: OrderOptions.orderDateAsc,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Mais recentes primeiro"),
                value: OrderOptions.orderDateDesc,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Color.fromARGB(255, 204, 204, 204),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          _showEntryPage();
        }),
        child: Icon(
          Icons.add,
          color: Color.fromARGB(255, 235, 235, 235),
        ),
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return _entryCard(context, index);
        },
      ),
    );
  }

  Widget _entryCard(BuildContext context, int index) {
      DateTime dateTime = DateTime.parse(entries[index].date);
      String formattedDate = DateFormat('dd/MM/yy').format(dateTime);    
    
    return GestureDetector(
      onTap:(() =>  _showOptions(context, index)),
      child: Card(
        color: Color.fromARGB(255, 235, 235, 235),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Define o raio das bordas
        ),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      entries[index].title ?? "",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),

      ),
    );
  }

  Future<void> _showEntryPage({TravelDiaryEntry entry}) async {
    final recEntry = await Navigator.push(context, 
    MaterialPageRoute(builder: (context) => EntryPage(entry: entry)));
    if (recEntry != null) {
      if(entry != null){
        await helper.updateTravelDiaryEntry(recEntry);
      }
      else{
        await helper.saveTravelDiaryEntry(recEntry);
      }
      _getAllEntries();
    }
  }
  void _showOptions(BuildContext context, int index) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(
                  child: const Text(
                    "Editar",
                    style: TextStyle(color: Colors.blue, fontSize: 20.0),
                  ),
                  onPressed: (() {
                    Navigator.pop(context);
                    _showEntryPage(entry: entries[index]);
                  }),
                ),
                TextButton(
                  child: const Text(
                    "Excluir",
                    style: TextStyle(color: Colors.red, fontSize: 20.0),
                  ),
                  onPressed: (() {
                    Navigator.pop(context); // Fecha o BottomSheet
                    _confirmDelete(context, index); // Confirmação antes de excluir
                  }),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void _confirmDelete(BuildContext context, int index) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Confirmar Exclusão"),
        content: const Text(
            "Tem certeza de que deseja excluir esta entrada? Esta ação não pode ser desfeita."),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
            },
          ),
          TextButton(
            child: const Text(
              "Excluir",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              helper.deleteTravelDiaryEntry(entries[index].id);
              setState(() {
                entries.removeAt(index); // Remove a entrada da lista
              });
              Navigator.pop(context); // Fecha o diálogo
            },
          ),
        ],
      );
    },
  );
}



  void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderDateAsc:
        entries.sort((a, b) {
          DateTime dateA = DateTime.parse(a.date);
          DateTime dateB = DateTime.parse(b.date);
          return dateA.compareTo(dateB);
        });
        break;
        case OrderOptions.orderDateDesc:
        entries.sort((a, b) {
          DateTime dateA = DateTime.parse(a.date);
          DateTime dateB = DateTime.parse(b.date);
          return dateB.compareTo(dateA);
        });
        break;
    }
    setState(() {});
  }
  
}