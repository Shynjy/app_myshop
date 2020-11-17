import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Dados
import '../providers/product.dart';
import '../providers/products.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();

  final _formData = Map<String, Object>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;
      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  void _updateImage() {
    if (isValidImageUrl(_imageUrlController.text)) {
      // reconstrói a tela quando o valor é válido
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool startWithHttp = url.toLowerCase().startsWith('http://');
    bool startWithHttps = url.toLowerCase().startsWith('https://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');

    return (startWithHttp || startWithHttps) &&
        (endsWithPng || endsWithJpg || endsWithJpeg);
  }

  Future<void> _saveForm() async {
    bool isValid = _form.currentState.validate();
    _form.currentState.save();

    if (!isValid) {
      return;
    }

    final product = Product(
      id: _formData['id'],
      title: _formData['title'],
      description: _formData['description'],
      price: _formData['price'],
      imageUrl: _formData['imageUrl'],
    );

    setState(() {
      _isLoading = true;
    });

    final products = Provider.of<Products>(context, listen: false);

    try {
      if (_formData['id'] == null) {
        await products.addProduct(product);
      } else {
        await products.updateProduct(product);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('Ocorreu um erro!'),
                content:
                    Text('Infelizmente seu produto não pode ser cadastrado!!!'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('OK'),
                      onPressed: () => Navigator.of(context).pop()),
                ],
              ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    // Campo Título
                    TextFormField(
                      initialValue: _formData['title'],
                      decoration: InputDecoration(labelText: 'Título'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = value.trim().length <= 3;
                        if (isEmpty || isInvalid) {
                          return 'Informe um título válido com o mínimo de 3 caracteres';
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['title'] = value,
                    ),
                    // Campo Preço
                    TextFormField(
                      initialValue: _formData['price'].toString(),
                      focusNode: _priceFocusNode,
                      decoration: InputDecoration(labelText: 'Preço'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value),
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        var newPrice = double.tryParse(value);
                        bool isInvalid = newPrice == null || newPrice <= 0;

                        if (isEmpty || isInvalid) {
                          return 'Informe um Preço válido';
                        }
                        return null;
                      },
                    ),
                    // Campo Descrição
                    TextFormField(
                      initialValue: _formData['description'],
                      focusNode: _descriptionFocusNode,
                      decoration: InputDecoration(labelText: 'Descrição'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) => _formData['description'] = value,
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = value.trim().length <= 10;
                        if (isEmpty || isInvalid) {
                          return 'Informe uma descrição válida com o mínimo de 10 caracteres';
                        }
                        return null;
                      },
                    ),
                    Row(
                      // Campo imagem
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'URL da Imagem'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            controller: _imageUrlController,
                            onSaved: (value) => _formData['imageUrl'] = value,
                            validator: (value) {
                              bool isEmpty = value.trim().isEmpty;
                              bool isInvalid = !isValidImageUrl(value);
                              if (isEmpty || isInvalid) {
                                return 'Informe uma URL válida';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? Text('Informe a URL')
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
