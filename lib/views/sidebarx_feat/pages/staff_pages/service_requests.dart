import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:municipality/models/service_request.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/utils/providers.dart';
import '../../../../widgets/text_fields/custom_text_field.dart';
import 'tabs/service_requests.dart';

class StaffManageServiceRequestsScreen extends ConsumerStatefulWidget {
  const StaffManageServiceRequestsScreen({super.key});

  @override
  ConsumerState<StaffManageServiceRequestsScreen> createState() => _StaffManageServiceRequestsScreenState();
}

class _StaffManageServiceRequestsScreenState extends ConsumerState<StaffManageServiceRequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _key = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser;
  String searchTerm = '';
  final TextEditingController _searchTextEditingController = TextEditingController();

  final List<String> suburbs = [
    'All', // Add this for fetching all requests
    'Brundish', 'Cherima', 'Chikonohono', 'Chitambo', 'Chikangwe', 'Cold Stream',
    'Gadzema', 'Gunhill', 'Hunyani', 'Katanda', 'Madzibaba', 'Mapako',
    'Mhangura', 'Mpata', 'Ngezi', 'Nyamhunga', 'Orange Grove', 'Pfura',
    'Ruvimbo', 'Rusununguko', 'White City', 'Zvimba', 'Chinhoyi Township',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: suburbs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestsState = ref.watch(ProviderUtils.serviceRequestsProvider);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    if (Dimensions.isSmallScreen)
                      IconButton(
                        onPressed: () {
                          _key.currentState!.openDrawer();
                        },
                        icon: const Icon(Icons.menu),
                      ),
                    Container(
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.network(
                        user!.photoURL ?? 'https://cdn-icons-png.flaticon.com/128/236/236832.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user!.displayName ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user!.email ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  labelText: 'Find Resident',
                  prefixIcon: const Icon(Icons.search),
                  controller: _searchTextEditingController,
                  onChanged: (value) {
                    setState(() {
                      searchTerm = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: requestsState.when(
        data: (requests) => _buildContent(requests),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(List<ServiceRequest> serviceRequests) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Locations',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
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
            tabAlignment: TabAlignment.start,
            tabs: suburbs.map((suburb) => Tab(text: suburb)).toList(),
          ),
          Expanded(
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: _tabController,
              children: suburbs.map((suburb) {
                if (suburb == 'All') {
                  // For the "All" tab, show all service requests
                  return ResidentServicesRequestsTab(
                    searchTerm: searchTerm,
                    ref: ref,
                    requests: serviceRequests,
                  );
                } else {
                  // For other tabs, filter by suburb
                  return ResidentServicesRequestsTab(
                    searchTerm: searchTerm,
                    ref: ref,
                    requests: serviceRequests.where((request) => request.residentAddress.contains(suburb)).toList(),
                  );
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
