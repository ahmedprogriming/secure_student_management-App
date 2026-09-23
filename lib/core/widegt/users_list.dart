import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_student_management/cubit/cubit_usrs/cubit/all_users_cubit.dart';

class AllUserPage extends StatefulWidget {
    static const String id = 'AllUserPage';
  const AllUserPage({super.key});

  @override
  State<AllUserPage> createState() => _AllUserPageState();
}

class _AllUserPageState extends State<AllUserPage> {

  @override
  void initState() {
    super.initState();
    context.read<AllUsersCubit>().fetchAllUsers();
  }

Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red.shade700;
      case 'teacher':
        return Colors.blue.shade700;
      case 'student':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Management Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AllUsersCubit>().fetchAllUsers(),
          ),
        ],
      ),
      body: BlocBuilder<AllUsersCubit,AllUsersState>(

        builder: (context,state)
      {
      if (state is AllUsersLoading) {
              return const Center(child: CircularProgressIndicator());
            }
      
            if (state is AllUsersFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<AllUsersCubit>().fetchAllUsers(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
      
            if (state is AllUsersSuccess) {
              final users = state.userList;
      
              if (users.isEmpty) {
                return const Center(child: Text('Not found users'));
              }
      
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final user = users[index];
      
                  return Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getRoleColor(user.role).withOpacity(0.15),
                        child: Text(
                          user.firstName.isNotEmpty ? user.firstName[0] : 'U',
                          style: TextStyle(
                            color: _getRoleColor(user.role),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.fullName.isNotEmpty ? user.fullName : 'User',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getRoleColor(user.role).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _getRoleColor(user.role)),
                            ),
                            child: Text(
                              user.role,
                              style: TextStyle(
                                color: _getRoleColor(user.role),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(user.email, style: const TextStyle(fontSize: 13)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                user.isActive ? Icons.check_circle : Icons.cancel,
                                size: 14,
                                color: user.isActive ? Colors.green : Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                user.isActive ? 'Active' : 'unActive',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: user.isActive ? Colors.green : Colors.grey,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'ID: ${user.id}',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
              
            }
            return const SizedBox.shrink();
      }
      
         ),
    );
  }
}