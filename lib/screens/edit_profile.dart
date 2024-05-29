import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? _user;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _selectedGender;

  // Text controllers for user data fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Image-related variables
  File? _imageFile; // Store the selected image file
  String imageUrl = ""; // Store the image URL from Firestore

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    print(_storage.bucket); // Print the bucket name (optional)
    _loadUserData(); // Load the user's data when the screen initializes
  }

  // Function to load user data from Firestore
  Future<void> _loadUserData() async {
    if (_user != null) {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('Customers').doc(_user!.uid).get();
      if (userSnapshot.exists) {
        setState(() {
          _nameController.text = userSnapshot['fullName'];
          _userNameController.text = userSnapshot['username'];
          _mobileController.text = userSnapshot['mobileNo'];
          _emailController.text = userSnapshot['email'];
          imageUrl = userSnapshot['imageUrl'];
          _selectedGender = userSnapshot['gender']; // Get existing image URL
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    if (_formKey.currentState!.validate()) {
      try {
        // ... your existing form validation logic ...

        if (_imageFile != null) {
          // Upload the new image to Firebase Storage if one is selected
          final ref =
              _storage.ref().child('user_profiles').child('${_user!.uid}.jpg');
          await ref.putFile(_imageFile!);
          imageUrl = await ref.getDownloadURL(); // Get the new image URL
        }

        // Update the user data in Firestore
        await _firestore.collection('Customers').doc(_user!.uid).update({
          'fullName': _nameController.text,
          'username': _userNameController.text,
          'mobileNo': _mobileController.text,
          'email': _emailController.text,
          'imageUrl': imageUrl,
          'gender': _selectedGender, // Update the imageUrl if changed
        });

        // Show a success message (you can customize this)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Profile updated successfully'),
                ],
              ),
            ),
          ),
        );

        Navigator.pop(context); // Go back to the profile screen
      } catch (e) {
        // ... (your error handling)
      }
      setState(() => _isLoading = false);
    }
  }

  // Function to pick an image from the gallery or camera
  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF62BDBD),
        elevation: 1,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set color of back button
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF62BDBD), Color(0xFF438D8D)],
              ),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              Colors.white, // Avatar background color
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : (imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl) as ImageProvider?
                                  : null), // Use null if no image
                          child: _imageFile == null && imageUrl.isEmpty
                              ? // Avatar background color
                              const Icon(
                                  Icons.person,
                                  color: Color(0xFF62BDBD), // Icon color
                                  size: 80,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 5,
                          right: 115,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF62BDBD),
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    width: 1), // Add a grey border
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Color.fromARGB(255, 255, 255, 255),
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _userNameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _mobileController,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        items: <String>['Male', 'Female']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 80),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.amber, // Change button color here
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          textStyle: const TextStyle(fontSize: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                            color: Color.fromARGB(
                                255, 255, 255, 255)), // Text color of Button
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ), // Loading indicator
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
