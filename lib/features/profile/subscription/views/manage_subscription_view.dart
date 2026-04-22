import 'package:examtest/core/utils/app_colors.dart';
import 'package:examtest/core/widgets/custom_button.dart';
import 'package:examtest/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ManageSubscriptionView extends StatelessWidget {
  const ManageSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Subscription',
          color: Colors.white,
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          Expanded(
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.85),
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildSubscriptionCard(
                  planName: index == 0 ? 'Basic Plan' : index == 1 ? 'Standard Plan' : 'Premium Plan',
                  price: index == 0 ? '14' : index == 1 ? '29' : '49',
                );
              },
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard({required String planName, required String price}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: const Color(0xff2A2A2A),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: planName,
            color: Colors.white,
            fontsize: 32.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 10.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '\$',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: price,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' /month',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: ListView.builder(
              itemCount: 9,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: AppColors.greenColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      CustomText(
                        text: 'Add your quote',
                        color: Colors.grey.shade300,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
          CustomButton(
            title: 'Upgrade',
            onpress: () {},
            color: AppColors.greenColor,
            titlecolor: Colors.white,
            width: double.infinity,
            height: 52.h,
            bordercolor: AppColors.greenColor,
          ),
        ],
      ),
    );
  }
}
