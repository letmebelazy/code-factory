import 'package:code_factory/common/component/pagination_list_view.dart';
import 'package:code_factory/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import '../component/restaurant_card.dart';
import '../provider/restaurant_provider.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(id: model.id),
              ),
            );
          },
          child: RestaurantCard.fromModel(
            model: model,
          ),
        );
      },
    );
  }
}
