import 'package:code_factory/common/component/pagination_list_view.dart';
import 'package:code_factory/product/component/product_card.dart';
import 'package:code_factory/product/model/product_model.dart';
import 'package:code_factory/product/provider/product_provider.dart';
import 'package:code_factory/restaurant/model/restaurant_detail_model.dart';
import 'package:code_factory/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, index, model) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(
                    id: model.restaurant.id,
                  ),
                ),
              );
            },
            child: ProductCard.fromProductModel(model: model),
          );
        });
  }
}
