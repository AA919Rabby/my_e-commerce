import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/all_route.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_button.dart';
import 'package:mye_commerce/global/custom_loader.dart';
import 'package:mye_commerce/global/custom_text.dart';
import 'package:mye_commerce/presentation/home/data/product_details_model.dart';
import '../../data/review_model.dart';
import '../../../cart/controller/cart_controller.dart';

class HomeProductDetailsScreen extends StatefulWidget {
  const HomeProductDetailsScreen({super.key});

  @override
  State<HomeProductDetailsScreen> createState() => _HomeProductDetailsScreenState();
}

class _HomeProductDetailsScreenState extends State<HomeProductDetailsScreen> {
  late final CartController cartController;
  late final ProductDetails product;

  @override
  void initState() {
    super.initState();
    product = Get.arguments as ProductDetails;
    // Find or put CartController
    cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    // Fetch the latest reviews from the backend as soon as this screen opens!
    if (product.id != null) {
      cartController.fetchServiceReviews(product.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.text,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColor.drawerGradient1,
        elevation: 0,
        leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back,color: AppColor.text,)),
        title: CustomText(
          text: product.title ?? "Service Details",
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColor.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. SERVICE IMAGE
            Container(
              height: 270.h,
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? Image.network(
                  product.imageUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
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

            // 2. CATEGORY
            if (product.category != null && product.category!.isNotEmpty)
              CustomText(
                text: product.category!.toUpperCase(),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColor.secondaryText,
              ),
            const Gap(5),

            // 3. SERVICE TITLE
            CustomText(
              text: product.title ?? "Service",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
            const Gap(10),

            // 4. RATING + REVIEWS + AVAILABILITY
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColor.drawerGradient1.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star_rounded, color: AppColor.drawerGradient1, size: 18.sp),
                      const Gap(4),
                      CustomText(
                        text: "${product.rating ?? 0}",
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                Obx(() {
                  final dynamicReviewCount = cartController.serviceReviewsList.isNotEmpty
                      ? cartController.serviceReviewsList.length
                      : (product.totalReviews ?? 0);
                  return CustomText(
                    text: "$dynamicReviewCount Reviews",
                    fontSize: 12,
                    color: AppColor.secondaryText,
                  );
                }),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: product.isAvailable == true
                        ? Colors.green.withOpacity(0.12)
                        : Colors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: CustomText(
                    text: product.isAvailable == true ? "Available" : "Unavailable",
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: product.isAvailable == true ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                ),
              ],
            ),
            const Gap(16),

            // 5. PRICE
            CustomText(
              text: "৳${product.priceBdt ?? 0}",
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColor.drawerGradient1,
            ),
            const Gap(20),

            // 6. DESCRIPTION
            CustomText(
              text: "Description",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
            const Gap(7),
            CustomText(
              text: product.description ?? "No description available.",
              fontSize: 13,
              color: AppColor.secondaryText,
            ),
            const Gap(22),

            // 7. LOCATION
            if (product.locationArea != null && product.locationArea!.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_outlined, color: AppColor.drawerGradient1, size: 22.sp),
                    const Gap(10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: "Service Area", fontSize: 12, fontWeight: FontWeight.bold, color: AppColor.black),
                          const Gap(3),
                          CustomText(text: product.locationArea!, fontSize: 13, color: AppColor.secondaryText),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const Gap(12),

            // 8. SERVICE PERSONS
            if (product.servicePersons != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.people_outline, color: AppColor.drawerGradient1, size: 22.sp),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "Service Persons", fontSize: 12, fontWeight: FontWeight.bold, color: AppColor.black),
                        const Gap(3),
                        CustomText(text: "${product.servicePersons} Person${product.servicePersons == 1 ? '' : 's'}", fontSize: 13, color: AppColor.secondaryText),
                      ],
                    ),
                  ],
                ),
              ),
            const Gap(12),

            // 9. STOCK
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.inventory_2_outlined, color: AppColor.drawerGradient1, size: 22.sp),
                  const Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Remaining", fontSize: 12, fontWeight: FontWeight.bold, color: AppColor.black),
                      const Gap(3),
                      CustomText(text: "${product.stock ?? 0} available", fontSize: 13, color: AppColor.secondaryText),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(22),

            // 10. CUSTOMER REVIEWS (LIVE OBSERVABLE WITH OBX)
            CustomText(
              text: "Customer Reviews",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
            const Gap(10),

            Obx(() {
              if (cartController.isFetchingReviews.value) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0.r),
                    child: CustomLoader(),
                  ),
                );
              }

              // Use live fetched reviews if available, otherwise check product.reviews
              List<dynamic> displayReviews = [];
              if (cartController.serviceReviewsList.isNotEmpty) {
                displayReviews = cartController.serviceReviewsList;
              } else if (product.reviews != null && product.reviews!.isNotEmpty) {
                displayReviews = product.reviews!;
              }

              if (displayReviews.isEmpty) {
                return CustomText(
                  text: "No reviews yet.",
                  fontSize: 13,
                  color: AppColor.secondaryText,
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayReviews.length,
                separatorBuilder: (context, index) => const Gap(10),
                itemBuilder: (context, index) {
                  final raw = displayReviews[index];
                  ReviewModel review;
                  if (raw is ReviewModel) {
                    review = raw;
                  } else if (raw is Map<String, dynamic>) {
                    review = ReviewModel.fromJson(raw);
                  } else {
                    review = ReviewModel(comment: raw.toString());
                  }

                  final reviewerName = review.userName ?? 'Anonymous Customer';
                  final commentText = review.comment ?? '';
                  final ratingVal = review.rating ?? 5;
                  final profilePic = review.userProfilePicture;

                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14.r,
                              backgroundColor: AppColor.drawerGradient1.withOpacity(0.15),
                              backgroundImage: (profilePic != null && profilePic.isNotEmpty)
                                  ? NetworkImage(profilePic)
                                  : null,
                              child: (profilePic == null || profilePic.isEmpty)
                                  ? Icon(Icons.person, size: 16.sp, color: AppColor.drawerGradient1)
                                  : null,
                            ),
                            const Gap(8),
                            Expanded(
                              child: CustomText(
                                text: reviewerName,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                            ),
                            Row(
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  starIndex < ratingVal ? Icons.star_rounded : Icons.star_outline_rounded,
                                  color: Colors.amber,
                                  size: 15.sp,
                                );
                              }),
                            ),
                          ],
                        ),
                        const Gap(8),
                        CustomText(
                          text: commentText,
                          fontSize: 12,
                          color: AppColor.secondaryText,
                        ),
                      ],
                    ),
                  );
                },
              );
            }),

            const Gap(90),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "Get Now",
                  backgroundColor: AppColor.drawerGradient1,
                  textColor: AppColor.text,
                  onPressed: () {
                    Get.toNamed(AllRoute.pushServices, arguments: product.id);
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