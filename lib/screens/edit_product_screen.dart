import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form=GlobalKey<FormState>();
  var _editedProduct=Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  var _isInit=true;
  var _initValues={
    'title':'',
    'description':'',
    'price':'',
    'imageurl':'',
  };

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(_isInit){
      final String? productId=ModalRoute.of(context)!.settings.arguments as String? ;
      if(productId!=null)
        {
          _editedProduct=Provider.of<Products>(context,listen: false).findById(productId);
          _initValues={
            'title':_editedProduct.title,
            'description':_editedProduct.description,
            'price' : _editedProduct.price.toString(),
            // 'imageurl':_editedProduct.imageUrl,
            'imageurl':'',
          };
          _imageUrlController.text=_editedProduct.imageUrl;
        }
    }
    _isInit=false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _imageUrlFocusNode.removeListener(_updateImageUrl);

    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    // _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus) {
      if((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https') )||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return ;
      }
        setState(() {});
      }
  }

  void _saveForm(){
    final isValid=_form.currentState?.validate();
    if(!isValid!){
      return;
    }
    _form.currentState?.save();
    if(_editedProduct.id !=''){
      Provider.of<Products>(context,listen: false).updateProduct(_editedProduct.id, _editedProduct);
    }
    else{
      Provider.of<Products>(context,listen: false).addProduct(_editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(onPressed:(){_saveForm();}, icon: Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct=Product(
                    id: _editedProduct.id,
                    isFav:_editedProduct.isFav,
                    title: value!,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter a price.';
                  }
                  if(double.tryParse(value)==null)
                    {
                      return 'Please enter a valid number.';
                    }
                  if(double.parse(value)<=0)
                    {
                      return 'Please enter a number greater than zero.';
                    }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct=Product(
                    id: _editedProduct.id,
                    isFav:_editedProduct.isFav,
                    title: _editedProduct.title,
                    price: double.parse(value!),
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                  labelText: '  Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter a description.';
                  }
                  if(value.length<10)
                    {
                      return 'Should be at least 10 characters long.';
                    }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct=Product(
                    id: _editedProduct.id,
                    isFav:_editedProduct.isFav,
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    description: value!,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text,
                            fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      // initialValue: _initValues['imageurl'],
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please enter an image URL.';
                        }
                        if(!value.startsWith('http') && !value.startsWith('https')){
                          return 'Please enter a valid URL.';
                        }
                        if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct=Product(
                          id: _editedProduct.id,
                          isFav:_editedProduct.isFav,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          imageUrl: value!,
                          description: _editedProduct.description,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}