import 'package:flutter/material.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_text.dart';
import 'package:mye_commerce/presentation/cart/ui/widget/cancel_services.dart';
import 'package:mye_commerce/presentation/cart/ui/widget/complete_services.dart';
import 'package:mye_commerce/presentation/cart/ui/widget/pending_services.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColor.text,
        appBar: AppBar(
          backgroundColor: AppColor.text,
          elevation: 0,
          scrolledUnderElevation: 0,

          title: const CustomText(
            text: "Orders",

            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
          bottom: const TabBar(
            dividerColor: Colors.transparent, // Removes the grey bottom underline
            indicatorColor: AppColor.primary,
            labelColor: AppColor.primary,
            unselectedLabelColor: AppColor.secondaryText,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            indicatorWeight: 3,
            tabs: [

              Tab(text: "Pending"),
              Tab(text: "Complete"),
              Tab(text: "Cancel"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
           PendingServices(),
            CompleteServices(),
            CancelServices(),
          ],
        ),
      ),
    );
  }
}