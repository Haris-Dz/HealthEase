import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:healthease_desktop/models/appointment_type.dart';
import 'package:healthease_desktop/models/role.dart';
import 'package:healthease_desktop/models/specialization.dart';
import 'package:healthease_desktop/providers/appointment_types_provider.dart';
import 'package:healthease_desktop/providers/roles_provider.dart';
import 'package:healthease_desktop/providers/specializations_provider.dart';
import 'package:healthease_desktop/providers/utils.dart';

import 'package:healthease_desktop/screens/widgets/appointment_type_dialog.dart';
import 'package:healthease_desktop/screens/widgets/specialization_dialog.dart';
import 'package:healthease_desktop/screens/widgets/role_dialog.dart';

enum LookupEntityType { appointmentType, role, specialization }

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  List<AppointmentType> _appointmentTypes = [];
  List<Role> _roles = [];
  List<Specialization> _specializations = [];

  final TextEditingController _rolesSearchController = TextEditingController();
  final TextEditingController _appointmentTypesSearchController =
      TextEditingController();
  final TextEditingController _specializationsSearchController =
      TextEditingController();

  Timer? _rolesDebounce;
  Timer? _appointmentsDebounce;
  Timer? _specializationsDebounce;

  bool _isLoading = true;
  int? _expandedSectionIndex;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _rolesSearchController.dispose();
    _appointmentTypesSearchController.dispose();
    _specializationsSearchController.dispose();
    _rolesDebounce?.cancel();
    _appointmentsDebounce?.cancel();
    _specializationsDebounce?.cancel();
    super.dispose();
  }

  Future<void> _loadAll() async {
    try {
      final appointmentTypes = await Provider.of<AppointmentTypesProvider>(
        context,
        listen: false,
      ).get(retrieveAll: true);

      final roles = await Provider.of<RolesProvider>(
        context,
        listen: false,
      ).get(retrieveAll: true);

      final specs = await Provider.of<SpecializationsProvider>(
        context,
        listen: false,
      ).get(retrieveAll: true);

      if (!mounted) return;

      setState(() {
        _appointmentTypes = appointmentTypes.resultList;
        _roles = roles.resultList;
        _specializations = specs.resultList;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading management data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
          children: [
            _buildSection(
              title: "Appointment Types",
              index: 0,
              type: LookupEntityType.appointmentType,
              items: _appointmentTypes,
              searchController: _appointmentTypesSearchController,
            ),
            _buildSection(
              title: "Roles",
              index: 1,
              type: LookupEntityType.role,
              items: _roles,
              searchController: _rolesSearchController,
            ),
            _buildSection(
              title: "Doctor Specializations",
              index: 2,
              type: LookupEntityType.specialization,
              items: _specializations,
              searchController: _specializationsSearchController,
            ),
          ],
        );
  }

  Widget _buildSection({
    required String title,
    required int index,
    required LookupEntityType type,
    required List<dynamic> items,
    required TextEditingController searchController,
  }) {
    final isExpanded = _expandedSectionIndex == index;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            _expandedSectionIndex = expanded ? index : null;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: "Search by name...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                        ),
                        onChanged: (value) {
                          _handleDebouncedSearch(type, value);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onPressed: () => _handleAdd(type),
                      icon: const Icon(Icons.add),
                      label: const Text("Add New"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            type == LookupEntityType.role
                                ? item.roleName
                                : item.name ?? '',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _handleEdit(type, item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _handleDelete(type, item),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleDebouncedSearch(LookupEntityType type, String query) {
    switch (type) {
      case LookupEntityType.role:
        _rolesDebounce?.cancel();
        _rolesDebounce = Timer(const Duration(milliseconds: 400), () {
          _handleSearch(type, query);
        });
        break;
      case LookupEntityType.appointmentType:
        _appointmentsDebounce?.cancel();
        _appointmentsDebounce = Timer(const Duration(milliseconds: 400), () {
          _handleSearch(type, query);
        });
        break;
      case LookupEntityType.specialization:
        _specializationsDebounce?.cancel();
        _specializationsDebounce = Timer(const Duration(milliseconds: 400), () {
          _handleSearch(type, query);
        });
        break;
    }
  }

  Future<void> _handleSearch(LookupEntityType type, String query) async {
    try {
      switch (type) {
        case LookupEntityType.role:
          final roles = await Provider.of<RolesProvider>(
            context,
            listen: false,
          ).get(filter: {"roleNameGTE": query});
          setState(() => _roles = roles.resultList);
          break;
        case LookupEntityType.appointmentType:
          final appointments = await Provider.of<AppointmentTypesProvider>(
            context,
            listen: false,
          ).get(filter: {"nameGTE": query});
          setState(() => _appointmentTypes = appointments.resultList);
          break;
        case LookupEntityType.specialization:
          final specs = await Provider.of<SpecializationsProvider>(
            context,
            listen: false,
          ).get(filter: {"specializationNameGTE": query});
          setState(() => _specializations = specs.resultList);
          break;
      }
    } catch (e) {
      showErrorAlert(context, "Search failed: $e");
    }
  }

  Future<void> _handleAdd(LookupEntityType type) async {
    switch (type) {
      case LookupEntityType.role:
        final result = await showDialog(
          context: context,
          builder:
              (_) => RoleDialog(
                onSave: (name, desc) async {
                  await Provider.of<RolesProvider>(
                    context,
                    listen: false,
                  ).insert({"roleName": name, "description": desc});
                  await _loadAll();
                },
              ),
        );
        if (result == 'added') {
          showSuccessAlert(context, "New role added successfully");
        }
        break;

      case LookupEntityType.appointmentType:
        final result = await showDialog(
          context: context,
          builder:
              (_) => AppointmentTypeDialog(
                onSave: (name, price) async {
                  await Provider.of<AppointmentTypesProvider>(
                    context,
                    listen: false,
                  ).insert({"name": name, "price": price});
                  await _loadAll();
                },
              ),
        );
        if (result == 'added') {
          showSuccessAlert(context, "Appointment type added successfully");
        }
        break;

      case LookupEntityType.specialization:
        final result = await showDialog(
          context: context,
          builder:
              (_) => SpecializationDialog(
                onSave: (name, desc) async {
                  await Provider.of<SpecializationsProvider>(
                    context,
                    listen: false,
                  ).insert({"name": name, "description": desc});
                  await _loadAll();
                },
              ),
        );
        if (result == 'added') {
          showSuccessAlert(context, "Specialization added successfully");
        }
        break;
    }
  }

  Future<void> _handleEdit(LookupEntityType type, dynamic item) async {
    switch (type) {
      case LookupEntityType.role:
        final result = await showDialog(
          context: context,
          builder:
              (_) => RoleDialog(
                role: item,
                onSave: (name, desc) async {
                  await Provider.of<RolesProvider>(
                    context,
                    listen: false,
                  ).update(item.roleId, {
                    "roleName": name,
                    "description": desc,
                  });
                  await _loadAll();
                },
              ),
        );
        if (result == 'updated') {
          showSuccessAlert(context, "Role updated successfully");
        }
        break;

      case LookupEntityType.appointmentType:
        final result = await showDialog(
          context: context,
          builder:
              (_) => AppointmentTypeDialog(
                appointmentType: item,
                onSave: (name, price) async {
                  await Provider.of<AppointmentTypesProvider>(
                    context,
                    listen: false,
                  ).update(item.appointmentTypeId, {
                    "name": name,
                    "price": price,
                  });
                  await _loadAll();
                },
              ),
        );
        if (result == 'updated') {
          showSuccessAlert(context, "Appointment type updated successfully");
        }
        break;

      case LookupEntityType.specialization:
        final result = await showDialog(
          context: context,
          builder:
              (_) => SpecializationDialog(
                specialization: item,
                onSave: (name, desc) async {
                  await Provider.of<SpecializationsProvider>(
                    context,
                    listen: false,
                  ).update(item.specializationId, {
                    "name": name,
                    "description": desc,
                  });
                  await _loadAll();
                },
              ),
        );
        if (result == 'updated') {
          showSuccessAlert(context, "Specialization updated successfully");
        }
        break;
    }
  }

  Future<void> _handleDelete(LookupEntityType type, dynamic item) async {
    String deleteText = "Are you sure you want to delete this item?";

    if (type == LookupEntityType.role) {
      deleteText =
          "Are you sure you want to delete this role?\n\n"
          "This action will hide it from management screens, but it won't affect users currently assigned to it.";
    }

    final confirmed = await showCustomConfirmDialog(
      context,
      title: "Confirm Delete",
      text: deleteText,
      confirmBtnText: "Delete",
      cancelBtnText: "Cancel",
      confirmBtnColor: Colors.red,
    );

    if (!confirmed) return;

    try {
      switch (type) {
        case LookupEntityType.role:
          await Provider.of<RolesProvider>(
            context,
            listen: false,
          ).delete(item.roleId);
          break;
        case LookupEntityType.appointmentType:
          await Provider.of<AppointmentTypesProvider>(
            context,
            listen: false,
          ).delete(item.appointmentTypeId);
          break;
        case LookupEntityType.specialization:
          await Provider.of<SpecializationsProvider>(
            context,
            listen: false,
          ).delete(item.specializationId);
          break;
      }
      await _loadAll();
      showSuccessAlert(context, "Item deleted successfully");
    } catch (e) {
      showErrorAlert(context, "Failed to delete item: $e");
    }
  }
}
