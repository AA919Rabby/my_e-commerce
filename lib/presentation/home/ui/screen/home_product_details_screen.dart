import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';

import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_button.dart';
import 'package:mye_commerce/global/custom_text.dart';

import 'package:mye_commerce/presentation/home/data/product_details_model.dart';

class HomeProductDetailsScreen extends StatelessWidget {
  const HomeProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductDetails product =
    Get.arguments as ProductDetails;

    return Scaffold(
      backgroundColor: AppColor.text,

      // ================================================================
      // APP BAR
      // ================================================================

      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.black,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),

        title: CustomText(
          text: product.title ?? "Service Details",
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColor.black,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite_border_rounded,
              color: AppColor.black,
            ),
            onPressed: () {},
          ),
          const Gap(10),
        ],
      ),

      // ================================================================
      // BODY
      // ================================================================

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            // ==========================================================
            // 1. SERVICE IMAGE
            // ==========================================================

            Container(
              height: 270.h,
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset:
                    const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(14.r),
                child: product.imageUrl != null &&
                    product.imageUrl!.isNotEmpty
                    ? Image.network(
                  product.imageUrl!,
                  fit: BoxFit.contain,
                  webHtmlElementStrategy:
                  WebHtmlElementStrategy
                      .prefer,
                  errorBuilder:
                      (context, error, stackTrace) {
                    return Icon(
                      Icons.image_outlined,
                      size: 60.sp,
                      color: Colors.grey,
                    );
                  },
                )
                    : Icon(
                  Icons.image_outlined,
                  size: 60.sp,
                  color: Colors.grey,
                ),
              ),
            ),

            const Gap(16),

            // ==========================================================
            // 2. CATEGORY
            // ==========================================================

            if (product.category != null &&
                product.category!.isNotEmpty)
              CustomText(
                text:
                product.category!.toUpperCase(),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color:
                AppColor.secondaryText,
              ),

            const Gap(5),

            // ==========================================================
            // 3. SERVICE TITLE
            // ==========================================================

            CustomText(
              text:
              product.title ?? "Service",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),

            const Gap(10),

            // ==========================================================
            // 4. RATING + REVIEWS + AVAILABILITY
            // ==========================================================

            Row(
              children: [
                Container(
                  padding:
                  EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor
                        .drawerGradient1
                        .withOpacity(0.18),
                    borderRadius:
                    BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppColor
                            .drawerGradient1,
                        size: 18.sp,
                      ),

                      const Gap(4),

                      CustomText(
                        text:
                        "${product.rating ?? 0}",
                        fontSize: 13,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        AppColor.black,
                      ),
                    ],
                  ),
                ),

                const Gap(8),

                CustomText(
                  text:
                  "${product.totalReviews ?? 0} Reviews",
                  fontSize: 12,
                  color:
                  AppColor.secondaryText,
                ),

                const Spacer(),

                Container(
                  padding:
                  EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: product.isAvailable ==
                        true
                        ? Colors.green
                        .withOpacity(0.12)
                        : Colors.red
                        .withOpacity(0.12),
                    borderRadius:
                    BorderRadius.circular(8.r),
                  ),
                  child: CustomText(
                    text: product.isAvailable ==
                        true
                        ? "Available"
                        : "Unavailable",
                    fontSize: 11,
                    fontWeight:
                    FontWeight.bold,
                    color: product.isAvailable ==
                        true
                        ? Colors.green.shade800
                        : Colors.red.shade800,
                  ),
                ),
              ],
            ),

            const Gap(16),

            // ==========================================================
            // 5. PRICE
            // ==========================================================

            CustomText(
              text:
              "৳${product.priceBdt ?? 0}",
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color:
              AppColor.drawerGradient1,
            ),

            const Gap(20),

            // ==========================================================
            // 6. DESCRIPTION
            // ==========================================================

            CustomText(
              text: "Description",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),

            const Gap(7),

            CustomText(
              text: product.description ??
                  "No description available.",
              fontSize: 13,
              color:
              AppColor.secondaryText,
            ),

            const Gap(22),

            // ==========================================================
            // 7. LOCATION
            // ==========================================================

            if (product.locationArea != null &&
                product.locationArea!.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(14.r),
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color:
                      AppColor.drawerGradient1,
                      size: 22.sp,
                    ),

                    const Gap(10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          CustomText(
                            text: "Service Area",
                            fontSize: 12,
                            fontWeight:
                            FontWeight.bold,
                            color:
                            AppColor.black,
                          ),

                          const Gap(3),

                          CustomText(
                            text:
                            product.locationArea!,
                            fontSize: 13,
                            color:
                            AppColor.secondaryText,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const Gap(12),

            // ==========================================================
            // 8. SERVICE PERSONS
            // ==========================================================

            if (product.servicePersons != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      color:
                      AppColor.drawerGradient1,
                      size: 22.sp,
                    ),

                    const Gap(10),

                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        CustomText(
                          text:
                          "Service Persons",
                          fontSize: 12,
                          fontWeight:
                          FontWeight.bold,
                          color:
                          AppColor.black,
                        ),

                        const Gap(3),

                        CustomText(
                          text:
                          "${product.servicePersons} Person${product.servicePersons == 1 ? '' : 's'}",
                          fontSize: 13,
                          color:
                          AppColor.secondaryText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const Gap(12),

            // ==========================================================
            // 9. STOCK
            // ==========================================================

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    color:
                    AppColor.drawerGradient1,
                    size: 22.sp,
                  ),

                  const Gap(10),

                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Stock",
                        fontSize: 12,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        AppColor.black,
                      ),

                      const Gap(3),

                      CustomText(
                        text:
                        "${product.stock ?? 0} available",
                        fontSize: 13,
                        color:
                        AppColor.secondaryText,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Gap(22),

            // ==========================================================
            // 10. CUSTOMER REVIEWS
            // ==========================================================

            CustomText(
              text: "Customer Reviews",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),

            const Gap(10),

            if (product.reviews != null &&
                product.reviews!.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount:
                product.reviews!.length,
                separatorBuilder:
                    (context, index) =>
                const Gap(10),
                itemBuilder:
                    (context, index) {
                  final review =
                  product.reviews![index];

                  return Container(
                    width: double.infinity,
                    padding:
                    EdgeInsets.all(12.r),
                    decoration:
                    BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(
                          12.r),
                    ),
                    child: CustomText(
                      text: review.toString(),
                      fontSize: 13,
                      color:
                      AppColor.secondaryText,
                    ),
                  );
                },
              )
            else
              CustomText(
                text: "No reviews yet.",
                fontSize: 13,
                color:
                AppColor.secondaryText,
              ),

            const Gap(90),
          ],
        ),
      ),

      // ================================================================
      // BOTTOM BUTTON
      // ================================================================

      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.only(
            topLeft:
            Radius.circular(24.r),
            topRight:
            Radius.circular(24.r),
          ),
          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset:
              const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "Add to Cart",
                  backgroundColor:
                  AppColor.drawerGradient1,
                  textColor:
                  AppColor.black,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}