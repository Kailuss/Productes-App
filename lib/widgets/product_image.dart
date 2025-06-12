import 'package:flutter/material.dart';
import 'dart:io';

class ProductImage extends StatelessWidget {
  final String? url;
  const ProductImage({Key? key, this.url}) : super(key: key);

  //· Constructor de la clase ProductImage ·
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
      child: Container(
        decoration: _buildBoxDecoration(),
        width: double.infinity,
        height: 400,
        child: ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)), child: getImage(url)),
      ),
    );
  }

  //· Método para construir el BoxDecoration del contenedor ·
  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ]);

  //· Método para obtener la imagen del producto ·
  Widget getImage(String? picture) {
    //* Si no hay imagen, mostramos una imagen por defecto
    if (picture == null || picture.isEmpty) {
      return const Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
      );
    }
    //* Si la imagen es una URL, mostramos una imagen de red con un placeholder
    if (picture.startsWith('http')) {
      return FadeInImage(
        placeholder: const AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(url!),
        fit: BoxFit.cover,
      );
    }
    //* Si la imagen es un archivo local, mostramos la imagen del archivo
    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
  }
}
