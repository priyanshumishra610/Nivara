import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../widgets/product_tile.dart';
import '../../../../widgets/wellness_card.dart';
import '../../../../widgets/custom_refresh_indicator.dart';
import '../../../../widgets/animated_button.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});
  
  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  int _selectedTab = 0;
  
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomRefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            _buildHeroSection(context),
            _buildTabBar(context),
            Expanded(
              child: _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: AppColors.wellnessGradient,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Daily Wellness Kit',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Curated for your wellness journey',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AnimatedButton(
                    label: 'Explore',
                    icon: Icons.arrow_forward,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.2),
                      ],
                    ),
                    backgroundColor: Colors.white.withOpacity(0.2),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabBar(BuildContext context) {
    final tabs = ['All', 'Books', 'Audio', 'Journals', 'Courses'];
    
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedTab == index;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilterChip(
              label: Text(tabs[index]),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedTab = index;
                });
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildContent(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: ProductTile(
            name: 'Wellness Product ${index + 1}',
            description: 'A carefully curated item to support your mental wellness journey',
            price: (index + 1) * 19.99,
            isRecommended: index % 3 == 0,
            aiReason: index % 3 == 0
                ? 'Based on your recent mood patterns and preferences'
                : null,
            onTap: () {},
          ),
        );
      },
    );
  }
}
