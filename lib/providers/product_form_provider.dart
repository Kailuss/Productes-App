import 'package:flutter/material.dart';
import '../models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Product tempProduct;

  ProductFormProvider(this.tempProduct);
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void updateAvailability(bool value) {
    tempProduct.available = value;
    notifyListeners();
  }
}
