import 'package:flutter/material.dart';
import '../models/models.dart';

//· Widget principal que representa una tarjeta de producto ·
class ProductCard extends StatelessWidget {
  final Product product; // Recibe un objeto Product como parámetro requerido

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20), // Padding horizontal de la tarjeta
      child: Container(
        margin: const EdgeInsets.only(bottom: 20), // Margen inferior de la tarjeta
        width: double.infinity, // Ancho completo
        height: 400, // Altura fija
        decoration: _cardBorders(), // Aplica estilos de borde y sombra
        child: Stack(
          // Widget apilado para superponer elementos
          alignment: Alignment.bottomLeft, // Alineación de los hijos
          children: [
            // Fondo con la imagen del producto
            _BackgroudWidget(picture: product.picture ?? 'https://placehold.co/600/fff/aaa.png?text=Product+image&font=roboto'),
            // Detalles del producto (nombre e ID)
            _ProductDetails(product: product),
            // Etiqueta de precio (posición superior derecha)
            Positioned(top: 0, right: 0, child: _PriceTag(price: product.price.toDouble())),
            // Etiqueta de disponibilidad (solo visible si el producto no está disponible)
            if (!product.available) const Positioned(top: 0, left: 0, child: _Availability()),
          ],
        ),
      ),
    );
  }

  //* Método privado para definir los estilos del borde de la tarjeta
  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white, // Fondo blanco
        borderRadius: BorderRadius.circular(16), // Bordes redondeados
        boxShadow: const [
          BoxShadow(
            // Sombra para efecto elevado
            color: Colors.black12,
            offset: Offset(0, 7), // Desplazamiento vertical
            blurRadius: 10, // Difuminado
          ),
        ],
      );
}

//* Widget para la imagen de fondo del producto
class _BackgroudWidget extends StatelessWidget {
  final String picture; // URL de la imagen
  const _BackgroudWidget({Key? key, required this.picture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Recorta la imagen con bordes redondeados
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity, // Ancho completo
        height: 400, // Altura fija
        child: FadeInImage(
          // Imagen con efecto fade-in
          placeholder: const AssetImage('assets/jar-loading.gif'), // Imagen de carga
          image: NetworkImage(picture), // Imagen desde URL
          fit: BoxFit.cover, // Ajuste de la imagen
        ),
      ),
    );
  }
}

//* Widget para los detalles del producto (nombre e ID)
class _ProductDetails extends StatelessWidget {
  final Product product;
  const _ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Espaciado interno
      width: double.infinity, // Ancho completo
      height: 70, // Altura fija
      decoration: _buildBoxDecoration(), // Estilo de fondo
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alineación izquierda
          children: [
            Text(
              product.name, // Nombre del producto
              style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1, // Máximo una línea
              overflow: TextOverflow.ellipsis, // Puntos suspensivos si es muy largo
            ),
            Text(
              product.id ?? 'ID desconocido', // ID del producto
              style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.64)), // Color blanco semitransparente
            )
          ]),
    );
  }

  //* Estilo del fondo del contenedor de detalles
  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.black.withOpacity(0.75), // Negro semitransparente
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
      );
}

//· Widget para la etiqueta de precio ·
class _PriceTag extends StatelessWidget {
  final double price;

  const _PriceTag({Key? key, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        // Ajusta el texto al contenedor
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('${price.toStringAsFixed(2)}€', style: const TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
      width: 115, // Ancho fijo
      height: 48, // Alto fijo
      alignment: Alignment.center, // Centrado
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75), // Negro semitransparente
        borderRadius: const BorderRadius.only(
          // Bordes redondeados específicos
          bottomLeft: Radius.circular(8),
          topRight: Radius.circular(16),
        ),
      ),
    );
  }
}

//· Widget para indicar que el producto está reservado/no disponible
class _Availability extends StatelessWidget {
  const _Availability({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('RESERVADO', style: TextStyle(fontSize: 14, color: Color(0xFFCC0000), fontWeight: FontWeight.bold)),
        ),
      ),
      width: 111, // Ancho fijo
      height: 48, // Alto fijo
      alignment: Alignment.center, // Centrado
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92), // Color morado semitransparente
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(8),
          topLeft: Radius.circular(16),
        ),
      ),
      // Solo dibuja el borde derecho y el inferior
    );
  }
}
