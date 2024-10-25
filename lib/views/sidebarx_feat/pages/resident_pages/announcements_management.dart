import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:municipality/core/utils/routes.dart';
import 'package:municipality/global/global.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../widgets/cards/announcement_card.dart';
import '../../../../widgets/text_fields/custom_text_field.dart';
import 'package:municipality/core/utils/providers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnnouncementManagementScreen extends ConsumerStatefulWidget {
  const AnnouncementManagementScreen({super.key});

  @override
  ConsumerState<AnnouncementManagementScreen> createState() => _AnnouncementManagementScreenState();
}

class _AnnouncementManagementScreenState extends ConsumerState<AnnouncementManagementScreen> {
  final _searchTextEditingController = TextEditingController();
  String searchTerm = '';

  @override
  Widget build(BuildContext context) {

    final userRole = ref.watch(ProviderUtils.userRoleProvider);
    final announcementsAsyncValue = ref.watch(ProviderUtils.announcementsProvider);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
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
                          // TODO: Implement the menu functionality if necessary
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
                        user?.photoURL ?? 'https://cdn-icons-png.flaticon.com/128/236/236832.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'Unknown User',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user?.email ?? 'No email available',
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
                        labelText: 'Find Announcement',
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
                    if(userRole == UserRole.admin)Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(RoutesHelper.addAnnouncementScreen, arguments: ref);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
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
      body: Column(
        children: [
          Expanded(
            child: announcementsAsyncValue.when(
              data: (response) {
                if (!response.success) {
                  return Center(
                    child: Text(response.message ?? 'Error loading announcements'),
                  );
                }

                final announcements = response.data ?? [];
                final filteredAnnouncements = searchTerm.isEmpty
                    ? announcements
                    : announcements.where((announcement) {
                  return announcement.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
                      announcement.description.toLowerCase().contains(searchTerm.toLowerCase());
                }).toList();

                if (filteredAnnouncements.isEmpty) {
                  return const Center(
                    child: Text('No announcements found'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredAnnouncements.length,
                  itemBuilder: (context, index) {
                    final announcement = filteredAnnouncements[index];
                    return AnnouncementCard(
                      announcement: announcement,
                      role: userRole!,
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
