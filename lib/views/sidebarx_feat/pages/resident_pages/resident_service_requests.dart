import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:municipality/models/service_request.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/utils/providers.dart';
import '../../../../core/utils/routes.dart';
import '../../../../models/resident.dart';
import '../../../../widgets/text_fields/custom_text_field.dart';
import '../staff_pages/tabs/service_requests.dart';

class ResidentManageServiceRequestsScreen extends ConsumerStatefulWidget {
  const ResidentManageServiceRequestsScreen({super.key});

  @override
  ConsumerState<ResidentManageServiceRequestsScreen> createState() => _StaffManageServiceRequestsScreenState();
}

class _StaffManageServiceRequestsScreenState extends ConsumerState<ResidentManageServiceRequestsScreen> with SingleTickerProviderStateMixin {
  final _key = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser;
  String searchTerm = '';
  final TextEditingController _searchTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final requestsState = ref.watch(ProviderUtils.serviceRequestsProvider);
    final residentState = ref.watch(ProviderUtils.residentProfileProvider(user!.email!));

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
                Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: CustomTextField(
                        labelText: 'Find Resident',
                        prefixIcon: const Icon(Icons.search),
                        controller: _searchTextEditingController,
                        onChanged: (value) {
                          setState(() {
                            searchTerm = value!;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(RoutesHelper.addServiceRequestScreen, arguments: [residentState.value, ref]);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Pallete.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: requestsState.when(
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
      ),
    );
  }

  Widget _buildContent({required List<ServiceRequest> serviceRequests, required Resident resident}) {
    return ResidentServicesRequestsTab(
      searchTerm: searchTerm,
      requests: serviceRequests.where((request) => request.residentAddress == "${resident.property.houseNumber} ${resident.property.suburb}").toList()
    );
  }
}
