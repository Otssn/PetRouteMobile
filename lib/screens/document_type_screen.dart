import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pet_route_mobile/components/loader_component.dart';
import 'package:pet_route_mobile/helpers/api_jelper.dart';
import 'package:pet_route_mobile/models/document_type.dart';
import 'package:pet_route_mobile/models/responses.dart';
import 'package:pet_route_mobile/models/token.dart';
import 'package:pet_route_mobile/screens/document_types_screen.dart';
import 'package:pet_route_mobile/screens/home_screen.dart';

class DocumentsTypeScreen extends StatefulWidget {
  final Token token;
  final DocumentType documentType;
  DocumentsTypeScreen({required this.token, required this.documentType});
  @override
  _DocumentsTypeScreenState createState() => _DocumentsTypeScreenState();
}

class _DocumentsTypeScreenState extends State<DocumentsTypeScreen> {
  String _description = '';
  String _descriptionError = '';
  bool _descriptionShowError = false;
  TextEditingController _descriptionController = TextEditingController();
  bool _showLoader = false;

  void initState() {
    super.initState();
    _description = widget.documentType.description;
    _descriptionController.text = _description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
          child: new Text(widget.documentType.id == 0
              ? 'Nuevo tipo de documento'
              : widget.documentType.description),
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
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DocumentTypeScreen(token: widget.token)));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              _showDescription(),
              _showButtons(),
            ],
          ),
          _showLoader
              ? loaderComponents(
                  text: 'Por favor espere',
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _showDescription() {
    return Container(
      padding: EdgeInsets.all(20),
      child: TextField(
        autofocus: true,
        controller: _descriptionController,
        decoration: InputDecoration(
          hintText: 'Ingresa la descripción',
          labelText: 'Descripción',
          errorText: _descriptionShowError ? _descriptionError : null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          _description = value;
        },
      ),
    );
  }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
                child: Text('Guardar'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.orange;
                  }),
                ),
                onPressed: () => _save()),
          ),
          widget.documentType.id == 0 ? Container() : SizedBox(width: 10),
          widget.documentType.id == 0
              ? Container()
              : Expanded(
                  child: ElevatedButton(
                      child: Text('Borrar'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          return Colors.amberAccent;
                        }),
                      ),
                      onPressed: () => _ConfirmDelete()),
                )
        ],
      ),
    );
  }

  _save() {
    if (!_validateFields()) {
      return;
    }
    widget.documentType.id == 0 ? _addRecord() : _saveRecord();
  }

  bool _validateFields() {
    bool isValidate = true;

    if (_description.isEmpty) {
      isValidate = false;
      _descriptionShowError = true;
      _descriptionError = 'Debes ingresar una descripcion';
    } else {
      _descriptionShowError = false;
    }

    setState(() {});

    return isValidate;
  }

  _ConfirmDelete() async {
    var response = await showAlertDialog(
      context: context,
      title: 'Error',
      message: "¿Esta seguro que desea borrar el registro?",
      actions: <AlertDialogAction>[
        AlertDialogAction(key: 'no', label: 'No'),
        AlertDialogAction(key: 'yes', label: 'Si'),
      ],
    );
    if (response == 'yes') {
      _delete();
    }
  }

  void _delete() async {
    setState(() {
      _showLoader = true;
    });

    Responses responses = await ApiHelper.delete(
        '/api/documentTypes/', widget.documentType.id.toString(), widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!responses.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: responses.message,
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Aceptar')
        ],
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => DocumentTypeScreen(
                token: widget.token,
              )),
    );
  }

  _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'description': _description,
    };

    Responses responses =
        await ApiHelper.post('/api/documentTypes/', request, widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!responses.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: responses.message,
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Aceptar')
        ],
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => DocumentTypeScreen(
                token: widget.token,
              )),
    );
  }

  _saveRecord() async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'id': widget.documentType.id,
      'description': _description,
    };

    Responses responses = await ApiHelper.put('/api/documentTypes/',
        widget.documentType.id.toString(), request, widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!responses.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: responses.message,
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Aceptar')
        ],
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => DocumentTypeScreen(
                token: widget.token,
              )),
    );
  }
}
