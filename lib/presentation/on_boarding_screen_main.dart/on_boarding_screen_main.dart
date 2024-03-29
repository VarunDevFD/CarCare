import 'package:car_maintanance/core/utils/app_colors.dart';
import 'package:car_maintanance/core/utils/responsive_screens.dart';
import 'package:car_maintanance/widgets/on_bording_screens/screen_one/on_boarding_one_screen.dart';
import 'package:car_maintanance/widgets/on_bording_screens/screen_three.dart/on_boarding_third_screen.dart';
import 'package:car_maintanance/widgets/on_bording_screens/screen_two/on_boarding_second_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';

class OnboardingPageState extends StatelessWidget {
  final PageController controller; // Control the page navigation
  final List<Widget> pages; // List of onboarding screens

  OnboardingPageState({Key? key})
      : controller = PageController(), // Initialize the page controller
        pages = [
          const OnBoardingOneScreen(), // First onboarding screen
          const OnBoardingSecondScreen(), // Second onboarding screen
          const OnBoardingThirdScreen(), // Third onboarding screen
        ],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a page controller
    PageController controller = PageController();

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            children: const [
              OnBoardingOneScreen(), // First onboarding screen
              OnBoardingSecondScreen(), // Second onboarding screen
              OnBoardingThirdScreen(), // Third onboarding screen
            ],
          ),
          // SmoothPageIndication dots
          Positioned(
            bottom: ResSize.dotBottom(context),
            left: ResSize.dotLeft(context, 60),
            child: SmoothPageIndicator(
              controller: controller, //
              count: 3,
              effect: const ScrollingDotsEffect(
                dotColor: AppColors.white,
                activeDotColor: AppColors.primary,
                activeStrokeWidth: 2.6,
                activeDotScale: 1.3,
                maxVisibleDots: 5,
                radius: 8,
                spacing: 10, // Spacing between dots
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
