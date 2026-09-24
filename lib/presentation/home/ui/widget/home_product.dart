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

class HomeProduct extends StatelessWidget {
  const HomeProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Obx(() {
      if (homeController.isLoading2.value) {
        return  SizedBox(
          height: 0.4.sh,
          child: Center(
            child: CustomLoader(color: AppColor.drawerGradient1,),
          ),
        );
      }

      if (homeController.allProduct.isEmpty) {
        return SizedBox(
          height: 0.4.sh,
          child: const Center(
            child: CustomText(
              text: "No products found",
              fontSize: 20,
            ),
          ),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: homeController.allProduct.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          final product_model.Result product = homeController.allProduct[index];

          String? productImage;
          if (product.images != null && product.images!.isNotEmpty) {
            productImage = product.images!.first;
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Get.toNamed(AllRoute.productDetails);
            },
            child: Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: Colors.white, // FIX: Set to White so it's not "Black like something"
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
                        color: Colors.grey.shade100, // Light grey background for image
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: productImage != null && productImage.isNotEmpty
                            ? Image.network(
                          productImage,
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
                    text: product.name ?? "Product",
                    fontSize: 13.sp,
                    color: AppColor.black, // FIX: Black text so it's visible on white card
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Gap(5),

                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     CustomText(
                       text: "\$${product.price?.toStringAsFixed(2) ?? "0.00"}",
                       fontSize: 13.sp,
                       color: AppColor.drawerGradient1,
                       fontWeight: FontWeight.bold,
                     ),
                     Icon(Icons.shopping_cart_outlined,color: AppColor.drawerGradient2,)
                   ],
                 ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}