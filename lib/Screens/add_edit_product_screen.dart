import 'package:flutter/material.dart';
import '../Providers/product.dart';

class AddEditProductScreen extends StatefulWidget {
  static const routeName = 'add-edit-product-screen';
  const AddEditProductScreen({Key key}) : super(key: key);

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNdoe = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editProduct =
      Product(id: null, title: '', description: '', imageUrl: '', price: 0);

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      if (!_imageController.text.isEmpty ||
          (!_imageController.text.startsWith('http') &&
              !_imageController.text.startsWith('https')) ||
          (!_imageController.text.endsWith('.jpg') &&
              !_imageController.text.endsWith('.jpeg') &&
              !_imageController.text.endsWith('.png'))) {
        return;
      }
      setState(() {});
    }
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.amberAccent,
    primary: Colors.amber,
    minimumSize: Size(88, 45),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  void _submitData() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    print(_editProduct.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('Add product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editProduct = Product(
                      id: _editProduct.id,
                      title: value,
                      description: _editProduct.description,
                      imageUrl: _editProduct.imageUrl,
                      price: _editProduct.price);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNdoe);
                },
                onSaved: (value) {
                  _editProduct = Product(
                      id: _editProduct.id,
                      title: _editProduct.title,
                      description: _editProduct.description,
                      imageUrl: _editProduct.imageUrl,
                      price: double.parse(value));
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than 0';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNdoe,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter description';
                  }
                  if (value.length < 10) {
                    return 'Please enter at least 10 Char';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editProduct = Product(
                      id: _editProduct.id,
                      title: _editProduct.title,
                      description: value,
                      imageUrl: _editProduct.imageUrl,
                      price: _editProduct.price);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageController,
                      focusNode: _imageFocusNode,
                      onFieldSubmitted: (_) {
                        _submitData();
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                            id: _editProduct.id,
                            title: _editProduct.title,
                            description: _editProduct.description,
                            imageUrl: value,
                            price: _editProduct.price);
                      },
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageController.text.isEmpty
                        ? Text('Enter image url')
                        : FittedBox(
                            child: Image.network(
                              _imageController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 14),
                child: ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: _submitData,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
