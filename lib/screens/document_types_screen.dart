import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pet_route_mobile/components/loader_component.dart';
import 'package:pet_route_mobile/helpers/api_jelper.dart';
import 'package:pet_route_mobile/models/document_type.dart';
import 'package:pet_route_mobile/models/responses.dart';
import 'package:pet_route_mobile/models/token.dart';
import 'package:pet_route_mobile/screens/home_screen.dart';

import 'document_type_screen.dart';

class DocumentTypeScreen extends StatefulWidget {
  final Token token;
  DocumentTypeScreen({required this.token});

  @override
  _DocumentTypeScreenState createState() => _DocumentTypeScreenState();
}

class _DocumentTypeScreenState extends State<DocumentTypeScreen> {
  List<DocumentType> _documentType = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = "";

  @override
  @override
  void initState() {
    super.initState();
    _getDocumentsType();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
          child: new Text("Tipos de documentos"),
        ),
        backgroundColor: Colors.orange[700],
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(token: widget.token)));
              },
              icon: Icon(Icons.home)),
          _isFiltered
              ? IconButton(
                  onPressed: removeFilter,
                  icon: Icon(Icons.filter_none),
                )
              : IconButton(
                  onPressed: _showFilter,
                  icon: Icon(Icons.filter_alt),
                ),
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(token: widget.token)));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: _showLoader
            ? loaderComponents(
                text: "Por favor espere",
              )
            : _getContend(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.orange[600],
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DocumentsTypeScreen(
                    token: widget.token,
                    documentType: DocumentType(id: 0, description: ""))),
          );
        },
      ),
    );
  }

  void _getDocumentsType() async {
    setState(() {
      _showLoader = true;
    });
    Responses response = await ApiHelper.getDocumentType(widget.token);

    setState(() {
      _showLoader = false;
    });
    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: response.message,
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Aceptar')
        ],
      );
    }
    setState(() {
      _documentType = response.result;
    });
  }

  _getContend() {
    return _documentType.length == 0 ? _notContend() : _getListView();
  }

  Widget _getListView() {
    return ListView(
      children: _documentType.map((e) {
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DocumentsTypeScreen(
                          token: widget.token,
                          documentType: e,
                        )),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.description,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getDocumentsType();
  }

  _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text('Filtrar tipos de documentos'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Escriba las primeras letras del tipo de documento'),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Criterio de busqueda',
                    labelText: 'Buscar',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _search = value;
                    });
                  },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')),
              TextButton(onPressed: () => _filter(), child: Text('Filtrar'))
            ],
          );
        });
  }

  Widget _notContend() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFiltered
              ? 'No hay tipos de documentos con ese criterio de busqueda'
              : 'No hay tipos de documentos almacenados',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<DocumentType> filterList = [];
    for (var item in _documentType) {
      if (item.description.toLowerCase().contains(_search.toLowerCase())) {
        filterList.add(item);
      }
    }
    setState(() {
      _documentType = filterList;
      _isFiltered = true;
    });
    Navigator.of(context).pop();
  }
}
