// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:nanohospic/screens/add_edit_user.dart';
// // import '../database/database_provider.dart';
// // import '../database/entity/user_entity.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   // ignore: library_private_types_in_public_api
// //   _HomeScreenState createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   List<UserEntity> _users = [];
// //   bool _isLoading = false;
// //   String _searchQuery = '';

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadUsers();
// //   }

// //   Future<void> _loadUsers() async {
// //     if (!mounted) return;
    
// //     setState(() {
// //       _isLoading = true;
// //     });

// //     try {
// //       final repository = await DatabaseProvider.userRepository;
// //       final users = await repository.getAllUsers();
      
// //       if (mounted) {
// //         setState(() {
// //           _users = users;
// //         });
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Error loading users: $e'),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //       }
// //     }
// //   }

// //   Future<void> _searchUsers(String query) async {
// //     if (!mounted) return;
// //     setState(() {
// //       _isLoading = true;
// //       _searchQuery = query;
// //     });

// //     try {
// //       final repository = await DatabaseProvider.userRepository;
// //       final users = query.isEmpty
// //           ? await repository.getAllUsers()
// //           : await repository.searchUsers(query);
      
// //       if (mounted) {
// //         setState(() {
// //           _users = users;
// //         });
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Error searching: $e'),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //       }
// //     }
// //   }

// //   void _clearSearch() {
// //     _searchQuery = '';
// //     _searchUsers('');
// //     FocusScope.of(context).unfocus();
// //   }

// //   Future<void> _deleteUser(UserEntity user) async {
// //     final confirmed = await showDialog<bool>(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('Confirm Delete'),
// //         content: Text('Delete ${user.name}? This action cannot be undone.'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, false),
// //             child: const Text('CANCEL'),
// //           ),
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, true),
// //             child: const Text(
// //               'DELETE',
// //               style: TextStyle(color: Colors.red),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );

// //     if (confirmed == true) {
// //       try {
// //         final repository = await DatabaseProvider.userRepository;
// //         await repository.deleteUser(user);
// //         await _loadUsers();
        
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text('${user.name} deleted'),
// //               backgroundColor: Colors.green,
// //             ),
// //           );
// //         }
// //       } catch (e) {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text('Error: $e'),
// //               backgroundColor: Colors.red,
// //             ),
// //           );
// //         }
// //       }
// //     }
// //   }

// //   Future<void> _deleteAllUsers() async {
// //     if (_users.isEmpty) return;

// //     final confirmed = await showDialog<bool>(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('Delete All Users'),
// //         content: const Text('This will delete ALL users. This action cannot be undone.'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, false),
// //             child: const Text('CANCEL'),
// //           ),
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, true),
// //             child: const Text(
// //               'DELETE ALL',
// //               style: TextStyle(color: Colors.red),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );

// //     if (confirmed == true) {
// //       try {
// //         final repository = await DatabaseProvider.userRepository;
// //         await repository.deleteAllUsers();
// //         await _loadUsers();
        
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text('All users deleted'),
// //               backgroundColor: Colors.green,
// //             ),
// //           );
// //         }
// //       } catch (e) {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text('Error: $e'),
// //               backgroundColor: Colors.red,
// //             ),
// //           );
// //         }
// //       }
// //     }
// //   }

// //   void _navigateToAddEditScreen({UserEntity? user}) async {
// //     await Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => AddEditUserScreen(
// //           user: user,
// //           onUserSaved: _loadUsers,
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildUserCard(UserEntity user) {
// //     return Card(
// //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //       elevation: 2,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: ListTile(
// //         leading: CircleAvatar(
// //           backgroundColor: Colors.blue[100],
// //           child: Text(
// //             user.name[0].toUpperCase(),
// //             style: const TextStyle(
// //               fontWeight: FontWeight.bold,
// //               color: Colors.blue,
// //             ),
// //           ),
// //         ),
// //         title: Text(
// //           user.name,
// //           style: const TextStyle(
// //             fontWeight: FontWeight.bold,
// //             fontSize: 16,
// //           ),
// //         ),
// //         subtitle: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const SizedBox(height: 4),
// //             Text(
// //               user.email,
// //               style: TextStyle(
// //                 color: Colors.grey[600],
// //               ),
// //             ),
// //             const SizedBox(height: 2),
// //             Text(
// //               'Age: ${user.age} | Joined: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(user.createdAt))}',
// //               style: TextStyle(
// //                 color: Colors.grey[500],
// //                 fontSize: 12,
// //               ),
// //             ),
// //           ],
// //         ),
// //         trailing: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             IconButton(
// //               icon: const Icon(Icons.edit, size: 20),
// //               color: Colors.blue,
// //               onPressed: () => _navigateToAddEditScreen(user: user),
// //               tooltip: 'Edit',
// //             ),
// //             IconButton(
// //               icon: const Icon(Icons.delete, size: 20),
// //               color: Colors.red,
// //               onPressed: () => _deleteUser(user),
// //               tooltip: 'Delete',
// //             ),
// //           ],
// //         ),
// //         onTap: () => _navigateToAddEditScreen(user: user),
// //       ),
// //     );
// //   }

// //   Widget _buildEmptyState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(
// //             Icons.people_outline,
// //             size: 80,
// //             color: Colors.grey[300],
// //           ),
// //           const SizedBox(height: 20),
// //           Text(
// //             _searchQuery.isEmpty
// //                 ? 'No users yet'
// //                 : 'No users found for "$_searchQuery"',
// //             style: TextStyle(
// //               fontSize: 18,
// //               color: Colors.grey[600],
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //           const SizedBox(height: 10),
// //           Text(
// //             _searchQuery.isEmpty
// //                 ? 'Tap + to add your first user'
// //                 : 'Try a different search term',
// //             style: TextStyle(
// //               color: Colors.grey[500],
// //             ),
// //             textAlign: TextAlign.center,
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('User Management'),
// //         centerTitle: true,
// //         actions: [
// //           if (_users.isNotEmpty)
// //             IconButton(
// //               icon: const Icon(Icons.delete_sweep),
// //               onPressed: _deleteAllUsers,
// //               tooltip: 'Delete All Users',
// //             ),
// //         ],
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () => _navigateToAddEditScreen(),
// //         child: const Icon(Icons.add),
// //       ),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: TextField(
// //               decoration: InputDecoration(
// //                 hintText: 'Search by name...',
// //                 prefixIcon: const Icon(Icons.search),
// //                 suffixIcon: _searchQuery.isNotEmpty
// //                     ? IconButton(
// //                         icon: const Icon(Icons.clear),
// //                         onPressed: _clearSearch,
// //                       )
// //                     : null,
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 filled: true,
// //                 fillColor: Colors.grey[50],
// //               ),
// //               onChanged: _searchUsers,
// //             ),
// //           ),
// //           if (_isLoading)
// //             const Expanded(
// //               child: Center(
// //                 child: CircularProgressIndicator(),
// //               ),
// //             )
// //           else
// //             Expanded(
// //               child: _users.isEmpty
// //                   ? _buildEmptyState()
// //                   : RefreshIndicator(
// //                       onRefresh: _loadUsers,
// //                       child: ListView.builder(
// //                         itemCount: _users.length,
// //                         itemBuilder: (context, index) => _buildUserCard(_users[index]),
// //                       ),
// //                     ),
// //             ),
// //           if (_users.isNotEmpty && !_isLoading)
// //             Container(
// //               padding: const EdgeInsets.all(16),
// //               color: Colors.grey[50],
// //               child: Text(
// //                 'Total Users: ${_users.length}',
// //                 style: const TextStyle(
// //                   fontWeight: FontWeight.w500,
// //                   color: Colors.grey,
// //                 ),
// //                 textAlign: TextAlign.center,
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:nanohospic/screens/add_edit_user.dart';
// import '../database/database_provider.dart';
// import '../database/entity/user_entity.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<UserEntity> _users = [];
//   bool _isLoading = true;
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadUsers();
//   }

//   Future<void> _loadUsers() async {
//     if (!mounted) return;
    
//     setState(() {
//       _isLoading = true;
//     });

//     await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading

//     try {
//       final repository = await DatabaseProvider.userRepository;
//       final users = await repository.getAllUsers();
      
//       if (mounted) {
//         setState(() {
//           _users = users;
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//         _showErrorSnackBar('Error loading users');
//       }
//     }
//   }

//   void _clearSearch() {
//     setState(() {
//       _searchQuery = '';
//     });
//     FocusScope.of(context).unfocus();
//   }

//   Future<void> _deleteUser(UserEntity user) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete User'),
//         content: Text('Are you sure you want to delete ${user.name}?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text(
//               'Delete',
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       try {
//         final repository = await DatabaseProvider.userRepository;
//         await repository.deleteUser(user);
//         await _loadUsers();
        
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('${user.name} deleted'),
//               backgroundColor: Colors.green,
//             ),
//           );
//         }
//       } catch (e) {
//         if (mounted) {
//           _showErrorSnackBar('Error deleting user');
//         }
//       }
//     }
//   }

//   void _navigateToAddEditScreen({UserEntity? user}) async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AddEditUserScreen(
//           user: user,
//           onUserSaved: _loadUsers,
//         ),
//       ),
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: TextField(
//           onChanged: (value) {
//             setState(() {
//               _searchQuery = value;
//             });
//           },
//           decoration: InputDecoration(
//             hintText: 'Search users...',
//             prefixIcon: const Icon(Icons.search, color: Colors.grey),
//             suffixIcon: _searchQuery.isNotEmpty
//                 ? IconButton(
//                     icon: const Icon(Icons.clear, color: Colors.grey),
//                     onPressed: _clearSearch,
//                   )
//                 : null,
//             border: InputBorder.none,
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatsCard() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         color: Colors.blue.shade50,
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildStatItem(Icons.people, 'Total', _users.length.toString()),
//               const SizedBox(height: 40, child: VerticalDivider(color: Colors.blue, width: 1)),
//               _buildStatItem(Icons.email, 'Emails', _users.length.toString()),
//               const SizedBox(height: 40, child: VerticalDivider(color: Colors.blue, width: 1)),
//               _buildStatItem(Icons.calendar_today, 'Joined', _users.length.toString()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(IconData icon, String label, String value) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.blue, size: 24),
//         const SizedBox(height: 8),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.blue,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12,
//             color: Colors.blueGrey,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildUserCard(UserEntity user) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.blue.shade100,
//                   radius: 30,
//                   child: Text(
//                     user.name[0].toUpperCase(),
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         user.name,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           const Icon(Icons.email, size: 16, color: Colors.grey),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               user.email,
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           const Icon(Icons.cake, size: 16, color: Colors.grey),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${user.age} years',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
//                           const SizedBox(width: 4),
//                           Text(
//                             DateFormat('MMM dd, yyyy').format(DateTime.parse(user.createdAt)),
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 OutlinedButton.icon(
//                   onPressed: () => _navigateToAddEditScreen(user: user),
//                   icon: const Icon(Icons.edit, size: 16),
//                   label: const Text('Edit'),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.blue,
//                     side: const BorderSide(color: Colors.blue),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 OutlinedButton.icon(
//                   onPressed: () => _deleteUser(user),
//                   icon: const Icon(Icons.delete, size: 16),
//                   label: const Text('Delete'),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.red,
//                     side: const BorderSide(color: Colors.red),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.people_outline,
//             size: 80,
//             color: Colors.grey.shade300,
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'No Users Found',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _searchQuery.isEmpty
//                 ? 'Start by adding your first user'
//                 : 'No results for "$_searchQuery"',
//             style: const TextStyle(
//               fontSize: 14,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: () => _navigateToAddEditScreen(),
//             icon: const Icon(Icons.add),
//             label: const Text('Add User'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const CircularProgressIndicator(
//             color: Colors.blue,
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Loading Users...',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<UserEntity> get _filteredUsers {
//     if (_searchQuery.isEmpty) return _users;
//     return _users.where((user) {
//       return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//              user.email.toLowerCase().contains(_searchQuery.toLowerCase());
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text(
//           'Users',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//         centerTitle: false,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             onPressed: _loadUsers,
//             icon: const Icon(Icons.refresh),
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _navigateToAddEditScreen(),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         child: const Icon(Icons.add),
//       ),
//       body: Column(
//         children: [
//           _buildSearchBar(),
//           if (_users.isNotEmpty) _buildStatsCard(),
//           const SizedBox(height: 8),
//           Expanded(
//             child: _isLoading
//                 ? _buildLoadingState()
//                 : _filteredUsers.isEmpty
//                     ? _buildEmptyState()
//                     : RefreshIndicator(
//                         onRefresh: _loadUsers,
//                         child: ListView.builder(
//                           padding: const EdgeInsets.only(bottom: 80),
//                           itemCount: _filteredUsers.length,
//                           itemBuilder: (context, index) => _buildUserCard(_filteredUsers[index]),
//                         ),
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nanohospic/screens/add_edit_user.dart';
import '../database/database_provider.dart';
import '../database/entity/user_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserEntity> _users = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final List<String> _tabs = ['All', 'Active', 'Premium'];
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1)); // Simulate loading

    try {
      final repository = await DatabaseProvider.userRepository;
      final users = await repository.getAllUsers();
      
      if (mounted) {
        setState(() {
          _users = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Error loading users', Colors.red);
      }
    }
  }

  List<UserEntity> get _filteredUsers {
    if (_searchQuery.isEmpty) return _users;
    return _users.where((user) {
      return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             user.email.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<UserEntity> get _activeUsers => _filteredUsers;
  List<UserEntity> get _premiumUsers => _filteredUsers.where((user) => user.id! % 2 == 0).toList();

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade600,
            Colors.blue.shade600,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Back,',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: IconButton(
                  onPressed: _loadUsers,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search users by name or email...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: const Icon(Icons.search, color: Colors.blue),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.blue.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(color: Colors.blue.shade100, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.people_alt_rounded,
            'Total Users',
            _users.length.toString(),
            Colors.purple,
          ),
          _buildStatItem(
            Icons.verified_user_rounded,
            'Active',
            _activeUsers.length.toString(),
            Colors.green,
          ),
          _buildStatItem(
            Icons.star_rounded,
            'Premium',
            _premiumUsers.length.toString(),
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          int idx = entry.key;
          String tab = entry.value;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = idx;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == idx ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: _selectedTab == idx
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _selectedTab == idx ? Colors.blue : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUserCard(UserEntity user) {
    bool isPremium = user.id! % 2 == 0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPremium
              ? [
                  Colors.amber.shade50,
                  Colors.orange.shade50,
                ]
              : [
                  Colors.white,
                  Colors.blue.shade50,
                ],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: isPremium ? Colors.amber.shade200 : Colors.blue.shade100,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isPremium
                              ? [Colors.orange.shade400, Colors.amber.shade400]
                              : [Colors.blue.shade400, Colors.purple.shade400],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (isPremium)
                      Positioned(
                        top: -5,
                        right: -5,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade600,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isPremium ? Colors.amber.shade100 : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isPremium ? 'PREMIUM' : 'STANDARD',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isPremium ? Colors.amber.shade800 : Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.email_rounded, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              user.email,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.cake_rounded, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text(
                            '${user.age} years',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Icon(Icons.calendar_month_rounded, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMM dd, yyyy').format(DateTime.parse(user.createdAt)),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToAddEditScreen(user: user),
                    icon: Icon(Icons.edit_rounded, size: 18),
                    label: Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      elevation: 2,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _deleteUser(user),
                    icon: const Icon(Icons.delete_rounded, size: 18),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.red.shade200),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteUser(UserEntity user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_forever_rounded,
                  size: 40,
                  color: Colors.red.shade600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Delete User?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete "${user.name}"? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      try {
        final repository = await DatabaseProvider.userRepository;
        await repository.deleteUser(user);
        await _loadUsers();
        _showSnackBar('User deleted successfully', Colors.green);
      } catch (e) {
        _showSnackBar('Error deleting user', Colors.red);
      }
    }
  }

  void _navigateToAddEditScreen({UserEntity? user}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditUserScreen(
          user: user,
          onUserSaved: _loadUsers,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.blue],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Loading Users',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we fetch your data',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient:  LinearGradient(
                colors: [Colors.purple.shade50, Colors.blue.shade50],
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.people_alt_rounded,
              size: 80,
              color: Colors.blueGrey.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'No Users Found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _searchQuery.isEmpty
                ? 'Start by adding your first user'
                : 'No results found for "$_searchQuery"',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddEditScreen(),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add New User'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
            ),
          ),
        ],
      ),
    );
  }

  List<UserEntity> get _currentUsers {
    switch (_selectedTab) {
      case 0:
        return _filteredUsers;
      case 1:
        return _activeUsers;
      case 2:
        return _premiumUsers;
      default:
        return _filteredUsers;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          _buildHeader(),
          // if (_users.isNotEmpty) _buildStatsCard(),
          if (_users.isNotEmpty) _buildTabBar(),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _currentUsers.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadUsers,
                        backgroundColor: Colors.white,
                        color: Colors.blue,
                        displacement: 40,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: _currentUsers.length,
                          itemBuilder: (context, index) => _buildUserCard(_currentUsers[index]),
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddEditScreen(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add User'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}