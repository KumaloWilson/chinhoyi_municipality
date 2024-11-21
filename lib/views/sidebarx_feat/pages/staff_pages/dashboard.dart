import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:municipality/core/utils/routes.dart';
import 'package:municipality/repository/helpers/finances_helper.dart';

import '../../../../core/constants/color_constants.dart';
import '../../../../core/utils/providers.dart';
import '../../../../models/resident.dart';
import '../../../../widgets/error_widgets/dashboard_error.dart';
import '../../../../widgets/placeholders/dashboard.dart';

class StaffDashboard extends ConsumerStatefulWidget {
  const StaffDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends ConsumerState<StaffDashboard> {
  final List<double> revenueData = [1000, 1200, 1300, 1500, 1400, 1600];
  final List<double> waterUsageData = [60, 70, 65, 80, 75, 85];

  @override
  Widget build(BuildContext context) {
    final residentsState = ref.watch(ProviderUtils.residentsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Dashboard',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
      ),
      body: residentsState.when(
        data: (residents){
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Cards
                  Row(
                    children: [
                      Expanded(child: _buildInfoCard('Total Customers', residents.length.toString(), Icons.people, Colors.blue)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildInfoCard('Active Accounts', residents.where((Resident resident) => !resident.isDisabled).toList().length.toString(), Icons.account_balance, Pallete.primaryColor)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildInfoCard('Monthly Revenue', '\$12,000', Icons.attach_money, Colors.purple)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildInfoCard('Monthly Revenue', "\$${FinancesHelper.calculateTotalMonthlyBills(residents: residents).toString()}", Icons.arrow_circle_down, Colors.redAccent)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Graph Section
                  Row(
                    children: [
                      Expanded(child: _buildCard(child: _buildRevenueChart())),
                      const SizedBox(width: 16),
                      Expanded(child: _buildCard(child: _buildWaterUsageChart())),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Customer Management & Quick Actions
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer Management', style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildQuickActionButton(
                              label: 'Add Customer',
                              icon:  Icons.person_add,
                              color:  Colors.blue,
                              onTap: () {
                                Get.toNamed(RoutesHelper.addResidentsScreen, arguments: ref);
                              },
                            ),
                            _buildQuickActionButton(
                               label:  'Manage Accounts',
                               icon:  Icons.manage_accounts,
                               color:  Colors.orange),
                            _buildQuickActionButton(
                               label:  'View Reports',
                               icon:  Icons.bar_chart,
                               color:  Colors.green
                            ),
                            _buildQuickActionButton(
                              label:   'Support',
                              icon:   Icons.support_agent,
                              color:   Colors.purple
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Recent Transactions
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recent Transactions', style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 16),
                        _buildTransactionItem('Water Bill Payment', 'Nov 05, 2024', -150.00),
                        _buildTransactionItem('Penalty Fee', 'Nov 01, 2024', -25.00),
                        _buildTransactionItem('Bill Payment', 'Oct 15, 2024', -145.00),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (error, stakeTrace){
          return DashboardErrorWidget(
              errorMessage: error.toString(),
              onRetry: (){

              }
          );
        },
        loading:() {
          return const DashboardPlaceholder();
        }
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({required String label, required IconData icon, required Color color, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, String date, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[800])),
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Text(
            NumberFormat.currency(symbol: '\$').format(amount),
            style: TextStyle(
              color: amount < 0 ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Revenue (Last 6 Months)', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: revenueData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                  isCurved: true,
                  gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
                  belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [Colors.blue.withOpacity(0.3), Colors.purple.withOpacity(0.1)])),
                  dotData: FlDotData(show: false),
                  barWidth: 4,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaterUsageChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Water Usage (Last 6 Months)', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: waterUsageData.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value,
                      gradient: LinearGradient(colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
