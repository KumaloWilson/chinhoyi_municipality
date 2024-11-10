import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:municipality/core/utils/routes.dart';
import 'package:municipality/models/resident.dart';
import 'package:municipality/views/sidebarx_feat/pages/staff_pages/tabs/residents_tab.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/utils/providers.dart';
import '../../../../widgets/text_fields/custom_text_field.dart';

class ManageResidentsScreen extends ConsumerStatefulWidget {
  const ManageResidentsScreen({super.key});

  @override
  ConsumerState<ManageResidentsScreen> createState() => _ManageResidentsScreenState();
}

class _ManageResidentsScreenState extends ConsumerState<ManageResidentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _key = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser;
  String searchTerm = '';
  final TextEditingController _searchTextEditingController = TextEditingController();

  final List<String> suburbs = [
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
    final residentsState = ref.watch(ProviderUtils.residentsProvider);

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
                          Get.toNamed(RoutesHelper.addResidentsScreen, arguments: ref);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Pallete.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.userPlus,
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
      body: residentsState.when(
        data: (users) => _buildContent(users),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(List<Resident> users) {
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
              physics: BouncingScrollPhysics(),
              controller: _tabController,
              children: suburbs.map((suburb) {
                return ResidentTab(
                  searchTerm: searchTerm,
                  users: users.where((resident) => resident.property.suburb == suburb).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}