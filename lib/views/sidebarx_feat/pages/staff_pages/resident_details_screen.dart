import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:municipality/models/resident.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:municipality/views/sidebarx_feat/pages/staff_pages/tabs/service_requests.dart';
import 'package:municipality/widgets/cards/family_member_card.dart';

import '../../../../core/constants/color_constants.dart';
import '../../../../core/utils/providers.dart';
import '../../../../models/payment_history.dart';
import '../../../../models/service_request.dart';
import '../../../../services/billing_services.dart';

class ResidentDetailsScreen extends ConsumerStatefulWidget {
  final Resident resident;
  const ResidentDetailsScreen({super.key, required this.resident});

  @override
  ConsumerState<ResidentDetailsScreen> createState() => _ResidentDetailsScreenState();
}

class _ResidentDetailsScreenState extends ConsumerState<ResidentDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<PaymentHistory> _allPayments = [];
  Future<List<PaymentHistory>>? _filteredPayments;
  String _selectedStatus = 'All';
  String _selectedPaymentMethod = 'All';
  String _selectedCurrency = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _fetchAllPayments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // **Payment Section** - Filter & Display Payments
  void _fetchAllPayments() async {
    try {
      final payments = await BillingServices.fetchResidentPaymentHistory(profileEmail: widget.resident.email);
      if (payments.success) {
        setState(() {
          _allPayments = payments.data!;
          _filteredPayments = Future.value(_allPayments);
        });
      } else {
        setState(() {
          _filteredPayments = Future.error(payments.message ?? "Error fetching payments");
        });
      }
    } catch (e) {
      setState(() {
        _filteredPayments = Future.error("Error: $e");
      });
    }
  }

  void _filterPayments() {
    final filtered = _allPayments.where((payment) {
      final matchesStatus = _selectedStatus == 'All' || payment.status == _selectedStatus;
      final matchesMethod = _selectedPaymentMethod == 'All' || payment.paymentMethod == _selectedPaymentMethod;
      final matchesCurrency = _selectedCurrency == 'All' || payment.currency == _selectedCurrency;
      return matchesStatus && matchesMethod && matchesCurrency;
    }).toList();

    setState(() {
      _filteredPayments = Future.value(filtered);
    });
  }

  Widget _buildPaymentsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filters Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDropdown('Status', _selectedStatus, (value) {
                setState(() {
                  _selectedStatus = value!;
                  _filterPayments();
                });
              }, ['All', 'Completed', 'Pending', 'Failed']),
              _buildDropdown('Payment Method', _selectedPaymentMethod, (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                  _filterPayments();
                });
              }, ['All', 'Cash', 'Bank Transfer', 'Mobile Money']),
              _buildDropdown('Currency', _selectedCurrency, (value) {
                setState(() {
                  _selectedCurrency = value!;
                  _filterPayments();
                });
              }, ['All', 'USD', 'ZAR', 'EUR']),
            ],
          ),
          const SizedBox(height: 16),
          // Payments List
          Expanded(
            child: FutureBuilder<List<PaymentHistory>>(
              future: _filteredPayments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No payments found."));
                }

                // Display filtered payments
                final payments = snapshot.data!;
                return ListView.builder(
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text("\$${payment.amountTotal.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          "Status: ${payment.status}\nMethod: ${payment.paymentMethod}\nCurrency: ${payment.currency}\nDate: ${DateFormat('yyyy-MM-dd').format(payment.timestamp.toDate())}",
                        ),
                        isThreeLine: true,
                        trailing: Icon(
                          payment.status == 'Completed'
                              ? Icons.check_circle
                              : payment.status == 'Failed'
                              ? Icons.error
                              : Icons.hourglass_top,
                          color: payment.status == 'Completed'
                              ? Colors.green
                              : payment.status == 'Failed'
                              ? Colors.red
                              : Colors.orange,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, Function(String?) onChanged, List<String> items) {
    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      hint: Text("Filter by $label"),
    );
  }

  // **Service Requests Section** - Display Service Requests
  Widget _buildServiceRequestsTab() {
    final requestsState = ref.watch(ProviderUtils.serviceRequestsProvider);
    final residentState = ref.watch(ProviderUtils.residentProfileProvider(widget.resident.email));

    return requestsState.when(
      data: (requests) => residentState.whenData(
            (resident) => resident != null
            ? _buildContent(resident: resident, serviceRequests:  requests)
            : const Center(child: Text('Resident not found')),
      ).when(
        data: (widget) => widget,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildContent({required List<ServiceRequest> serviceRequests, required Resident resident}) {
    return ResidentServicesRequestsTab(
        searchTerm: '',
        ref: ref,
        requests: serviceRequests.where((request) => request.residentAddress == "${resident.property.houseNumber} ${resident.property.suburb}").toList()
    );
  }


  @override
  Widget build(BuildContext context,) {
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
                if(widget.resident.balances != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Current Balance', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text("\$${widget.resident.balances!.last.currentBalance}",style:  TextStyle(fontWeight: FontWeight.bold, color: widget.resident.balances!.last.currentBalance > 0 ? Colors.red : Colors.green),)
                    ],
                  )
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
                Tab(text: 'Service Requests'),
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
                  _buildServiceRequestsTab(),
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
          child: FamilyMemberCard(familyMember: member)
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