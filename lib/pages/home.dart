import 'package:e_commerce/pages/ProductTile.dart';
import 'package:e_commerce/pages/categoryDetail.dart';
import 'package:e_commerce/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/widget/support_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> allProducts = [];
  bool isLoadingCategories = true;
  bool isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchAllProducts();
  }

  Future<void> fetchCategories() async {
    try {
      final response =
          await supabase.from('categories').select('id, name, image_url');

      setState(() {
        categories = List<Map<String, dynamic>>.from(response);
        isLoadingCategories = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() => isLoadingCategories = false);
    }
  }

  Future<void> _logout() async {
    try {
      await supabase.auth.signOut(); // Logout from Supabase
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Login()), // Navigate to Login page
      );
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  Future<void> fetchAllProducts() async {
    try {
      final response = await supabase.from('products').select('*');

      setState(() {
        allProducts = List<Map<String, dynamic>>.from(response);
        isLoadingProducts = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() => isLoadingProducts = false);
    }
  }

  // Function to get category name based on category_id
  String getCategoryName(int categoryId) {
    // Find the category with the matching id
    final category = categories.firstWhere(
      (category) => category['id'] == categoryId,
      orElse: () => {'name': 'Unknown'}, // Return 'Unknown' if not found
    );
    return category['name'];
  }

  void navigateToCategory(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetail(categoryName: categoryName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 223, 233, 235),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout, // Logout button
          ),
        ],
      ),
      body: isLoadingCategories || isLoadingProducts
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hey, Dear Client",
                              style: AppWidget.boldTextFeildStyle(),
                            ),
                            Text(
                              "Welcome Back",
                              style: AppWidget.lightTextFeildStyle(),
                            ),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            "images/av.jpg",
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Items...",
                          hintStyle: AppWidget.lightTextFeildStyle(),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Categories Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Categories",
                          style: AppWidget.semiBoldTextFieldStyle(),
                        ),
                        Text(
                          "see all",
                          style: AppWidget.orangeTextFieldStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 70,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                return GestureDetector(
                                  onTap: () =>
                                      navigateToCategory(category['name']),
                                  child: CategoryTile(
                                    image_url: category['image_url'],
                                    name: category['name'],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    // All Products Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "All Products",
                          style: AppWidget.semiBoldTextFieldStyle(),
                        ),
                        Text(
                          "see all",
                          style: AppWidget.orangeTextFieldStyle(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 220,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10)),
                                Image.asset(
                                  "images/headphones.jpg",
                                  height: 130.0,
                                  width: 150.0,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  "Headphone",
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                ),
                                Row(
                                  children: [
                                    Text("\$100",
                                        style: TextStyle(
                                            color: Color(0xFFfd6f3e),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFfd6f3e),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Icon(Icons.add,
                                            color: Colors.white))
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10)),
                                Image.asset(
                                  "images/iphone14.png",
                                  height: 130.0,
                                  width: 150.0,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  "Iphone 14 Pro",
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                ),
                                Row(
                                  children: [
                                    Text("\$1400",
                                        style: TextStyle(
                                            color: Color(0xFFfd6f3e),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFfd6f3e),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Icon(Icons.add,
                                            color: Colors.white))
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10)),
                                Image.asset(
                                  "images/watch1.png",
                                  height: 130.0,
                                  width: 150.0,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  "Watch",
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                ),
                                Row(
                                  children: [
                                    Text("\$250",
                                        style: TextStyle(
                                            color: Color(0xFFfd6f3e),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFfd6f3e),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Icon(Icons.add,
                                            color: Colors.white))
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: allProducts.length,
                        itemBuilder: (context, index) {
                          final product = allProducts[index];
                          String categoryName =
                              getCategoryName(product['category_id']);
                          return ProductTile(
                            image: product['image_url'],
                            name: product['name'],
                            price: double.parse(product['price']),
                            category:
                                categoryName, // Pass category to the widget
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String image_url;
  final String name;

  const CategoryTile({super.key, required this.image_url, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      margin: const EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 90,
      width: 90,
      child: Column(
        children: [
          // Change Image.asset to Image.network to load the image from a URL
          Image.network(
            image_url,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
