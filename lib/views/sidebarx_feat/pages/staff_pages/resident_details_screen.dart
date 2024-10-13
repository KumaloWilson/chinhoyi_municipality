import 'package:flutter/material.dart';
import 'package:municipality/models/resident.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/color_constants.dart';

class ResidentDetailsScreen extends StatefulWidget {
  final Resident resident;
  const ResidentDetailsScreen({super.key, required this.resident});

  @override
  State<ResidentDetailsScreen> createState() => _ResidentDetailsScreenState();
}

class _ResidentDetailsScreenState extends State<ResidentDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text('${widget.resident.firstName} ${widget.resident.lastName}', style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Pallete.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200.0, vertical: 16),
        child: Column(
          children: [
            _buildInfoCard(
              'General Information',[
                _buildInfoRow('Account Number', widget.resident.accountNumber),
                if(widget.resident.balances!.isNotEmpty)_buildInfoRow('Current Balance', widget.resident.balances!.last.balance.toString())
            ]

            ),
            TabBar(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              isScrollable: true,
              unselectedLabelStyle: TextStyle(
                color: Pallete.greyAccent,
                fontSize: 14,
              ),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              tabAlignment: TabAlignment.center,
              tabs: const [
                Tab(text: 'Personal Info'),
                Tab(text: 'Family'),
                Tab(text: 'Property'),
                Tab(text: 'Utilities'),
                Tab(text: 'Payments'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPersonalInfoTab(),
                  _buildFamilyTab(),
                  _buildPropertyTab(),
                  _buildUtilitiesTab(),
                  _buildPaymentsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to add new entry based on current tab
          _showAddEntryDialog(_tabController.index);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPersonalInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Basic Information', [
            _buildInfoRow('Name', '${widget.resident.firstName} ${widget.resident.lastName}'),
            _buildInfoRow('National ID', widget.resident.nationalId),
            _buildInfoRow('Gender', widget.resident.gender),
            _buildInfoRow('Date of Birth', DateFormat('yyyy-MM-dd').format(widget.resident.dateOfBirth)),
            _buildInfoRow('Nationality', widget.resident.nationality),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Contact Information', [
            _buildInfoRow('Email', widget.resident.email),
            _buildInfoRow('Phone', widget.resident.phoneNumber),
            _buildInfoRow('Alternative Phone', widget.resident.alternativePhone ?? 'N/A'),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Employment Information', [
            _buildInfoRow('Status', widget.resident.employmentStatus),
            _buildInfoRow('Employer', widget.resident.employer),
            _buildInfoRow('Monthly Income', '\$${widget.resident.monthlyIncome.toStringAsFixed(2)}'),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Emergency Contact', [
            _buildInfoRow('Name', widget.resident.emergencyContact.emergencyContactName),
            _buildInfoRow('Phone', widget.resident.emergencyContact.emergencyContactPhone),
            _buildInfoRow('Relationship', widget.resident.emergencyContact.relationshipToResident),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Additional Information', [
            _buildInfoRow('Disabled', widget.resident.isDisabled ? 'Yes' : 'No'),
            _buildInfoRow('Senior Citizen', widget.resident.isSeniorCitizen ?? false ? 'Yes' : 'No'),
            _buildInfoRow('Account Status', widget.resident.accountStatus),
            _buildInfoRow('Last Updated', DateFormat('yyyy-MM-dd').format(widget.resident.lastUpdated)),
          ]),
        ],
      ),
    );
  }

  Widget _buildFamilyTab() {
    return ListView.builder(
      itemCount: widget.resident.familyMembers.length,
      itemBuilder: (context, index) {
        final member = widget.resident.familyMembers[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('${member.firstName} ${member.lastName}'),
            subtitle: Text('${member.relationship} - ${DateFormat('yyyy-MM-dd').format(member.dateOfBirth)}'),
            trailing: Text(member.isDependent ? 'Dependent' : 'Independent'),
          ),
        );
      },
    );
  }

  Widget _buildPropertyTab() {
    final property = widget.resident.property;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Property Details', [
            _buildInfoRow('Property ID', property.propertyId),
            _buildInfoRow('House Number', property.houseNumber),
            _buildInfoRow('Suburb', property.suburb),
            _buildInfoRow('Type', property.propertyType),
            _buildInfoRow('Size', '${property.propertySize} sq m'),
            _buildInfoRow('Ownership', property.ownershipType),
            _buildInfoRow('Status', property.status),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Ownership History', [
            _buildInfoRow('Current Owner ID', property.currentOwnerId),
            _buildInfoRow('Previous Owners', property.previousOwnerIds.join(', ')),
          ]),
        ],
      ),
    );
  }

  Widget _buildUtilitiesTab() {
    return ListView.builder(
      itemCount: widget.resident.utilityAccounts?.length ?? 0,
      itemBuilder: (context, index) {
        final account = widget.resident.utilityAccounts![index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ExpansionTile(
            title: Text(account.utilityType),
            children: [
              _buildInfoRow('Account ID', account.accountId),
              _buildInfoRow('Current Balance', '\$${account.currentBalance.toStringAsFixed(2)}'),
              _buildInfoRow('Last Billing Date', DateFormat('yyyy-MM-dd').format(account.lastBillingDate)),
              _buildInfoRow('Last Payment', '\$${account.lastPaymentAmount.toStringAsFixed(2)}'),
              if (account.lastPaymentDate != null)
                _buildInfoRow('Last Payment Date', DateFormat('yyyy-MM-dd').format(account.lastPaymentDate!)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentsTab() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: _buildPaymentHistoryChart(),
        ),
        Expanded(
          flex: 3,
          child: _buildPaymentHistoryList(),
        ),
      ],
    );
  }

  Widget _buildPaymentHistoryChart() {
    final paymentHistory = widget.resident.paymentHistory ?? [];
    if (paymentHistory.isEmpty) {
      return const Center(child: Text('No payment history available'));
    }

    final sortedPayments = paymentHistory..sort((a, b) => a.paymentDate.compareTo(b.paymentDate));
    final spots = sortedPayments.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.amount);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: spots.length.toDouble() - 1,
          minY: 0,
          maxY: spots.map((spot) => spot.y).reduce((max, value) => value > max ? value : max),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentHistoryList() {
    final paymentHistory = widget.resident.paymentHistory ?? [];
    return ListView.builder(
      itemCount: paymentHistory.length,
      itemBuilder: (context, index) {
        final payment = paymentHistory[index];
        return ListTile(
          title: Text('\$${payment.amount.toStringAsFixed(2)}'),
          subtitle: Text(DateFormat('yyyy-MM-dd').format(payment.paymentDate)),
          trailing: Text(payment.status),
        );
      },
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, textAlign: TextAlign.center, style: TextStyle(color: Pallete.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void _showAddEntryDialog(int tabIndex) {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        Widget content = Container();

        switch (tabIndex) {
          case 1:
            title = 'Add Family Member';
            content = _buildAddFamilyMemberForm();
            break;
          case 3:
            title = 'Add Utility Account';
            content = _buildAddUtilityAccountForm();
            break;
          case 4:
            title = 'Add Payment';
            content = _buildAddPaymentForm();
            break;
          default:
            title = 'Add Entry';
            content = const Text('Not implemented for this tab');
        }

        return AlertDialog(
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement the logic to add the new entry
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddFamilyMemberForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const TextField(decoration: InputDecoration(labelText: 'First Name')),
        const TextField(decoration: InputDecoration(labelText: 'Last Name')),
        const TextField(decoration: InputDecoration(labelText: 'Relationship')),
        const TextField(decoration: InputDecoration(labelText: 'Date of Birth')),
        CheckboxListTile(
          title: const Text('Is Dependent'),
          value: false,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildAddUtilityAccountForm() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(decoration: InputDecoration(labelText: 'Utility Type')),
        TextField(decoration: InputDecoration(labelText: 'Account ID')),
        TextField(decoration: InputDecoration(labelText: 'Current Balance')),
        TextField(decoration: InputDecoration(labelText: 'Last Billing Date')),
      ],
    );
  }

  Widget _buildAddPaymentForm() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(decoration: InputDecoration(labelText: 'Amount')),
        TextField(decoration: InputDecoration(labelText: 'Payment Method')),
        TextField(decoration: InputDecoration(labelText: 'Payment Date')),
        TextField(decoration: InputDecoration(labelText: 'Reference Number')),
      ],
    );
  }
}