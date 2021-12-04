import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pet_route_mobile/models/document_type.dart';
import 'package:pet_route_mobile/models/responses.dart';
import 'package:pet_route_mobile/models/token.dart';
import 'package:http/http.dart' as http;

import 'constans.dart';

class ApiHelper {
  static Future<Responses> getDocumentType(Token token) async {
    if (!_validToken(token)) {
      return Responses(
          isSuccess: false, message: 'Sus credenciales han vencido');
    }
    var url = Uri.parse('${Constans.apiUrl}/api/documentTypes');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );

    List<DocumentType> list = [];

    var body = response.body;

    if (response.statusCode >= 400) {
      return Responses(isSuccess: false, message: body);
    }

    var decodejson = jsonDecode(body);
    if (decodejson != null) {
      for (var item in decodejson) {
        list.add(DocumentType.fromJson(item));
      }
    }
    return Responses(isSuccess: true, result: list);
  }

  static Future<Responses> put(String controller, String id,
      Map<String, dynamic> request, Token token) async {
    if (!_validToken(token)) {
      return Responses(
          isSuccess: false, message: 'Sus credenciales han vencido');
    }
    var url = Uri.parse('${Constans.apiUrl}$controller$id');
    var response = await http.put(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
      body: jsonEncode(request),
    );
    if (response.statusCode >= 400) {
      return Responses(isSuccess: false, message: response.body);
    }
    return Responses(isSuccess: true);
  }

  static Future<Responses> post(
      String controller, Map<String, dynamic> request, Token token) async {
    if (!_validToken(token)) {
      return Responses(
          isSuccess: false, message: 'Sus credenciales han vencido');
    }
    var url = Uri.parse('${Constans.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
      body: jsonEncode(request),
    );
    if (response.statusCode >= 400) {
      return Responses(isSuccess: false, message: response.body);
    }
    return Responses(isSuccess: true);
  }

  static Future<Responses> delete(
      String controller, String id, Token token) async {
    if (!_validToken(token)) {
      return Responses(
          isSuccess: false, message: 'Sus credenciales han vencido');
    }
    var url = Uri.parse('${Constans.apiUrl}$controller$id');
    var response = await http.delete(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );
    if (response.statusCode >= 400) {
      return Responses(isSuccess: false, message: response.body);
    }
    return Responses(isSuccess: true);
  }

  static bool _validToken(Token token) {
    if (DateTime.parse(token.expiration).isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }
}
