import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:municipality/core/utils/providers.dart';

import '../../../../core/constants/color_constants.dart';
import '../../../../models/resident.dart';

class MyResidenceManagementScreen extends StatefulWidget {
  const MyResidenceManagementScreen({super.key});

  @override
  State<MyResidenceManagementScreen> createState() =>
      _MyResidenceManagementScreenState();
}

class _MyResidenceManagementScreenState extends State<MyResidenceManagementScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final residentAsync = ref.watch(ProviderUtils.residentProfileProvider(user?.email ?? ''));

          return residentAsync.when(
            data: (resident) => ResidentDashboard(resident: resident),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          );
        },
      ),
    );
  }
}

class ResidentDashboard extends StatelessWidget {
  final Resident resident;

  const ResidentDashboard({super.key, required this.resident});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('${resident.firstName} ${resident.lastName}'),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Pallete.primaryColor,
                    Pallete.primaryColor.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildPersonalInfoCard(),
                const SizedBox(height: 16),
                _buildPropertyCard(),
                const SizedBox(height: 16),
                _buildFinancialOverview(),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                _buildFamilyMembersCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildInfoRow('Account Number', resident.accountNumber),
            _buildInfoRow('National ID', resident.nationalId),
            _buildInfoRow('Email', resident.email),
            _buildInfoRow('Phone', resident.phoneNumber),
            if (resident.alternativePhone != null)
              _buildInfoRow('Alternative Phone', resident.alternativePhone!),
            _buildInfoRow('Date of Birth',
                DateFormat('dd MMM yyyy').format(resident.dateOfBirth)),
            _buildInfoRow('Nationality', resident.nationality),
            _buildInfoRow('Employment Status', resident.employmentStatus),
            _buildInfoRow('Employer', resident.employer),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Property Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildInfoRow('Property ID', resident.property.propertyId),
            _buildInfoRow('House Number', resident.property.houseNumber),
            _buildInfoRow('Suburb', resident.property.suburb),
            _buildInfoRow('Property Type', resident.property.propertyType),
            _buildInfoRow('Property Size',
                '${resident.property.propertySize.toString()} sq m'),
            _buildInfoRow('Ownership Type', resident.property.ownershipType),
            _buildInfoRow('Status', resident.property.status),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialOverview() {
    if (resident.balances == null || resident.balances!.isEmpty) {
      return const SizedBox.shrink();
    }

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
            const Divider(),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= resident.balances!.length) {
                            return const Text('');
                          }
                          return Text(
                            resident.balances![value.toInt()].month,
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: resident.balances!
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(
                          entry.key.toDouble(), entry.value.currentBalance))
                          .toList(),
                      isCurved: true,
                      color: Pallete.primaryColor,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyMembersCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Family Members',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: resident.familyMembers.length,
              itemBuilder: (context, index) {
                final member = resident.familyMembers[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text('${member.firstName} ${member.lastName}'),
                  subtitle: Text(member.relationship),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}