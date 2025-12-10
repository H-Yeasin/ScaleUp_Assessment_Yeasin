import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taskdirectory/task/task2_product/product_model.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;
  var allProducts = <ProductModel>[].obs;
  var displayedProducts = <ProductModel>[].obs;
  var categories = <String>['ALL'].obs;
  var selectedCategory = 'All'.obs;

  //search Text Controller
  var searchText = ''.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        //1.parse data
        var parsedList = data
            .map((json) => ProductModel.fromJson(json))
            .toList();
        allProducts.assignAll(parsedList);
        displayedProducts.assignAll(parsedList);

        //2.Extract Catrgories
        var apiCategories = parsedList
            .map((e) => e.category.toString())
            .toList();
        //Create a Set to remove duplicates automatically
        Set<String> uniqueSet = {'ALL'}; //start with all
        uniqueSet.addAll(apiCategories);

        //Assign back to observable list
        categories.assignAll(uniqueSet.toList());

        //Safety Check: If the currently selected category is no longer in the list, reset to 'All'
        if (!categories.contains(selectedCategory.value)) {
          selectedCategory.value = 'ALL';
        }
      } else {
        Get.snackbar("Error", "Server returned ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Faild to load products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //Search Logic
  void searchProducts(String query) {
    searchText.value = query;
    _applyFilters();
  }

  //Category Logic
  void filterByCategory(String? category) {
    selectedCategory.value = category ?? 'ALL';
    _applyFilters();
  }

  ////Unified Filter (Search + Category)
  void _applyFilters() {
    List<ProductModel> temp = allProducts;
    // Category Filter
    if (selectedCategory.value != 'ALL') {
      temp = temp.where((p) => p.category == selectedCategory.value).toList();
    }
    // Search Filter
    if (searchText.value.isNotEmpty) {
      temp = temp
          .where(
            (p) =>
                p.title.toLowerCase().contains(searchText.value.toLowerCase()),
          )
          .toList();
    }
    displayedProducts.assignAll(temp);
  }
}
