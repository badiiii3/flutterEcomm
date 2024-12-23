import 'dart:io';
import 'package:e_commerce/services/database.dart';
import 'package:e_commerce/widget/support_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_admin.dart'; // Import the HomeAdmin page

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> categoryItems = [];
  String? selectedCategory;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch categories when the screen loads
  }

  Future<void> fetchCategories() async {
    try {
      final response = await supabase.from('categories').select(
          'id,name'); // Assuming you have a 'categories' table with 'id' and 'category_name'

      // Extract the category name and id from the response
      setState(() {
        categoryItems = List<Map<String, dynamic>>.from(
            response.map((item) => {'id': item['id'], 'name': item['name']}));
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  uploadItem() async {
    if (selectedImage != null &&
        nameController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        detailController.text.isNotEmpty &&
        selectedCategory != null) {
      try {
        String addId = randomAlphaNumeric(10);

        // Find the selected category ID
        final selectedCategoryItem = categoryItems
            .firstWhere((category) => category['name'] == selectedCategory);
        final categoryId = selectedCategoryItem['id'];

        // Upload the file to Supabase Storage
        final supabase = Supabase.instance.client;
        final bucketName = 'productImages';
        final filePath = '$addId/${selectedImage!.path.split('/').last}';

        final file = selectedImage!;
        await supabase.storage.from(bucketName).upload(filePath, file);

        // Get the public URL of the uploaded image
        final downloadUrl =
            supabase.storage.from(bucketName).getPublicUrl(filePath);

        // Prepare the product data
        Map<String, dynamic> addProduct = {
          "name": nameController.text,
          "price": priceController.text,
          "detail": detailController.text,
          "category_id":
              categoryId, // Store category_id instead of category_name
          "image_url": downloadUrl,
        };

        // Insert product data into Supabase table
        final response = await supabase
            .from('products')
            .insert(addProduct)
            .select() // Use .select() instead of .execute()
            .single(); // This ensures you insert one product

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Product has been added successfully!",
              style: TextStyle(fontSize: 18.0),
            ),
          ));

          // Redirect to HomeAdmin page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeAdmin()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Failed to upload product.",
              style: TextStyle(fontSize: 16.0),
            ),
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Failed to upload product: $e",
            style: TextStyle(fontSize: 16.0),
          ),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Please fill all the fields and upload an image!",
          style: TextStyle(fontSize: 16.0),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Color(0xFF373866),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Add Product",
          style: AppWidget.boldTextFeildStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload the Product Image",
                style: AppWidget.semiBoldTextFieldStyle(),
              ),
              SizedBox(height: 20.0),
              selectedImage == null
                  ? GestureDetector(
                      onTap: getImage,
                      child: Center(
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 30.0),
              Text(
                "Product Name",
                style: AppWidget.semiBoldTextFieldStyle(),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Product Name",
                      hintStyle: AppWidget.lightTextFeildStyle()),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Product Price",
                style: AppWidget.semiBoldTextFieldStyle(),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Product Price",
                      hintStyle: AppWidget.lightTextFeildStyle()),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Product Detail",
                style: AppWidget.semiBoldTextFieldStyle(),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  maxLines: 6,
                  controller: detailController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Product Detail",
                      hintStyle: AppWidget.lightTextFeildStyle()),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                "Select Category",
                style: AppWidget.semiBoldTextFieldStyle(),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                  items: categoryItems
                      .map((item) => DropdownMenuItem<String>(
                          value: item['name'], // Ensure we use the name
                          child: Text(
                            item['name'],
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                          )))
                      .toList(),
                  onChanged: ((value) => setState(() {
                        selectedCategory = value;
                      })),
                  dropdownColor: Colors.white,
                  hint: Text("Select Category"),
                  iconSize: 36,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  value: selectedCategory, // Set value to category name
                )),
              ),
              SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                onTap: () {
                  uploadItem();
                },
                child: Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
