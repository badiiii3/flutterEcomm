import 'package:e_commerce/pages/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryDetail extends StatefulWidget {
  final String categoryName;

  const CategoryDetail({super.key, required this.categoryName});

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      // Step 1: Fetch category id using the category name (e.g. 'Laptops')
      final categoryResponse = await supabase
          .from('categories')
          .select('id')
          .eq('name', widget.categoryName)
          .single();

      // Ensure we get the category id
      if (categoryResponse != null) {
        final categoryId = categoryResponse['id'];

        // Step 2: Use the category_id to fetch products
        final response = await supabase
            .from('products')
            .select('*')
            .eq('category_id', categoryId); // Use category_id here

        print("Response: $response");

        setState(() {
          products = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      } else {
        print('Category not found: ${widget.categoryName}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.categoryName} Products"),
        backgroundColor: Color(0xFFfd6f3e),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(child: Text("No products available in this category."))
              : ListView.builder(
                  padding: EdgeInsets.all(20.0),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetail(product: product),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Image.network(
                              product["image_url"],
                              height: 130.0,
                              width: 150.0,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              product["name"],
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$${product["price"]}",
                                  style: TextStyle(
                                    color: Color(0xFFfd6f3e),
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFfd6f3e),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.add, color: Colors.white),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
