import 'package:flutter/material.dart';

class BackupEtiquetas {
  String tag;
  String texto1;
  String texto2;
  IconData icono;

  BackupEtiquetas({
    this.tag = "",
    this.texto1 = "",
    this.texto2 = "--",
    this.icono = Icons.person,
  });
}