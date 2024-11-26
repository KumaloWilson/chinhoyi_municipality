import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:municipality/core/constants/color_constants.dart';
import 'package:municipality/core/utils/providers.dart';
import 'package:municipality/models/payment_history.dart';

class CustomerPaymentsHistory extends ConsumerStatefulWidget {
  const CustomerPaymentsHistory({super.key});

  @override
  ConsumerState<CustomerPaymentsHistory> createState() => _CustomerPaymentsHistoryState();
}

class _CustomerPaymentsHistoryState extends ConsumerState<CustomerPaymentsHistory> {
  int? selectedYear;
  int? selectedMonth;
  final user = FirebaseAuth.instance.currentUser;

  // Initialize with the current year and month
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;
  }

  // Calculate the total payments for the selected period
  double calculateTotalPayments(List<PaymentHistory> payments) {
    return payments
        .where((payment) =>
    payment.timestamp.toDate().year == selectedYear &&
        payment.timestamp.toDate().month == selectedMonth)
        .fold(0.0, (sum, payment) => sum + payment.amountTotal);
  }

  @override
  Widget build(BuildContext context) {
    final paymentHistoryState = ref.watch(ProviderUtils.paymentHistoryProvider(user!.email!));
    final balanceState = ref.watch(ProviderUtils.residentProfileProvider(user!.email!));

    // Dropdown items for years and months
    final years = List<int>.generate(10, (index) => DateTime.now().year - index);
    final months = List<int>.generate(12, (index) => index + 1);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Customer Payments History', style: TextStyle(color: Colors.white, fontWeight:  FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Pallete.primaryColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Pallete.primaryColor
          ),
        ),
      ),
      body: Row(
        children: [
          // Sidebar with Filters and Total Payments
          Container(
            width: 300,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                const SizedBox(height: 32),

                paymentHistoryState.when(
                  data: (payments) {
                    final totalPayments = calculateTotalPayments(payments);
                    return Card(
                      color: Pallete.primaryColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Payments',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Pallete.whiteColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${totalPayments.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => const Text('Failed to fetch data'),
                ),


                const SizedBox(height: 32),


                balanceState.when(
                  data: (balances) {
                    final monthlyBalances = balances.balances;

                    return Card(
                      color: monthlyBalances!.last.currentBalance < 0 ? Colors.blue : Pallete.redColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Balance',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Pallete.whiteColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${monthlyBalances.last.currentBalance.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => const Text('Failed to fetch data'),
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: paymentHistoryState.when(
                      data: (payments) {
                        final filteredPayments = payments.where((payment) {
                          final date = payment.timestamp.toDate();
                          return date.year == selectedYear && date.month == selectedMonth;
                        }).toList();

                        return filteredPayments.isNotEmpty
                            ? DataTable(
                          columnSpacing: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          columns: const [
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Amount (USD)')),
                            DataColumn(label: Text('Method')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Currency')),
                          ],
                          rows: filteredPayments
                              .map(
                                (payment) => DataRow(cells: [
                              DataCell(Text(DateFormat('yyyy-MM-dd').format(payment.timestamp.toDate()))),
                              DataCell(Text('\$${payment.amountTotal.toStringAsFixed(2)}')),
                              DataCell(Text(payment.paymentMethod)),
                              DataCell(Text(payment.status)),
                              DataCell(Text(payment.currency)),
                            ]),
                          )
                              .toList(),
                        )
                            : const Center(child: Text('No payments found for the selected period.'));
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
