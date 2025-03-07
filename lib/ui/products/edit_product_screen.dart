import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../shared/dialog_utils.dart';
import 'products_manager.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  EditProductScreen(
    Product? product, {
    super.key,
  }) {
    if (product == null) {
      this.product = Product(
        id: null,
        title: '',
        cate: '',
        author: '',
        description: '',
        imageUrl: '',
      );
    } else {
      this.product = product;
    }
  }
  late final Product product;
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late Product _editedProduct;
  var _isLoading = false;
  bool _isValidImageUrl(String value) {
    return (value.startsWith('http')|| value.startsWith('https')) &&
      (value.endsWith('.png') ||
        value.endsWith('.jpg')||
        value.endsWith('jpeg'));
  }
  @override
  void initState() {
    _imageUrlFocusNode.addListener(() {
      if(!_imageUrlFocusNode.hasFocus){
        if(!_isValidImageUrl(_imageUrlController.text)){
          return;
        }
        setState(() {
          
        });
      }
    });
    _editedProduct=widget.product;
    _imageUrlController.text =_editedProduct.imageUrl;
    super.initState();
  }
  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }
  Future<void> _saveForm() async {
    final isValid= _editForm.currentState!.validate();
    if(!isValid){
      return;
    }
    _editForm.currentState!.save();

    setState((){
      _isLoading=true;
    });
    try{
      final productsManager = context.read<ProductsManager>();
      if(_editedProduct.id !=null){
        productsManager.updateProduct(_editedProduct);
      }else{
        productsManager.addProduct(_editedProduct);
      }
    }catch(error){
      if(mounted){
        await showErrorDialog(context, 'Something went wrong.');
      }
    }
    setState((){
      _isLoading=false;
    });
    if(mounted){
      Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hiệu chỉnh'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
        ? const Center(
          child: CircularProgressIndicator(),
        )
        : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key:_editForm,
            child: ListView(
              children: <Widget>[
                _buildTitleField(),
                _buildCateField(),
                _buildAuthorField(),
                _buildDescriptionField(),
                _buildProductPreview(),
              ],
            ),
          ),
        )
    );
  }
  TextFormField _buildTitleField(){
    return TextFormField(
      initialValue: _editedProduct.title,
      decoration: const InputDecoration(labelText: 'Tên'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value){
        if(value!.isEmpty){
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value){
        _editedProduct=_editedProduct.copyWith(title: value);
      },
    );
  }
  TextFormField _buildDescriptionField(){
    return TextFormField(
      initialValue: _editedProduct.description,
      decoration: const InputDecoration(labelText: 'Mô tả'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      validator: (value){
        if(value!.isEmpty){
          return 'Please enter a description.';
        }
        if(value.length <10){
          return 'Should be at least 10 characters long.';
        }
        return null;
      },
      onSaved: (value){
        _editedProduct=_editedProduct.copyWith(description: value);
      },
    );
  }
  
  Widget _buildProductPreview(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(top: 8,right: 10),
          decoration: BoxDecoration(
            border: Border.all(width: 1,color: Colors.grey),
          ),
          child: _imageUrlController.text.isEmpty
          ?const Text('Enter a URL')
          :FittedBox(
            child: Image.network(
              _imageUrlController.text,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: _buildImageURLField(),
        ),
      ],
    );
  }
  TextFormField _buildImageURLField(){
    return TextFormField(
      decoration: const InputDecoration(labelText: 'URL hình ảnh'),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      onFieldSubmitted: (value)=>_saveForm(),
      validator: (value){
        if(value!.isEmpty){
          return 'Please provide an image URL.';
        }
        if(!_isValidImageUrl(value)){
          return 'Please enter a valid image URL.';
        }
        return null;
      },
      onSaved: (value){
        _editedProduct=_editedProduct.copyWith(imageUrl: value);
      },
    );
  }
  
  TextFormField _buildCateField(){
    return TextFormField(
      initialValue: _editedProduct.cate,
      decoration: const InputDecoration(labelText: 'Thể loại'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value){
        if(value!.isEmpty){
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value){
        _editedProduct=_editedProduct.copyWith(cate: value);
      },
    );
  }
  TextFormField _buildAuthorField(){
    return TextFormField(
      initialValue: _editedProduct.author,
      decoration: const InputDecoration(labelText: 'Tác giả'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value){
        if(value!.isEmpty){
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value){
        _editedProduct=_editedProduct.copyWith(author: value);
      },
    );
  }
}

