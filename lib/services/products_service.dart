import 'dart:convert'; // Para trabajar con JSON
import 'dart:io';
import 'package:flutter/material.dart'; // Para el widget ChangeNotifier
import '../models/models.dart'; // Importamos nuestros modelos (incluyendo Product)
import 'package:http/http.dart' as http; // Para hacer peticiones HTTP

//· Servicio para manejar los productos, extiende ChangeNotifier para notificar cambios a los widgets ·
class ProductsService extends ChangeNotifier {
  // URL base de la API de Firebase Realtime Database
  final String _baseUrl = 'flutter-segunda-mano-default-rtdb.europe-west1.firebasedatabase.app';
  // Lista para almacenar los productos
  final List<Product> products = [];
  // Producto seleccionado (se inicializará más tarde)
  late Product selectedProduct;
  // Variable para almacenar la nueva imagen del producto
  File? newPicture;
  // Flag para saber si está cargando datos
  bool isLoading = true;
  // Flag para saber si está guardando un producto
  bool isSaving = false;
  // Constructor: cuando se crea el servicio, carga los productos automáticamente
  ProductsService() {
    loadProducts();
  }

  //* Método para cargar los productos desde Firebase
  Future loadProducts() async {
    // Activamos el flag de carga
    isLoading = true;
    // Notificamos a los listeners que el estado cambió
    notifyListeners();
    // Construimos la URL para la petición
    final url = Uri.https(_baseUrl, 'products.json');
    // Hacemos la petición GET
    final resp = await http.get(url);
    // Decodificamos la respuesta JSON a un Map
    final Map<String, dynamic> productsMap = json.decode(resp.body);
    // Recorremos cada producto en el Map
    productsMap.forEach((key, value) {
      // Creamos un Product a partir del Map
      final tempProduct = Product.fromMap(value);
      // Asignamos el ID (la key de Firebase)
      tempProduct.id = key;
      // Añadimos el producto a la lista
      products.add(tempProduct);
    });
    // Desactivamos el flag de carga
    isLoading = false;
    // Notificamos a los listeners que terminó la carga
    notifyListeners();
  }

  //* Método para guardar o crear un producto
  Future saveOrCreateProduct(Product product) async {
    // Activamos el flag de guardando
    isSaving = true;
    // Notificamos a los listeners
    notifyListeners();
    // Si el producto no tiene ID, es nuevo (create)
    // Si tiene ID, actualizamos el existente (update)
    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }
    // Desactivamos el flag de guardando
    isSaving = false;
    // Notificamos a los listeners
    notifyListeners();
  }

  //* Método para actualizar un producto existente
  Future<String> updateProduct(Product product) async {
    // Construimos la URL específica para el producto
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    // Hacemos petición PUT con los datos del producto en JSON
    await http.put(url, body: product.toJson());
    // Buscamos el índice del producto en la lista local
    final index = products.indexWhere((element) => element.id == product.id);
    // Actualizamos el producto en la lista local
    products[index] = product;
    // Devolvemos el ID del producto actualizado
    return product.id!;
  }

  //* Método para crear un nuevo producto
  Future<String> createProduct(Product product) async {
    // Construimos la URL para crear un nuevo producto
    final url = Uri.https(_baseUrl, 'products.json');
    // Hacemos petición POST con los datos del producto en JSON
    final resp = await http.post(url, body: product.toJson());
    // Decodificamos la respuesta
    final decodedData = json.decode(resp.body);
    // Asignamos el ID del nuevo producto
    product.id = decodedData['name'];
    // Añadimos el producto a la lista local
    products.add(product);
    // Buscamos el índice del nuevo producto en la lista local
    products.indexWhere((element) => element.id == product.id);
    // Devolvemos el ID del nuevo producto
    return product.id!;
  }

  //* Método para actualizar la imagen seleccionada de un producto
  void updateSelectedProductImage(String path) {
    newPicture = File.fromUri(Uri(path: path));
    selectedProduct.picture = path;
    notifyListeners();
  }

  //* Método para subir la nueva imagen a Cloudinary
  Future<String?> uploadImage() async {
    // Si no hay una nueva imagen, retornamos null
    if (newPicture == null) return null;
    // Activamos el flag de guardando
    isSaving = true;
    // Notificamos a los listeners
    notifyListeners();
    // Subimos la imagen a Cloudinary
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dfehykcmu/image/upload?upload_preset=unsigned');
    // Creamos una petición multipart para subir la imagen
    final imageUploadRequest = http.MultipartRequest('POST', url);
    // Añadimos el archivo de imagen a la petición
    final file = await http.MultipartFile.fromPath('file', newPicture!.path);
    // Añadimos el archivo a la petición
    imageUploadRequest.files.add(file);
    // Enviamos la petición
    final streamResponse = await imageUploadRequest.send();
    // Verificamos si la respuesta es exitosa
    final resp = await http.Response.fromStream(streamResponse);
    // Si la respuesta no es exitosa, lanzamos una excepción
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null; // Retornamos null si hubo un error
    }
    newPicture = null; // Limpiamos la nueva imagen
    final decodeData = json.decode(resp.body);
    return decodeData['secure_url']; // Retornamos la URL de la imagen subida
  }
}
