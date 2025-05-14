import 'package:flutter/material.dart';
import 'package:healthease_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:healthease_mobile/layouts/master_screen.dart';
import 'package:healthease_mobile/models/transaction.dart';
import 'package:healthease_mobile/providers/auth_provider.dart';
import 'package:healthease_mobile/providers/transactions_provider.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  final Set<int> _expandedIndices = {};

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  double get totalPaid =>
      _transactions.fold(0, (sum, tx) => sum + (tx.amount ?? 0));

  Future<void> _loadPayments() async {
    final provider = Provider.of<TransactionsProvider>(context, listen: false);
    try {
      final result = await provider.get(
        filter: {"patientId": AuthProvider.patientId.toString()},
        retrieveAll: true,
      );

      if (!mounted) return;
      setState(() {
        _transactions = result.resultList;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load payments: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: 'Payments',
      currentRoute: 'Payments',
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _transactions.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 72,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No payments yet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Once you make a payment,\nyour receipts will appear here.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black45),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _transactions.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Header with total
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        color: Colors.green.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.payments_outlined,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Total Spent:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "\$${totalPaid.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final tx = _transactions[index - 1];
                  final isExpanded = _expandedIndices.contains(index);

                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedIndices.remove(index);
                        } else {
                          _expandedIndices.add(index);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow("Transaction", tx.paymentId ?? "N/A"),
                            const SizedBox(height: 8),
                            _infoRow(
                              "Paid:",
                              formatDateString(tx.transactionDate),
                            ),
                            if (isExpanded) ...[
                              const SizedBox(height: 12),
                              const Divider(),
                              const SizedBox(height: 12),
                              _infoRow(
                                "Doctor:",
                                "${tx.appointment?.doctor?.user?.firstName ?? ""} ${tx.appointment?.doctor?.user?.lastName ?? ""}",
                              ),
                              const SizedBox(height: 8),
                              _infoRow(
                                "Amount:",
                                "${tx.amount?.toStringAsFixed(2)} \$",
                              ),
                              const SizedBox(height: 8),
                              _infoRow(
                                "Payment method:",
                                tx.paymentMethod ?? "N/A",
                              ),
                              const SizedBox(height: 8),
                              _infoRow(
                                "Appointment type:",
                                tx.appointment?.appointmentType?.name ?? "N/A",
                              ),
                            ],
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 2),
        Text(
          value ?? "N/A",
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}
