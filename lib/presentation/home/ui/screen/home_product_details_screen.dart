import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/core/theme/app_color.dart';
import 'package:mye_commerce/global/custom_button.dart';
import 'package:mye_commerce/global/custom_text.dart';

// Import your details model
import 'package:mye_commerce/presentation/home/data/product_details_model.dart';

class HomeProductDetailsScreen extends StatelessWidget {
  const HomeProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // RECEIVES THE MODEL DIRECTLY FROM YOUR PREVIOUS SCREEN
    final Result product = Get.arguments is ProductDetails
        ? (Get.arguments as ProductDetails).result ?? Result()
        : Get.arguments as Result;

    return Scaffold(
      backgroundColor: AppColor.text,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: product.name ?? "Product Details",
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColor.black,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: AppColor.black),
            onPressed: () {},
          ),
          const Gap(10)
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================================
            // 1. PRODUCT IMAGES (WITH WEB FIX)
            // ============================================================
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
                child: (product.images != null && product.images!.isNotEmpty)
                    ? Image.network(
                  product.images!.first,
                  fit: BoxFit.contain,
                  webHtmlElementStrategy: WebHtmlElementStrategy.prefer, // FIX FOR FLUTTER WEB
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_outlined,
                    size: 60.sp,
                    color: Colors.grey,
                  ),
                )
                    : Icon(Icons.image_outlined, size: 60.sp, color: Colors.grey),
              ),
            ),

            const Gap(16),

            // ============================================================
            // 2. BRAND & TITLE
            // ============================================================
            if (product.brand != null && product.brand!.isNotEmpty)
              CustomText(
                text: product.brand!.toUpperCase(),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColor.secondaryText,
              ),

            const Gap(4),

            CustomText(
              text: product.name ?? "Product Name",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),

            const Gap(10),

            // ============================================================
            // 3. RATING & REVIEWS
            // ============================================================
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

                if (product.reviews != null && product.reviews!.isNotEmpty)
                  CustomText(
                    text: "(${product.reviews!.length} reviews)",
                    fontSize: 12,
                    color: AppColor.secondaryText,
                  ),

                const Spacer(),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: CustomText(
                    text: product.availability ?? "In Stock",
                    fontSize: 12,
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Gap(16),

            // ============================================================
            // 4. PRICE
            // ============================================================
            CustomText(
              text: "\$${product.price?.toStringAsFixed(2) ?? "0.00"}",
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColor.drawerGradient1,
            ),

            const Gap(18),

            // ============================================================
            // 5. VARIANTS
            // ============================================================
            if (product.varients != null && product.varients!.isNotEmpty) ...[
              CustomText(
                text: "Available Variants",
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
              const Gap(8),
              SizedBox(
                height: 38.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: product.varients!.length,
                  separatorBuilder: (context, index) => Gap(8.w),
                  itemBuilder: (context, index) {
                    final variant = product.varients![index];

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: index == 0 ? AppColor.drawerGradient1 : Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: index == 0 ? AppColor.drawerGradient1 : Colors.grey.shade300,
                        ),
                      ),
                      child: Center(
                        child: CustomText(
                          text: variant.color ?? "Option ${index + 1}",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: index == 0 ? AppColor.black : AppColor.secondaryText,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Gap(18),
            ],

            // ============================================================
            // 6. DESCRIPTION
            // ============================================================
            CustomText(
              text: "Description",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),

            const Gap(6),

            CustomText(
              text: product.description ?? "No description available for this product.",
              fontSize: 13,
              color: AppColor.secondaryText,
            ),

            const Gap(24),

            // ============================================================
            // 7. USER REVIEWS SECTION (Mapped from your model)
            // ============================================================
            CustomText(
              text: "Customer Reviews",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
            const Gap(10),

            if (product.reviews != null && product.reviews!.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: product.reviews!.length,
                separatorBuilder: (context, index) => const Gap(12),
                itemBuilder: (context, index) {
                  final review = product.reviews![index];
                  final user = review.user;

                  return Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: (user?.profileImage != null && user!.profileImage!.isNotEmpty)
                                  ? NetworkImage(user.profileImage!)
                                  : null,
                              child: (user?.profileImage == null || user!.profileImage!.isEmpty)
                                  ? const Icon(Icons.person, color: Colors.grey)
                                  : null,
                            ),
                            const Gap(10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: "${user?.firstName ?? 'Unknown'} ${user?.lastName ?? ''}".trim(),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.black,
                                  ),
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      return Icon(
                                        starIndex < (review.rating ?? 0) ? Icons.star : Icons.star_border,
                                        size: 14.r,
                                        color: Colors.amber,
                                      );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        CustomText(
                          text: review.comment ?? "No comment provided.",
                          fontSize: 13,
                          color: AppColor.secondaryText,
                        ),
                      ],
                    ),
                  );
                },
              )
            else
              CustomText(
                text: "No reviews yet.",
                fontSize: 13,
                color: AppColor.secondaryText,
              ),

            const Gap(80),
          ],
        ),
      ),

      // ============================================================
      // 8. BOTTOM BAR
      // ============================================================
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
                  text: "Add to Cart",
                  backgroundColor: AppColor.drawerGradient1,
                  textColor: AppColor.black,
                  onPressed: () {
                    // Add to cart
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