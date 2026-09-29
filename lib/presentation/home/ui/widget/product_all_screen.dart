import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';

import 'package:mye_commerce/all_route.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_loader.dart';
import 'package:mye_commerce/global/custom_text.dart';
import 'package:mye_commerce/presentation/home/controller/home_controller.dart';
import 'package:mye_commerce/presentation/home/data/all_product_model.dart' as product_model;
import 'package:mye_commerce/presentation/home/data/product_details_model.dart' as details;

class ProductAllScreen extends StatelessWidget {
  const ProductAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: InkWell(
           onTap: (){
             Get.back();
           },
            child: Icon(Icons.arrow_back)),
      ),
      body: Obx(() {
        if (homeController.isLoading2.value) {
          return const Center(
            child: CustomLoader(),
          );
        }

        if (homeController.allProduct.isEmpty) {
          return const Center(
            child: CustomText(
              text: "No products found",
              fontSize: 16,
              color: AppColor.secondaryText,
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(16.sp),
          shrinkWrap: true,
          itemCount: homeController.allProduct.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final product_model.Items product = homeController.allProduct[index];

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                final details.ProductDetails productDetails = details.ProductDetails(
                  id: product.id,
                  title: product.title,
                  category: product.category,
                  description: product.description,
                  priceBdt: product.priceBdt,
                  stock: product.stock,
                  imageUrl: product.imageUrl,
                  locationArea: product.locationArea,
                  servicePersons: product.servicePersons,
                  isAvailable: product.isAvailable,
                  rating: product.rating,
                  totalReviews: product.totalReviews,
                  reviews: null,
                );

                Get.toNamed(
                  AllRoute.productDetails,
                  arguments: productDetails,
                );
              },
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: product.imageUrl != null &&
                              product.imageUrl!.isNotEmpty
                              ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.contain,
                            webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image_outlined,
                                size: 45.sp,
                                color: Colors.grey,
                              );
                            },
                          )
                              : Icon(
                            Icons.image_outlined,
                            size: 45.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    const Gap(10),

                    CustomText(
                      text: product.title ?? "Service",
                      fontSize: 13,
                      color: AppColor.black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Gap(4),

                    CustomText(
                      text: product.category ?? "",
                      fontSize: 10,
                      color: AppColor.secondaryText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Gap(5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "৳${product.priceBdt ?? 0}",
                          fontSize: 16,
                          color: AppColor.drawerGradient1,
                          fontWeight: FontWeight.bold,
                        ),
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: AppColor.drawerGradient2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}