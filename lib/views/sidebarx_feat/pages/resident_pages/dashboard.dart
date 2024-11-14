import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:municipality/widgets/error_widgets/dashboard_error.dart';
import 'package:municipality/widgets/placeholders/dashboard.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/utils/providers.dart';




class CustomerDashBoard extends ConsumerStatefulWidget {
  const CustomerDashBoard({super.key});

  @override
  ConsumerState<CustomerDashBoard> createState() => _CustomerDashBoardState();
}

class _CustomerDashBoardState extends ConsumerState<CustomerDashBoard> {
  final user = FirebaseAuth.instance.currentUser;
  final List<double> waterUsage = [45, 60, 35, 50, 40, 35];
  final List<double> billAmounts = [150, 180, 140, 165, 155, 145];

  @override
  Widget build(BuildContext context) {
    final residentState = ref.watch(ProviderUtils.residentProfileProvider(user!.email!));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Customer Dashboard',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
      ),
      body: residentState.when(
          data: (resident){
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Summary Card
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Account Summary', style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoColumn('Account Number', resident.accountNumber),
                              _buildInfoColumn('Current Balance', '\$${resident.balances != null ? resident.balances!.last.currentBalance : 0}'),
                              _buildInfoColumn('Bill Month', resident.balances != null ? resident.balances!.last.month : DateFormat.MMMM().format(DateTime.now()),),
                              _buildInfoColumn('Status', 'Active'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Charts Row
                    Row(
                      children: [
                        Expanded(child: _buildCard(child: _buildWaterUsageChart())),
                        const SizedBox(width: 16),
                        Expanded(child: _buildCard(child: _buildBillingChart())),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Quick Actions
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quick Actions', style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildQuickActionButton('Pay Bill', Icons.payment, Colors.green),
                              _buildQuickActionButton('Report Issue', Icons.report_problem, Colors.orange),
                              _buildQuickActionButton('Download Bill', Icons.download, Colors.blue),
                              _buildQuickActionButton('Support', Icons.support_agent, Colors.purple),
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
                          _buildTransactionItem('Water Bill Payment', 'Oct 15, 2024', -150.00),
                          _buildTransactionItem('Late Payment Fee', 'Oct 10, 2024', -25.00),
                          _buildTransactionItem('Bill Payment', 'Sep 15, 2024', -145.00),
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

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[800])),
      ],
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

  Widget _buildWaterUsageChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Water Usage (Last 6 Months)', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: waterUsage.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                  isCurved: true,
                  gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
                  belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [Colors.blue.withOpacity(0.3), Colors.purple.withOpacity(0.1)])),
                  dotData: const FlDotData(show: false),
                  barWidth: 4,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBillingChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Billing History (Last 6 Months)', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: billAmounts.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value,
                      gradient: LinearGradient(
                          colors: [
                            Pallete.primaryColor,
                            Pallete.primaryColor.withOpacity(
                              0.6
                            )
                          ]
                      ),
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
}
