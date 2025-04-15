import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:healthease_desktop/models/patient.dart';
import 'package:healthease_desktop/models/user.dart';
import 'package:healthease_desktop/providers/patients_provider.dart';
import 'package:healthease_desktop/providers/users_provider.dart';
import 'package:provider/provider.dart';

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
      // UserGet
      var usersResult = await Provider.of<UsersProvider>(context, listen: false)
          .get(filter: {"IsUserRoleIncluded": true}, retrieveAll: true);
      _users = usersResult.resultList;

      // PatientGet
      var patientsResult = await Provider.of<PatientsProvider>(context, listen: false)
          .get(retrieveAll: true);
      _patients = patientsResult.resultList;
      
    } catch (e) {
      print('Greška pri dohvaćanju podataka: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  });
}


  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    final patientsProvider = Provider.of<PatientsProvider>(context);

    final filteredUsers = _users
        .where((u) =>
            (u.firstName ?? '')
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            (u.lastName ?? '')
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
        .toList();

    final filteredPatients = _patients
        .where((p) =>
            (p.firstName ?? '')
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            (p.lastName ?? '')
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
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
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()))
              : _buildTableContainer(
                  isEmployeesSelected ? filteredUsers : filteredPatients,
                ),
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
          hintText: isEmployeesSelected
              ? "Search employees..."
              : "Search patients...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                    DataCell(_buildActions()),
                  ]);
                } else {
                  final patient = data[index];
                  final status =
                      (patient.isActive ?? false) ? "Active" : "Deactivated";
                  return DataRow(cells: [
                    DataCell(Text(
                        "${patient.firstName ?? ''} ${patient.lastName ?? ''}")),
                    DataCell(
                      Text(
                        status,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: status == "Active" ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    DataCell(_buildActions()),
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
      onPressed: () {
        // TODO: implement add logic
      },
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

  Widget _buildActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {},
        ),
      ],
    );
  }
}
