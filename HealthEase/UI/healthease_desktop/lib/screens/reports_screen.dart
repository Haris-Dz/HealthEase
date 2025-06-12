import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../providers/admin_report_summary_provider.dart';
import '../models/admin_report_summary.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _loaded = false;
  final Map<String, bool> _sections = {
    "appointments": true,
    "revenue": true,
    "topDoctorsByAppointments": true,
    "topDoctorsByRating": true,
  };

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_loaded) {
        _fetchReport();
        _loaded = true;
      }
    });
  }

  void _fetchReport() {
    Provider.of<AdminReportProvider>(
      context,
      listen: false,
    ).fetchReportSummary(startDate: _startDate, endDate: _endDate);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminReportProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Colors.blue.shade50,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Icon(Icons.filter_alt, color: Colors.blueAccent),
                  const SizedBox(width: 6),
                  Text(
                    "Period:",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  _dateFilterField(
                    "Start",
                    _startDate,
                    (d) {
                      setState(() => _startDate = d);
                    },
                    () {
                      setState(() => _startDate = null);
                    },
                  ),
                  const Text("—"),
                  _dateFilterField(
                    "End",
                    _endDate,
                    (d) {
                      setState(() => _endDate = d);
                    },
                    () {
                      setState(() => _endDate = null);
                    },
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.filter_list),
                    label: const Text("Apply"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: _fetchReport,
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: "Reset All",
                    onPressed: () {
                      setState(() {
                        _startDate = null;
                        _endDate = null;
                      });
                      _fetchReport();
                    },
                  ),
                  const SizedBox(width: 35),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Save as PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade50,
                      foregroundColor: Colors.deepPurple,
                    ),
                    onPressed:
                        provider.report == null
                            ? null
                            : () => _exportPdf(
                              context,
                              provider.report!,
                              save: true,
                            ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.print),
                    label: const Text('Print'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade50,
                      foregroundColor: Colors.orange.shade800,
                    ),
                    onPressed:
                        provider.report == null
                            ? null
                            : () => _exportPdf(
                              context,
                              provider.report!,
                              save: false,
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade50,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Wrap(
              spacing: 24,
              children: [
                _sectionCheckbox("appointments", "Appointments"),
                _sectionCheckbox("revenue", "Revenue"),
                _sectionCheckbox(
                  "topDoctorsByAppointments",
                  "Top by Appointments",
                ),
                _sectionCheckbox("topDoctorsByRating", "Top by Rating"),
              ],
            ),
          ),
        ),
        Expanded(
          child:
              provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.error != null
                  ? Center(
                    child: Text(
                      provider.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                  : provider.report == null
                  ? const Center(child: Text("No data."))
                  : _buildReportSummary(provider.report!),
        ),
      ],
    );
  }

  Widget _dateFilterField(
    String label,
    DateTime? date,
    ValueChanged<DateTime?> onChange,
    VoidCallback onClear,
  ) {
    return SizedBox(
      width: 120,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 1)),
              );
              if (picked != null) onChange(picked);
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
              ),
              child: Text(
                date != null ? DateFormat('yyyy-MM-dd').format(date) : '',
              ),
            ),
          ),
          if (date != null)
            Positioned(
              right: 2,
              child: GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.clear, size: 18, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionCheckbox(String key, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: _sections[key],
          onChanged: (v) => setState(() => _sections[key] = v!),
        ),
        Text(label),
      ],
    );
  }

  Widget _sectionTitle(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildReportSummary(AdminReportSummary report) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_sections["revenue"]!)
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 14),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Revenue by Month", Icons.bar_chart),
                    const Divider(),
                    _statTile(
                      "Total revenue",
                      "\$${report.totalRevenue.toStringAsFixed(2)}",
                      borderColor: Colors.indigo,
                    ),
                    const SizedBox(height: 10),
                    if (report.revenuePerMonth.isEmpty)
                      const Text(
                        "No revenue data.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    if (report.revenuePerMonth.isNotEmpty)
                      DataTable(
                        columns: const [
                          DataColumn(label: Text("Month")),
                          DataColumn(label: Text("Revenue")),
                        ],
                        rows:
                            report.revenuePerMonth
                                .map(
                                  (e) => DataRow(
                                    cells: [
                                      DataCell(Text(e.month)),
                                      DataCell(
                                        Text(
                                          "\$${e.revenue.toStringAsFixed(2)}",
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                      ),
                  ],
                ),
              ),
            ),

          if (_sections["appointments"]!)
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 14),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(
                      "Appointments Overview",
                      Icons.event_available,
                    ),
                    const Divider(),
                    Wrap(
                      runSpacing: 16,
                      spacing: 38,
                      children: [
                        _statTile(
                          "Total appointments",
                          report.totalAppointments.toString(),
                          borderColor: Colors.blueAccent,
                        ),
                        _statTile(
                          "Approved",
                          report.approvedAppointments.toString(),
                          borderColor: Colors.green,
                        ),
                        _statTile(
                          "Declined",
                          report.declinedAppointments.toString(),
                          borderColor: Colors.redAccent,
                        ),
                        _statTile(
                          "Pending",
                          report.pendingAppointments.toString(),
                          borderColor: Colors.orangeAccent,
                        ),
                        _statTile(
                          "Paid",
                          report.paidAppointments.toString(),
                          borderColor: Colors.deepPurpleAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          if (_sections["topDoctorsByAppointments"]!)
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 14),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Top 3 Doctors by Appointments", Icons.star),
                    const Divider(),
                    if (report.topDoctorsByAppointments.isEmpty)
                      const Text(
                        "No data.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    if (report.topDoctorsByAppointments.isNotEmpty)
                      DataTable(
                        columns: const [
                          DataColumn(label: Text("Doctor")),
                          DataColumn(label: Text("Appointments")),
                        ],
                        rows:
                            report.topDoctorsByAppointments
                                .map(
                                  (d) => DataRow(
                                    cells: [
                                      DataCell(Text(d.name)),
                                      DataCell(
                                        Text(d.appointmentsCount.toString()),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                      ),
                  ],
                ),
              ),
            ),

          if (_sections["topDoctorsByRating"]!)
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 14),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Top 3 Doctors by Rating", Icons.thumb_up),
                    const Divider(),
                    if (report.topDoctorsByRating.isEmpty)
                      const Text(
                        "No data.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    if (report.topDoctorsByRating.isNotEmpty)
                      DataTable(
                        columns: const [
                          DataColumn(label: Text("Doctor")),
                          DataColumn(label: Text("Avg. Rating")),
                        ],
                        rows:
                            report.topDoctorsByRating
                                .map(
                                  (d) => DataRow(
                                    cells: [
                                      DataCell(Text(d.name)),
                                      DataCell(
                                        Text(
                                          d.averageRating?.toStringAsFixed(2) ??
                                              "N/A",
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _exportPdf(
    BuildContext context,
    AdminReportSummary report, {
    required bool save,
  }) async {
    final pdf = await _buildPdf(report);
    if (save) {
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'HealthEase_Report.pdf',
      );
    } else {
      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    }
  }

  Future<pw.Document> _buildPdf(AdminReportSummary report) async {
    final doc = pw.Document();

    final baseColor = PdfColor.fromHex("#1565C0");
    final sectionTitleStyle = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      fontSize: 16,
      color: baseColor,
    );

    doc.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(26),
        build:
            (context) => [
              pw.Container(
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'HealthEase',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: baseColor,
                      ),
                    ),
                    pw.Text(
                      'Admin Report',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.Divider(),
              if (_sections["appointments"]!)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 12),
                    pw.Text("Appointments Overview", style: sectionTitleStyle),
                    pw.Divider(thickness: 0.6),
                    pw.Wrap(
                      spacing: 22,
                      runSpacing: 8,
                      children: [
                        _statCard(
                          "Total appointments",
                          report.totalAppointments,
                          baseColor,
                        ),
                        _statCard(
                          "Approved",
                          report.approvedAppointments,
                          PdfColor.fromHex("#2E7D32"),
                        ),
                        _statCard(
                          "Declined",
                          report.declinedAppointments,
                          PdfColor.fromHex("#B71C1C"),
                        ),
                        _statCard(
                          "Pending",
                          report.pendingAppointments,
                          PdfColor.fromHex("#FF8F00"),
                        ),
                        _statCard(
                          "Paid",
                          report.paidAppointments,
                          PdfColor.fromHex("#1565C0"),
                        ),
                        _statCard(
                          "Reviews",
                          report.totalReviews,
                          PdfColor.fromHex("#333"),
                        ),
                        _statCard(
                          "Avg. rating",
                          report.averageDoctorRating.toStringAsFixed(2),
                          PdfColor.fromHex("#FBC02D"),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 24),
                  ],
                ),
              if (_sections["revenue"]!)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Revenue by Month", style: sectionTitleStyle),
                    pw.Divider(thickness: 0.6),
                    pw.Text(
                      "Total revenue: \$${report.totalRevenue.toStringAsFixed(2)}",
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColor.fromHex("#444"),
                      ),
                    ),
                    report.revenuePerMonth.isEmpty
                        ? pw.Text(
                          "No revenue data.",
                          style: pw.TextStyle(color: PdfColor.fromHex("#666")),
                        )
                        : pw.TableHelper.fromTextArray(
                          border: null,
                          headerStyle: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: baseColor,
                          ),
                          cellStyle: pw.TextStyle(fontSize: 12),
                          cellAlignments: {
                            0: pw.Alignment.centerLeft,
                            1: pw.Alignment.centerRight,
                          },
                          headers: ["Month", "Revenue"],
                          data:
                              report.revenuePerMonth
                                  .map(
                                    (e) => [
                                      e.month,
                                      "\$${e.revenue.toStringAsFixed(2)}",
                                    ],
                                  )
                                  .toList(),
                        ),
                    pw.SizedBox(height: 22),
                  ],
                ),
              if (_sections["topDoctorsByAppointments"]!)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Top 3 Doctors by Appointments",
                      style: sectionTitleStyle,
                    ),
                    pw.Divider(thickness: 0.6),
                    report.topDoctorsByAppointments.isEmpty
                        ? pw.Text(
                          "No data.",
                          style: pw.TextStyle(color: PdfColor.fromHex("#666")),
                        )
                        : pw.TableHelper.fromTextArray(
                          border: null,
                          headerStyle: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: baseColor,
                          ),
                          cellStyle: pw.TextStyle(fontSize: 12),
                          cellAlignments: {
                            0: pw.Alignment.centerLeft,
                            1: pw.Alignment.centerRight,
                          },
                          headers: ["Doctor", "Appointments"],
                          data:
                              report.topDoctorsByAppointments
                                  .map(
                                    (d) => [
                                      d.name,
                                      d.appointmentsCount.toString(),
                                    ],
                                  )
                                  .toList(),
                        ),
                    pw.SizedBox(height: 22),
                  ],
                ),
              if (_sections["topDoctorsByRating"]!)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Top 3 Doctors by Rating",
                      style: sectionTitleStyle,
                    ),
                    pw.Divider(thickness: 0.6),
                    report.topDoctorsByRating.isEmpty
                        ? pw.Text(
                          "No data.",
                          style: pw.TextStyle(color: PdfColor.fromHex("#666")),
                        )
                        : pw.TableHelper.fromTextArray(
                          border: null,
                          headerStyle: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: baseColor,
                          ),
                          cellStyle: pw.TextStyle(fontSize: 12),
                          cellAlignments: {
                            0: pw.Alignment.centerLeft,
                            1: pw.Alignment.centerRight,
                          },
                          headers: ["Doctor", "Avg. Rating"],
                          data:
                              report.topDoctorsByRating
                                  .map(
                                    (d) => [
                                      d.name,
                                      d.averageRating?.toStringAsFixed(2) ??
                                          "N/A",
                                    ],
                                  )
                                  .toList(),
                        ),
                    pw.SizedBox(height: 22),
                  ],
                ),
              pw.Spacer(),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    "Generated: ${DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now())}",
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColor.fromHex("#888"),
                    ),
                  ),
                ],
              ),
            ],
      ),
    );

    return doc;
  }

  pw.Widget _statCard(String label, dynamic value, PdfColor color) {
    return pw.Container(
      width: 95,
      height: 55,
      margin: const pw.EdgeInsets.only(bottom: 2),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColor.fromHex("#F5F8FE"),
        border: pw.Border.all(color: color, width: 1.0),
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 6),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 10, color: color)),
          pw.SizedBox(height: 2),
          pw.Text(
            value.toString(),
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromHex("#222"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile(
    String label,
    String value, {
    Color borderColor = Colors.blueAccent,
  }) {
    return SizedBox(
      width: 160,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 2.2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: borderColor.withOpacity(0.88),
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: borderColor,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
