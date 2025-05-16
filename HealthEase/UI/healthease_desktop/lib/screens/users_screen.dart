import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:healthease_desktop/models/role.dart';
import 'package:healthease_desktop/models/search_result.dart';
import 'package:healthease_desktop/providers/roles_provider.dart';
import 'package:provider/provider.dart';
import 'package:healthease_desktop/models/user.dart';
import 'package:healthease_desktop/models/patient.dart';
import 'package:healthease_desktop/providers/users_provider.dart';
import 'package:healthease_desktop/providers/patients_provider.dart';
import 'package:healthease_desktop/providers/utils.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> _users = [];
  List<Patient> _patients = [];
  bool _isLoading = false;
  bool isEmployeesSelected = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async => await _refreshData());
  }

  bool _disposed = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _disposed = true;
    super.dispose();
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final usersResult = await Provider.of<UsersProvider>(
        context,
        listen: false,
      ).get(filter: {"IsUserRoleIncluded": true}, retrieveAll: true);
      final patientsResult = await Provider.of<PatientsProvider>(
        context,
        listen: false,
      ).get(retrieveAll: true);

      if (!_disposed) {
        setState(() {
          _users = usersResult.resultList;
          _patients = patientsResult.resultList;
        });
      }
    } catch (e) {
      if (!_disposed) {
        await showErrorAlert(context, "Failed to fetch data. $e");
      }
    } finally {
      if (!_disposed) {
        setState(() => _isLoading = false);
      }
    }
  }

  Timer? _debounce;

  void _filterSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => searchQuery = query);
      }
    });
  }

  List<dynamic> get _filteredList =>
      isEmployeesSelected
          ? _users
              .where(
                (u) =>
                    (u.firstName ?? '').toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    (u.lastName ?? '').toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
              )
              .toList()
          : _patients
              .where(
                (p) =>
                    (p.firstName ?? '').toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    (p.lastName ?? '').toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
              )
              .toList();

  Future<void> _handleDelete(dynamic user) async {
    final confirmed = await showCustomConfirmDialog(
      context,
      title: 'Confirm Deletion',
      text: 'Are you sure you want to delete this user?',
    );

    if (confirmed) {
      try {
        if (isEmployeesSelected) {
          await Provider.of<UsersProvider>(
            context,
            listen: false,
          ).delete(user.userId);
        } else {
          await Provider.of<PatientsProvider>(
            context,
            listen: false,
          ).delete(user.patientId);
        }

        if (mounted) {
          await showSuccessAlert(
            context,
            "The user has been deleted successfully.",
          );
        }
        await _refreshData();
      } catch (e) {
        if (mounted) await showErrorAlert(context, "Failed to delete user. $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFFE3F2FD),
      child: Column(
        children: [
          _buildToggle(),
          const SizedBox(height: 20),
          _buildSearchField(),
          const SizedBox(height: 20),
          _isLoading
              ? const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
              : _buildTableContainer(_filteredList),
          const SizedBox(height: 20),
          if (isEmployeesSelected) _buildAddButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildToggle() => ToggleButtons(
    borderRadius: BorderRadius.circular(30),
    selectedColor: Colors.white,
    fillColor: Colors.blueAccent,
    color: Colors.blueGrey,
    isSelected: [isEmployeesSelected, !isEmployeesSelected],
    onPressed: (index) => setState(() => isEmployeesSelected = index == 0),
    children: const [
      Padding(padding: EdgeInsets.all(10), child: Text("Employees")),
      Padding(padding: EdgeInsets.all(10), child: Text("Patients")),
    ],
  );

  Widget _buildSearchField() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: TextField(
      decoration: InputDecoration(
        hintText:
            isEmployeesSelected ? "Search employees..." : "Search patients...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onChanged: _filterSearch,
    ),
  );

  Widget _buildTableContainer(List<dynamic> data) => Expanded(
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
                ),
              ],
            ),
            child: _buildTable(data),
          ),
        ),
      ),
    ),
  );

  Widget _buildTable(List<dynamic> data) => SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 400, minWidth: 800),
        child: DataTable(
          columnSpacing: 100,
          headingRowColor: MaterialStateProperty.all(Colors.blue.shade100),
          columns:
              isEmployeesSelected
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
          rows: data.map((item) => _buildDataRow(item)).toList(),
        ),
      ),
    ),
  );

  DataRow _buildDataRow(dynamic item) => DataRow(
    cells:
        isEmployeesSelected
            ? [
              DataCell(Text("${item.firstName} ${item.lastName}")),
              DataCell(
                Text(
                  item.userRoles.isNotEmpty
                      ? item.userRoles.first.role?.roleName ?? 'N/A'
                      : 'N/A',
                ),
              ),
              DataCell(_buildActionButtons(item)),
            ]
            : [
              DataCell(Text("${item.firstName ?? ''} ${item.lastName ?? ''}")),
              DataCell(
                Text(
                  (item.isActive ?? false) ? "Active" : "Deactivated",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (item.isActive ?? false) ? Colors.green : Colors.red,
                  ),
                ),
              ),
              DataCell(_buildActionButtons(item)),
            ],
  );

  Widget _buildActionButtons(dynamic user) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.edit, color: Colors.blue),
        onPressed: () => _openEditDialog(user),
      ),
      IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () async => await _handleDelete(user),
      ),
    ],
  );

  void _openEditDialog(dynamic user) {
    if (isEmployeesSelected) {
      _showAddOrEditUserDialog(context, existingUser: user);
    } else {
      _showEditPatientDialog(context, user);
    }
  }

  void _showAddOrEditUserDialog(BuildContext context, {User? existingUser}) {
    final _formKey = GlobalKey<FormState>();
    final firstNameController = TextEditingController(
      text: existingUser?.firstName ?? '',
    );
    final lastNameController = TextEditingController(
      text: existingUser?.lastName ?? '',
    );
    final emailController = TextEditingController(
      text: existingUser?.email ?? '',
    );
    final usernameController = TextEditingController(
      text: existingUser?.username ?? '',
    );
    final phoneNumberController = TextEditingController(
      text: existingUser?.phoneNumber ?? '',
    );
    int? selectedRoleId =
        existingUser?.userRoles?.isNotEmpty == true
            ? existingUser?.userRoles!.first.role?.roleId
            : null;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                          existingUser != null
                              ? "Edit Employee"
                              : "Add New Employee",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: firstNameController,
                          decoration: const InputDecoration(
                            labelText: "First Name",
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? "First name is required"
                                      : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: lastNameController,
                          decoration: const InputDecoration(
                            labelText: "Last Name",
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? "Last name is required"
                                      : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                            labelText: "Phone Number",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return null;
                            if (!RegExp(r'^\d{9}$').hasMatch(value))
                              return "Enter a 9-digit number";
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Tooltip(
                          message:
                              existingUser != null
                                  ? "Email cannot be changed"
                                  : "",
                          child: TextFormField(
                            controller: emailController,
                            enabled: existingUser == null,
                            decoration: const InputDecoration(
                              labelText: "Email",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Email is required";
                              final emailRegex = RegExp(
                                r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                              );
                              if (!emailRegex.hasMatch(value))
                                return "Enter a valid email";
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Tooltip(
                          message:
                              existingUser != null
                                  ? "Username cannot be changed"
                                  : "",
                          child: TextFormField(
                            controller: usernameController,
                            enabled: existingUser == null,
                            decoration: const InputDecoration(
                              labelText: "Username",
                            ),
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? "Username is required"
                                        : null,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (existingUser == null)
                          FutureBuilder(
                            future: Provider.of<RolesProvider>(
                              context,
                              listen: false,
                            ).get(retrieveAll: true),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text("Failed to load roles");
                              } else {
                                final roles =
                                    (snapshot.data as SearchResult<Role>)
                                        .resultList;
                                return DropdownButtonFormField<int>(
                                  decoration: const InputDecoration(
                                    labelText: "Role",
                                  ),
                                  items:
                                      roles.map((role) {
                                        return DropdownMenuItem<int>(
                                          value: role.roleId,
                                          child: Text(role.roleName ?? ''),
                                        );
                                      }).toList(),
                                  onChanged: (value) => selectedRoleId = value,
                                  validator:
                                      (value) =>
                                          value == null
                                              ? "Please select a role"
                                              : null,
                                );
                              }
                            },
                          ),

                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                if (existingUser == null) {
                                  await Provider.of<UsersProvider>(
                                    context,
                                    listen: false,
                                  ).insert({
                                    "firstName": firstNameController.text,
                                    "lastName": lastNameController.text,
                                    "email": emailController.text,
                                    "username": usernameController.text,
                                    "phoneNumber": phoneNumberController.text,
                                    "roleId": selectedRoleId,
                                  });
                                } else {
                                  await Provider.of<UsersProvider>(
                                    context,
                                    listen: false,
                                  ).update(existingUser.userId!, {
                                    "firstName": firstNameController.text,
                                    "lastName": lastNameController.text,
                                    "phoneNumber": phoneNumberController.text,
                                  });
                                }

                                if (mounted) {
                                  Navigator.pop(context);
                                  await _refreshData();
                                  await showSuccessAlert(
                                    context,
                                    existingUser == null
                                        ? "User added successfully."
                                        : "User updated successfully.",
                                  );
                                }
                              } catch (e) {
                                if (mounted)
                                  await showErrorAlert(
                                    context,
                                    "Operation failed. $e",
                                  );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            existingUser == null ? "Add" : "Save",
                            style: const TextStyle(color: Colors.white),
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
                    onPressed: () => Navigator.pop(context),
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
    final firstNameController = TextEditingController(
      text: patient.firstName ?? '',
    );
    final lastNameController = TextEditingController(
      text: patient.lastName ?? '',
    );
    final phoneController = TextEditingController(
      text: patient.phoneNumber ?? '',
    );
    bool isActive = patient.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              "Edit Patient",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: firstNameController,
                              decoration: const InputDecoration(
                                labelText: "First Name",
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? "Required"
                                          : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: lastNameController,
                              decoration: const InputDecoration(
                                labelText: "Last Name",
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? "Required"
                                          : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: phoneController,
                              decoration: const InputDecoration(
                                labelText: "Phone Number",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return "Required";
                                if (!RegExp(r'^\d{9}$').hasMatch(value))
                                  return "Enter a valid 9-digit number";
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isActive
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color:
                                          isActive ? Colors.green : Colors.red,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isActive ? "Active" : "Deactivated",
                                      style: TextStyle(
                                        color:
                                            isActive
                                                ? Colors.green
                                                : Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: isActive,
                                  onChanged:
                                      (val) =>
                                          setDialogState(() => isActive = val),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      await Provider.of<PatientsProvider>(
                                        context,
                                        listen: false,
                                      ).update(patient.patientId!, {
                                        "firstName": firstNameController.text,
                                        "lastName": lastNameController.text,
                                        "phoneNumber": phoneController.text,
                                        "isActive": isActive,
                                        "edit": true,
                                      });

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        await _refreshData();
                                        await showSuccessAlert(
                                          context,
                                          "Patient updated successfully.",
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        await showErrorAlert(
                                          context,
                                          "Update failed. $e",
                                        );
                                      }
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
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
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAddButton() => ElevatedButton(
    onPressed: () => _openEditDialog(null),
    style: ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      backgroundColor: Colors.blue.shade700,
      padding: const EdgeInsets.all(20),
    ),
    child: const Icon(Icons.add, color: Colors.white, size: 30),
  );
}
