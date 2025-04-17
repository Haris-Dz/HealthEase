import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:healthease_desktop/models/patient.dart';
import 'package:healthease_desktop/models/role.dart';
import 'package:healthease_desktop/models/search_result.dart';
import 'package:healthease_desktop/models/user.dart';
import 'package:healthease_desktop/providers/patients_provider.dart';
import 'package:healthease_desktop/providers/roles_provider.dart';
import 'package:healthease_desktop/providers/users_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> _users = [];
  List<Patient> _patients = [];
  bool isEmployeesSelected = true;
  String searchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      setState(() => _isLoading = true);
      try {
        var usersResult = await Provider.of<UsersProvider>(context, listen: false)
            .get(filter: {"IsUserRoleIncluded": true}, retrieveAll: true);
        _users = usersResult.resultList;

        var patientsResult = await Provider.of<PatientsProvider>(context, listen: false)
            .get(retrieveAll: true);
        _patients = patientsResult.resultList;
      } catch (e) {
        print('Error fetching data: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users
        .where((u) => (u.firstName ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
            (u.lastName ?? '').toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    final filteredPatients = _patients
        .where((p) => (p.firstName ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
            (p.lastName ?? '').toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Container(
      color: const Color(0xFFE3F2FD),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildToggle(),
          const SizedBox(height: 20),
          _buildSearchField(),
          const SizedBox(height: 20),
          _isLoading
              ? const Expanded(child: Center(child: CircularProgressIndicator()))
              : _buildTableContainer(isEmployeesSelected ? filteredUsers : filteredPatients),
          const SizedBox(height: 20),
          if (isEmployeesSelected) _buildAddButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(30),
      selectedColor: Colors.white,
      fillColor: Colors.blueAccent,
      color: Colors.blueGrey,
      isSelected: [isEmployeesSelected, !isEmployeesSelected],
      onPressed: (index) {
        setState(() {
          isEmployeesSelected = index == 0;
        });
      },
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text("Employees"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text("Patients"),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          hintText: isEmployeesSelected ? "Search employees..." : "Search patients...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildTableContainer(List<dynamic> data) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 4,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: _buildTable(data),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTable(List<dynamic> data) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 400, minWidth: 800),
          child: DataTable(
            columnSpacing: 100,
            headingRowColor: MaterialStateProperty.all(Colors.blue.shade100),
            columns: isEmployeesSelected
                ? const [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Role")),
                    DataColumn(label: Text("Actions")),
                  ]
                : const [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Actions")),
                  ],
            rows: List.generate(
              data.length,
              (index) {
                if (isEmployeesSelected) {
                  final employee = data[index];
                  final role = employee.userRoles.isNotEmpty
                      ? employee.userRoles.first.role?.roleName ?? "N/A"
                      : "N/A";
                  return DataRow(cells: [
                    DataCell(Text("${employee.firstName} ${employee.lastName}")),
                    DataCell(Text(role)),
                    DataCell(_buildActions(employee)),
                  ]);
                } else {
                  final patient = data[index];
                  final status = (patient.isActive ?? false) ? "Active" : "Deactivated";
                  return DataRow(cells: [
                    DataCell(Text("${patient.firstName ?? ''} ${patient.lastName ?? ''}")),
                    DataCell(
                      Text(
                        status,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: status == "Active" ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    DataCell(_buildActions(patient)),
                  ]);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: () => _showAddOrEditUserDialog(context),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.blue.shade700,
        padding: const EdgeInsets.all(20),
      ),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
    );
  }

Widget _buildActions(dynamic user) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.edit, color: Colors.blue),
        onPressed: () {
          if (isEmployeesSelected) {
            _showAddOrEditUserDialog(context, existingUser: user);
          } else {
            _showEditPatientDialog(context, user);
          }
        },
      ),
      IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => _confirmDelete(context, user),
      ),
    ],
  );
}

void _confirmDelete(BuildContext context, dynamic user) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Confirm Deletion"),
      content: const Text("Are you sure you want to delete this user?"),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, false),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2), // Plava
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            "Delete",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],

    ),
  );

  if (confirm == true) {
    try {
      if (isEmployeesSelected) {
        await Provider.of<UsersProvider>(context, listen: false).delete(user.userId);
      } else {
        await Provider.of<PatientsProvider>(context, listen: false).delete(user.patientId);
      }

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: "Deleted",
        text: "The user has been deleted successfully.",
      );

      // Refresh data
      setState(() => _isLoading = true);
      final usersResult = await Provider.of<UsersProvider>(context, listen: false)
          .get(filter: {"IsUserRoleIncluded": true}, retrieveAll: true);
      final patientsResult = await Provider.of<PatientsProvider>(context, listen: false)
          .get(retrieveAll: true);

      setState(() {
        _users = usersResult.resultList;
        _patients = patientsResult.resultList;
        _isLoading = false;
      });
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Error",
        text: "Failed to delete user.",
      );
    }
  }
}



void _showAddOrEditUserDialog(BuildContext context, {User? existingUser}) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController(text: existingUser?.firstName ?? '');
  final TextEditingController lastNameController = TextEditingController(text: existingUser?.lastName ?? '');
  final TextEditingController emailController = TextEditingController(text: existingUser?.email ?? '');
  final TextEditingController usernameController = TextEditingController(text: existingUser?.username ?? '');
  final TextEditingController phoneNumberController = TextEditingController(text: existingUser?.phoneNumber ?? '');

  int? selectedRoleId;
  if (existingUser != null &&
      existingUser.userRoles!.isNotEmpty &&
      existingUser.userRoles?.first.role != null) {
    selectedRoleId = existingUser.userRoles?.first.role!.roleId;
  }

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 500,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        existingUser != null ? "Edit employee" : "Add new employee",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: firstNameController,
                        decoration: const InputDecoration(labelText: "First name"),
                        validator: (value) => value == null || value.isEmpty ? "This field is required" : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: lastNameController,
                        decoration: const InputDecoration(labelText: "Last name"),
                        validator: (value) => value == null || value.isEmpty ? "This field is required" : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: phoneNumberController,
                        decoration: const InputDecoration(labelText: "Phone number"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is required";
                          }
                          final phoneRegex = RegExp(r'^\d{9}$');
                          if (!phoneRegex.hasMatch(value)) {
                            return "Enter a valid 9-digit number";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        enabled: existingUser == null,
                        decoration: const InputDecoration(labelText: "Email"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is required";
                          }
                          final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                          if (!emailRegex.hasMatch(value)) {
                            return "Enter a valid email address";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),
                      TextFormField(
                        controller: usernameController,
                        enabled: existingUser == null,
                        decoration: const InputDecoration(labelText: "Username"),
                        validator: (value) => value == null || value.isEmpty ? "This field is required" : null,
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder(
                        future: Provider.of<RolesProvider>(context, listen: false).get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text("Failed to load roles");
                          } else {
                            final roles = (snapshot.data as SearchResult<Role>).resultList;
                            return DropdownButtonFormField<int>(
                              decoration: const InputDecoration(labelText: "Role"),
                              value: selectedRoleId,
                              items: roles.map((role) {
                                return DropdownMenuItem<int>(
                                  value: role.roleId,
                                  child: Text(role.roleName ?? ""),
                                );
                              }).toList(),
                              onChanged: (value) {
                                selectedRoleId = value;
                              },
                              validator: (value) => value == null ? "Select a role" : null,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              try {
                                if (existingUser == null) {
                                  await UsersProvider().insert({
                                    "firstName": firstNameController.text,
                                    "lastName": lastNameController.text,
                                    "email": emailController.text,
                                    "username": usernameController.text,
                                    "phoneNumber": phoneNumberController.text,
                                    "roleId": selectedRoleId,
                                  });
                                } else {
                                  await UsersProvider().update(existingUser.userId!, {
                                    "firstName": firstNameController.text,
                                    "lastName": lastNameController.text,
                                    "phoneNumber": phoneNumberController.text,
                                    "roleId": selectedRoleId,
                                    "edit": true,
                                  });
                                }

                                if (context.mounted) Navigator.of(context).pop();

                                Future.microtask(() async {
                                  if (context.mounted) {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      title: "Success",
                                      text: existingUser == null
                                          ? "New user added successfully."
                                          : "User updated successfully.",
                                    );

                                    setState(() => _isLoading = true);
                                    var usersResult = await Provider.of<UsersProvider>(context, listen: false)
                                        .get(filter: {"IsUserRoleIncluded": true}, retrieveAll: true);
                                    setState(() {
                                      _users = usersResult.resultList;
                                      _isLoading = false;
                                    });
                                  }
                                });
                              } catch (e) {
                                print("Error: $e");
                                if (context.mounted) {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: "Error",
                                    text: existingUser == null
                                        ? "Adding user failed."
                                        : "Updating user failed.",
                                  );
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            existingUser == null ? "Add" : "Save",
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
void _showEditPatientDialog(BuildContext context, Patient patient) {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController(text: patient.firstName ?? '');
  final lastNameController = TextEditingController(text: patient.lastName ?? '');
  final phoneController = TextEditingController(text: patient.phoneNumber ?? '');
  bool isActive = patient.isActive ?? true;

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Edit patient", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: "First name"),
                validator: (value) => value == null || value.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: "Last name"),
                validator: (value) => value == null || value.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone number"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Required";
                  if (!RegExp(r'^\d{9}$').hasMatch(value)) return "9-digit number";
                  return null;
                },
              ),
              const SizedBox(height: 10),
              StatefulBuilder(
                builder: (context, setDialogState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isActive ? "Active" : "Deactivated",
                        style: TextStyle(
                          color: isActive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Switch(
                        value: isActive,
                        onChanged: (val) => setDialogState(() => isActive = val),
                      ),
                    ],
                  );
                },
              ),



              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await Provider.of<PatientsProvider>(context, listen: false).update(patient.patientId!, {
                        "firstName": firstNameController.text,
                        "lastName": lastNameController.text,
                        "phoneNumber": phoneController.text,
                        "isActive": isActive,
                        "edit": true,
                      });

                      Navigator.pop(context);

                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: "Success",
                        text: "Patient updated.",
                      );

                      setState(() => _isLoading = true);
                      final refreshed = await Provider.of<PatientsProvider>(context, listen: false).get(retrieveAll: true);
                      setState(() {
                        _patients = refreshed.resultList;
                        _isLoading = false;
                      });
                    } catch (e) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: "Error",
                        text: "Update failed.",
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text("Save", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

}
