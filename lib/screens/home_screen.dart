import 'package:flutter/material.dart';
import 'package:productes_app/screens/screens.dart'; // Importa otras pantallas
import 'package:productes_app/services/services.dart'; // Importa servicios
import 'package:productes_app/widgets/widgets.dart'; // Importa widgets personalizados
import 'package:provider/provider.dart'; // Importa Provider para manejo de estado
import '../models/products.dart'; // Importa el modelo de productos

//· Pantalla principal que muestra la lista de productos
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtiene el servicio de productos mediante Provider
    final productsService = Provider.of<ProductsService>(context);

    // Si está cargando, muestra pantalla de carga
    if (productsService.isLoading) return const LoadingScreen();

    return Scaffold(
      //* Barra superior con título
      appBar: AppBar(
        title: const Text('📦 Productos en venta'),
        backgroundColor: Colors.purple.shade900,
        foregroundColor: Colors.white,
      ), // Título de la pantalla

      //* Cuerpo principal con lista de productos
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 20), // Espaciado superior
        itemCount: productsService.products.length, // Número de productos
        itemBuilder: (BuildContext context, int index) => GestureDetector(
            // Tarjeta de producto
            child: ProductCard(product: productsService.products[index]),
            // Al hacer tap en un producto
            onTap: () {
              // Reinicia la imagen nueva
              productsService.newPicture = null;
              // Guarda una copia del producto seleccionado en el servicio
              productsService.selectedProduct = productsService.products[index].copy();
              // Navega a la pantalla de detalle del producto
              Navigator.of(context).pushNamed('product');
            }),
      ),

      //* Botón flotante para agregar nuevos productos
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, size: 36, color: Colors.white),
          backgroundColor: Colors.purple.shade900,
          onPressed: () {
            // Reinicia la imagen nueva
            productsService.newPicture = null;
            // Crea un nuevo producto vacío y lo asigna al servicio
            productsService.selectedProduct = Product(available: true, name: 'Nuevo producto', price: 0);
            Navigator.of(context).pushNamed('product');
          }),
    );
  }
}
