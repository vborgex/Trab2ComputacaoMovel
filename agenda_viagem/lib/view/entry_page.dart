import 'package:agenda_viagem/helper/traveldiary_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryPage extends StatefulWidget {
  final TravelDiaryEntry entry;
  EntryPage({this.entry});

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  TravelDiaryEntry _editEntry;
  bool _entryEdited = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _localizationController = TextEditingController();
  final _ratingController = TextEditingController();
  final _dateController = TextEditingController();
  final _titleFocus = FocusNode();

  String _errorMessage = '';
  String _dateErrorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.entry == null) {
      _editEntry = TravelDiaryEntry();
    } else {
      _editEntry = TravelDiaryEntry.fromMap(widget.entry.toMap());
      _titleController.text = _editEntry.title;
      _descriptionController.text = _editEntry.description;
      _localizationController.text = _editEntry.localization;
      _ratingController.text = _editEntry.rating;

      if (_editEntry.date != null) {
        _dateController.text =
            DateFormat('dd/MM/yy').format(DateTime.parse(_editEntry.date));
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _editEntry.date != null
          ? DateTime.parse(_editEntry.date)
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _editEntry.date = picked.toIso8601String();
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(55, 28, 28, 28),
          title: Text(
            _editEntry.title ?? "Nova viagem",
            style: TextStyle(color: Color.fromARGB(255, 235, 235, 235)),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editEntry.title == null || _editEntry.title.isEmpty) {
              setState(() {
                _errorMessage = 'Título é um campo obrigatório.';
                _dateErrorMessage = '';
              });
              FocusScope.of(context).requestFocus(_titleFocus);
              return;
            }
            if (_editEntry.date == null || _editEntry.date.isEmpty) {
              setState(() {
                _dateErrorMessage = 'Data é um campo obrigatório.';
                _errorMessage = '';
              });
              return;
            }
            setState(() {
              _errorMessage = '';
              _dateErrorMessage = '';
            });
            Navigator.pop(context, _editEntry);
          },
          child: const Icon(
            Icons.save,
            color: Color.fromARGB(255, 235, 235, 235),
          ),
          backgroundColor: Color.fromARGB(255, 28, 28, 28),
        ),
        backgroundColor: Color.fromARGB(255, 235, 235, 235),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              TextField(
                controller: _titleController,
                focusNode: _titleFocus,
                maxLength: 30,
                decoration: InputDecoration(
                  labelText: "Título",
                  labelStyle: TextStyle(color: Color.fromARGB(255, 28, 28, 28)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 28, 28, 28)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 28, 28, 28)),
                  ),
                ),
                cursorColor: Color.fromARGB(255, 28, 28, 28),
                onChanged: (text) {
                  _entryEdited = true;
                  setState(() {
                    _editEntry.title = text;
                    _errorMessage = "";
                  });
                },
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: "Data",
                      labelStyle: TextStyle(color: Color.fromARGB(255, 28, 28, 28)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 28, 28, 28)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 28, 28, 28)),
                      ),
                    ),
                  ),
                ),
              ),
              if (_dateErrorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    _dateErrorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              SizedBox(height: 10),
              TextField(
                controller: _localizationController,
                maxLength: 30,
                decoration: InputDecoration(
                  labelText: "Localização",
                  labelStyle: TextStyle(color: Color.fromARGB(255, 28, 28, 28)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 28, 28, 28)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 28, 28, 28)),
                  ),
                ),
                cursorColor: Color.fromARGB(255, 28, 28, 28),
                onChanged: (text) {
                  _entryEdited = true;
                  setState(() {
                    _editEntry.localization = text;
                  });
                },
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 80,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _ratingController,
                  maxLength: 2,
                  decoration: InputDecoration(
                    labelText: "Avaliação",
                    labelStyle: TextStyle(color: Color.fromARGB(255, 28, 28, 28)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 28, 28, 28)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 28, 28, 28)),
                    ),
                    suffixText: "/10",
                  ),
                  cursorColor: Color.fromARGB(255, 28, 28, 28),
                  onChanged: (text) {
                    _entryEdited = true;
                    setState(() {
                      if (text.isEmpty ||
                          int.tryParse(text) != null &&
                              int.parse(text) >= 0 &&
                              int.parse(text) <= 10) {
                        _editEntry.rating = text;
                      } else {
                        _ratingController.clear();
                        _editEntry.rating = '';
                      }
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                maxLength: 200,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  labelStyle: TextStyle(color: Color.fromARGB(255, 28, 28, 28)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 28, 28, 28)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 28, 28, 28)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                cursorColor: Color.fromARGB(255, 28, 28, 28),
                onChanged: (text) {
                  _entryEdited = true;
                  setState(() {
                    _editEntry.description = text;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_entryEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Descartar Alterações"),
            content: const Text("Se sair as alterações serão perdidas!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("Sim"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancelar"),
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
