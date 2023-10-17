import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:chat_basic/utils/snackbar.dart';
import 'package:chat_basic/widgets/image_input.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoginPage = true;
  bool _isPasswordVisible = false;
  var _email = '';
  var _username = '';
  var _password = '';
  File? _selectedImage;

  void _selectImage(File image) {
    _selectedImage = image;
  }

  void _submit() async {
    bool isValid = _formKey.currentState!.validate();
    if (!_isLoginPage && _selectedImage == null) {
      showSnackBar(context, 'Please select an image');
      return;
    }
    if (!isValid) return;
    _formKey.currentState!.save();

    final firebaseAuthInstance = FirebaseAuth.instance;
    try {
      if (_isLoginPage) {
        // When Logging in
        await firebaseAuthInstance.signInWithEmailAndPassword(
            email: _email, password: _password);
      } else {
        // When Signing up
        final userCredential = await firebaseAuthInstance
            .createUserWithEmailAndPassword(email: _email, password: _password);

        final storageInstance = FirebaseStorage.instance;
        final refToImage = storageInstance
            .ref()
            .child('users_profile_images')
            .child('${userCredential.user!.uid}.jpg');

        await refToImage.putFile(_selectedImage!);
        final imageUrl = await refToImage.getDownloadURL();

        final firestoreInstance = FirebaseFirestore.instance;
        await firestoreInstance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'userId': userCredential.user!.uid,
          'email': _email,
          'userName': _username,
          'imageUrl': imageUrl,
        });
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
    // _email.log();
    // _username.log();
    // _password.log();
    // _selectedImage?.path.log();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: PageSurrounding(
        children: [
          const TopImage(),
          CardSurrounding(
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLoginPage)
                      ImageInput(
                        onSelectImage: _selectImage,
                        initialImage: _selectedImage,
                      ),
                    _emailInputField(context),
                    if (!_isLoginPage)
                      _usernameInputField(
                        context,
                      ),
                    _passwordInputField(context),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer),
                      child: Text(_isLoginPage ? 'Login' : 'Sign Up'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLoginPage = !_isLoginPage;
                        });
                      },
                      child: Text(
                        '${_isLoginPage ? 'Sign Up' : 'Login'} Instead',
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  TextFormField _passwordInputField(BuildContext context) {
    return TextFormField(
      key: const ValueKey('password'),
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
              !_isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          labelText: 'Enter password'),
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
      obscureText: !_isPasswordVisible,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      validator: (value) {
        if (value == null || value.isEmpty || value.length <= 5) {
          return 'Enter password having at least 6 characters';
        }
        return null;
      },
      onSaved: (newValue) {
        _password = newValue!;
      },
    );
  }

  TextFormField _usernameInputField(BuildContext context) {
    return TextFormField(
      key: const ValueKey('userName'),
      initialValue: _username,
      decoration: const InputDecoration(labelText: 'Enter your Name'),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      validator: _isLoginPage
          ? null
          : (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter username';
              }
              return null;
            },
      onChanged: _isLoginPage
          ? null
          : (newValue) {
              _username = newValue;
            },
    );
  }

  TextFormField _emailInputField(BuildContext context) {
    return TextFormField(
      key: const ValueKey('email'),
      decoration: const InputDecoration(labelText: 'Enter your email'),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      validator: (value) {
        if (value == null || value.trim().isEmpty || !value.contains('@')) {
          return 'Enter correct email id';
        }
        return null;
      },
      onSaved: (newValue) {
        _email = newValue!;
      },
    );
  }
}

class TopImage extends StatelessWidget {
  const TopImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.asset(
        'assets/auth.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}

class CardSurrounding extends StatelessWidget {
  final Widget child;
  const CardSurrounding({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ));
  }
}

class PageSurrounding extends StatelessWidget {
  final List<Widget> children;
  const PageSurrounding({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
