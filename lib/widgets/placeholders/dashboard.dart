import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DashboardPlaceholder extends StatelessWidget {
  const DashboardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Summary Card
            _buildPlaceholderCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerBox(width: 150, height: 24),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (_) => _buildInfoColumnPlaceholder()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Charts Row
            Row(
              children: [
                Expanded(child: _buildPlaceholderCard(child: _buildShimmerBox(width: double.infinity, height: 150))),
                const SizedBox(width: 16),
                Expanded(child: _buildPlaceholderCard(child: _buildShimmerBox(width: double.infinity, height: 150))),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            _buildPlaceholderCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerBox(width: 120, height: 24),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(4, (_) => _buildQuickActionButtonPlaceholder()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Transactions
            _buildPlaceholderCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerBox(width: 160, height: 24),
                  const SizedBox(height: 16),
                  Column(
                    children: List.generate(3, (_) => _buildTransactionItemPlaceholder()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoColumnPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShimmerBox(width: 80, height: 16),
        const SizedBox(height: 8),
        _buildShimmerBox(width: 50, height: 16),
      ],
    );
  }

  Widget _buildQuickActionButtonPlaceholder() {
    return Column(
      children: [
        _buildShimmerCircle(diameter: 40),
        const SizedBox(height: 8),
        _buildShimmerBox(width: 60, height: 12),
      ],
    );
  }

  Widget _buildTransactionItemPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildShimmerBox(width: 140, height: 16),
          _buildShimmerBox(width: 80, height: 16),
          _buildShimmerBox(width: 60, height: 16),
        ],
      ),
    );
  }

  Widget _buildShimmerBox({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildShimmerCircle({required double diameter}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
