import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productes_app/providers/product_form_provider.dart';
import 'package:productes_app/services/products_service.dart';
import 'package:productes_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../ui/input_decorations.dart';

//· Pantalla para editar o crear un producto ·
class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  // Constructor de la pantalla de producto
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    // Proveedor para el formulario del producto
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductScreenBody(productService: productService),
    );
  }
}

//· Cuerpo principal de la pantalla de producto ·
class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({Key? key, required this.productService}) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
          // Permite hacer scroll en la pantalla
          child: Padding(
              padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
              child: Column(children: [
                Stack(
                    // Para superponer elementos
                    children: [
                      // Muestra la imagen del producto
                      ProductImage(url: productService.selectedProduct.picture),

                      //* Botón de retroceso (arriba a la izquierda)
                      Positioned(
                          top: 20,
                          left: 20,
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(168, 255, 255, 255), // Fondo blanco semitransparente
                                  shape: BoxShape.circle // Forma circular
                                  ),
                              child: IconButton(
                                  icon: const Icon(Icons.arrow_back, size: 28),
                                  onPressed: () => Navigator.of(context).pop() // Regresa a la pantalla anterior
                                  ))),

                      //* Botón de cámara (arriba a la derecha)
                      Positioned(
                          top: 20,
                          right: 20,
                          child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(168, 255, 255, 255),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                  icon: const Icon(Icons.camera_alt, size: 28),
                                  onPressed: () async {
                                    final ImagePicker picker = ImagePicker();
                                    // Abre la cámara para tomar una foto
                                    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                                    productService.updateSelectedProductImage(photo!.path);
                                  })))
                    ]),

                // Formulario de producto
                _ProductForm(),
                // Espacio al final para evitar que el FAB tape contenido
                const SizedBox(height: 100)
              ]))),

      //* Botón flotante para guardar
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          backgroundColor: Colors.purple.shade900,
          child:
              productService.isSaving ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.save, color: Colors.white, size: 32),
          onPressed: productService.isSaving
              ? null
              : () async {
                  if (productForm.isValidForm()) {
                    // Guarda la imagen si se ha seleccionado una nueva
                    final String? imageUrl = await productService.uploadImage();
                    // Actualiza la URL de la imagen en el producto
                    if (imageUrl != null) productForm.tempProduct.picture = imageUrl;
                    // Guarda el producto
                    await productService.saveOrCreateProduct(productForm.tempProduct);
                  } else {
                    // Muestra diálogo de error si el formulario no es válido
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          title: const Text('¡Uy!'),
                          content: const Text('Por favor, completa todos los campos.'),
                          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar'))]),
                    );
                  }
                },
        ),
      ),
    );
  }
}

//· Formulario de producto ·
class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final tempProduct = productForm.tempProduct;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            decoration: _buildBoxDecoration(), // Estilo del contenedor
            child: Form(
                key: productForm.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction, // Valida al interactuar
                child: Column(children: [
                  const SizedBox(height: 20),

                  //* Campo para el nombre del producto
                  TextFormField(
                      initialValue: tempProduct.name,
                      onChanged: (value) => tempProduct.name = value,
                      validator: (value) => (value == null || value.isEmpty) ? 'El nombre es obligatorio' : null,
                      decoration: InputDecorations.authInputDecoration(hintText: 'Nombre del producto', labelText: 'Nombre')),

                  const SizedBox(height: 20),

                  //* Campo para el precio
                  TextFormField(
                      initialValue: '${tempProduct.price}',
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                      onChanged: (value) => tempProduct.price = double.tryParse(value) ?? 0,
                      keyboardType: TextInputType.number,
                      decoration: InputDecorations.authInputDecoration(hintText: '9.95€', labelText: 'Precio')),

                  const SizedBox(height: 20),

                  //* Switch para disponibilidad
                  SwitchListTile.adaptive(
                      value: tempProduct.available,
                      title: const Text('Disponible'),
                      activeColor: Colors.purple.shade900,
                      onChanged: productForm.updateAvailability),

                  const SizedBox(height: 20)
                ]))));
  }

  //· Estilo del contenedor del formulario ·
  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 5),
              blurRadius: 5,
            )
          ]);
}
