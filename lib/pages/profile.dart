import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String _email = '';
  String _name = '';
  String _imageUrl = 'images/av.jpg'; // Default image
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Fetch the logged-in user's data
  Future<void> _getUserData() async {
    _user = _auth.currentUser;
    print('Fetched user : ${_user.toString()}');
    if (_user != null) {
      try {
        // Check for the user data in Firestore
        DocumentSnapshot userData =
            await _firestore.collection('User').doc(_user!.uid).get();

        Map<String, dynamic>? data = userData.data() as Map<String, dynamic>?;

        if (data != null) {
          setState(() {
            _email = _user!.email ??
                'No Email'; // Directly use the email from FirebaseAuth
            _name = data['Name'] ?? 'No Name'; // Fetch name from Firestore
            _imageUrl = data['Images'] ??
                'images/av.jpg'; // Default to avatar image if not available
            _nameController.text = _name;
          });
        } else {
          // Handle document not existing
          setState(() {
            _email = _user!.email ?? 'No Email';
            _name = _user!.displayName ?? 'No Name'; // Fallback to displayName
            _imageUrl = 'images/av.jpg';
          });
        }
      } catch (e) {
        // Handle errors (e.g., permission issues, Firestore connectivity issues)
        print('Error fetching user data: $e');
      }
    }
  }

  // Update user data in Firestore
  // Update user data in Firestore
  Future<void> _updateUserData() async {
    if (_user != null) {
      try {
        // Fetch the user's document from Firestore
        DocumentSnapshot userData =
            await _firestore.collection('User').doc(_user!.uid).get();

        // Debugging: Log the document snapshot data
        print('Fetched user document: ${userData.data()}');

        if (userData.exists) {
          // If document exists, update the "Name" field
          await _firestore.collection('User').doc(_user!.uid).update({
            'Name': _nameController.text,
          });

          setState(() {
            _name = _nameController.text;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        } else {
          // If document does not exist, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No profile found to update')),
          );
        }
      } catch (e) {
        // Handle any errors
        print('Error updating user data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display Profile Image (Non-editable)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageUrl.startsWith('http')
                        ? NetworkImage(_imageUrl)
                        : AssetImage(_imageUrl) as ImageProvider,
                  ),
                  const SizedBox(height: 20),

                  // Display Email (Non-editable)
                  Text('Email: $_email', style: const TextStyle(fontSize: 18)),

                  const SizedBox(height: 10),

                  // Update Name Field
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 20),

                  // Save Changes Button
                  ElevatedButton(
                    onPressed: _updateUserData,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
    );
  }
}
