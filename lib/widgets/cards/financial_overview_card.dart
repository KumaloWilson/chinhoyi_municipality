// Updated Dashboard Component with current balance
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:municipality/core/constants/color_constants.dart';
import 'package:municipality/models/monthly_balance.dart';

class FinancialOverviewCard extends StatelessWidget {
  final List<MonthlyBalance> balances;

  const FinancialOverviewCard({super.key, required this.balances});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCurrentBalanceHeader(),
            const Divider(),
            _buildBalanceChart(),
            const SizedBox(height: 16),
            _buildDetailedBreakdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentBalanceHeader() {
    final latestBalance = balances.last;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Pallete.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Total Balance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'R${latestBalance.currentBalance.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Pallete.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'As of ${latestBalance.month} ${latestBalance.year}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceChart() {
    return SizedBox(
      height: 300,
      child: DefaultTabController(
        length: 6, // Added one more tab for Current Balance
        child: Column(
          children: [
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Current Balance'),
                Tab(text: 'Month Total'),
                Tab(text: 'Carried Forward'),
                Tab(text: 'Bins'),
                Tab(text: 'Rates'),
                Tab(text: 'Sewerage'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildLineChart(
                    data: balances.map((b) => b.currentBalance).toList(),
                    color: Pallete.primaryColor,
                    label: 'Current Balance',
                  ),
                  _buildLineChart(
                    data: balances.map((b) => b.monthTotal).toList(),
                    color: Colors.teal,
                    label: 'Month Total',
                  ),
                  _buildLineChart(
                    data: balances.map((b) => b.balanceCarriedForward).toList(),
                    color: Colors.blue,
                    label: 'Carried Forward',
                  ),
                  _buildLineChart(
                    data: balances.map((b) => b.bins).toList(),
                    color: Colors.green,
                    label: 'Bins',
                  ),
                  _buildLineChart(
                    data: balances.map((b) => b.rates).toList(),
                    color: Colors.orange,
                    label: 'Rates',
                  ),
                  _buildLineChart(
                    data: balances.map((b) => b.sewerage).toList(),
                    color: Colors.purple,
                    label: 'Sewerage',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart({
    required List<double> data,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        'R${value.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= balances.length) {
                        return const Text('');
                      }
                      return Text(
                        '${balances[value.toInt()].month}\n${balances[value.toInt()].year}',
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: data
                      .asMap()
                      .entries
                      .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                      .toList(),
                  isCurved: true,
                  color: color,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedBreakdown() {
    if (balances.isEmpty) return const SizedBox.shrink();

    final latestBalance = balances.last;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current Month Breakdown',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildBreakdownItem(
          'Balance Carried Forward',
          latestBalance.balanceCarriedForward,
          Colors.blue,
        ),
        _buildBreakdownItem(
          'Bins',
          latestBalance.bins,
          Colors.green,
        ),
        _buildBreakdownItem(
          'Rates',
          latestBalance.rates,
          Colors.orange,
        ),
        _buildBreakdownItem(
          'Sewerage',
          latestBalance.sewerage,
          Colors.purple,
        ),
        const Divider(),
        _buildBreakdownItem(
          'Month Total',
          latestBalance.monthTotal,
          Colors.teal,
        ),
        const Divider(thickness: 2),
        _buildBreakdownItem(
          'Current Balance',
          latestBalance.currentBalance,
          Pallete.primaryColor,
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildBreakdownItem(
      String label,
      double amount,
      Color color, {
        bool isTotal = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          const Spacer(),
          Text(
            'R${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}