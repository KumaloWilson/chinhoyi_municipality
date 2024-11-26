import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:municipality/core/utils/providers.dart';

import '../../../../core/constants/color_constants.dart';

class RevenueManagementScreen extends ConsumerStatefulWidget {
  const RevenueManagementScreen({super.key});

  @override
  ConsumerState<RevenueManagementScreen> createState() => _RevenueManagementScreenState();
}

class _RevenueManagementScreenState extends ConsumerState<RevenueManagementScreen> {
  int? selectedYear;
  int? selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;
  }

  @override
  Widget build(BuildContext context) {
    final revenueState = ref.watch(ProviderUtils.revenuesProvider);

    final years = List<int>.generate(10, (index) => DateTime.now().year - index);
    final months = List<int>.generate(12, (index) => index + 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revenue Management'),
        centerTitle: true,
        backgroundColor: Pallete.primaryColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Pallete.primaryColor,
          ),
        ),
      ),
      body: Row(
        children: [
          // Sidebar with Filters
          Container(
            width: 300,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                DropdownButton<int>(
                  value: selectedYear,
                  isExpanded: true,
                  items: years
                      .map((year) => DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value;
                    });
                  },
                  hint: const Text('Select Year'),
                ),
                const SizedBox(height: 16),
                DropdownButton<int>(
                  value: selectedMonth,
                  isExpanded: true,
                  items: months
                      .map((month) => DropdownMenuItem(
                    value: month,
                    child: Text(DateFormat.MMMM().format(DateTime(0, month))),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value;
                    });
                  },
                  hint: const Text('Select Month'),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Revenue Overview',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Revenue Summary
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: revenueState.when(
                        data: (payments) {
                          final filteredPayments = payments.where((payment) {
                            final date = payment.timestamp.toDate();
                            return date.year == selectedYear && date.month == selectedMonth;
                          }).toList();

                          final totalRevenue = filteredPayments.fold(
                            0.0,
                                (sum, payment) => sum + payment.amountTotal,
                          );

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Revenue',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${totalRevenue.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                            ],
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) => const Text('Failed to fetch data'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Payments Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  // Payments Table
                  Expanded(
                    child: revenueState.when(
                      data: (payments) {
                        final filteredPayments = payments.where((payment) {
                          final date = payment.timestamp.toDate();
                          return date.year == selectedYear && date.month == selectedMonth;
                        }).toList();

                        return filteredPayments.isNotEmpty
                            ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Method', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Currency', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: filteredPayments
                                .map(
                                  (payment) => DataRow(cells: [
                                DataCell(Text(DateFormat('yyyy-MM-dd').format(payment.timestamp.toDate()))),
                                DataCell(Text('\$${payment.amountTotal.toStringAsFixed(2)}')),
                                DataCell(Text(payment.paymentMethod)),
                                DataCell(Text(payment.status)),
                                DataCell(Text(payment.currency)),
                                DataCell(Text(payment.email)),
                              ]),
                            )
                                .toList(),
                          ),
                        )
                            : const Center(child: Text('No payment records available for the selected period.'));
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                        child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
