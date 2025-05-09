import 'package:flutter/material.dart';
import 'package:healthease_desktop/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:healthease_desktop/providers/users_provider.dart';
import 'package:healthease_desktop/providers/patients_provider.dart';
import 'package:healthease_desktop/providers/doctors_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int employeesCount = 0;
  int patientsCount = 0;
  int doctorsCount = 0;
  bool _isLoading = true;
  late ScrollController _scrollController;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _fetchDashboardData();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchDashboardData() async {
    setState(() => _isLoading = true);
    try {
      var employeesResult =
          await Provider.of<UsersProvider>(context, listen: false).get();
      if (!mounted) return;

      var patientsResult =
          await Provider.of<PatientsProvider>(context, listen: false).get();
      if (!mounted) return;

      var doctorsResult =
          await Provider.of<DoctorsProvider>(context, listen: false).get();
      if (!mounted) return;

      setState(() {
        employeesCount = employeesResult.resultList.length;
        patientsCount = patientsResult.resultList.length;
        doctorsCount = doctorsResult.resultList.length;
      });

      _controller.forward();
    } catch (e) {
      if (mounted) {
        await showErrorAlert(context, "Failed to fetch dashboard data: $e");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildAnimatedCounter({required int targetValue, TextStyle? style}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        int value = (_animation.value * targetValue).toInt();
        return Text(
          "$value",
          style:
              style ??
              const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        );
      },
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required int count,
    required String subtitle,
    Color? color,
  }) {
    return Container(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 300),
      child: Card(
        elevation: 8,
        shadowColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: color ?? Colors.blue),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 15),
              _buildAnimatedCounter(targetValue: count),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    int total = employeesCount + patientsCount + doctorsCount;
    if (total == 0) {
      return const Center(child: Text("No data available for pie chart"));
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              sectionsSpace: 5,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  color: Colors.indigo,
                  value: employeesCount.toDouble(),
                  title:
                      '${((employeesCount / total) * 100).toStringAsFixed(1)}%',
                  radius: 80,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PieChartSectionData(
                  color: Colors.teal,
                  value: patientsCount.toDouble(),
                  title:
                      '${((patientsCount / total) * 100).toStringAsFixed(1)}%',
                  radius: 80,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PieChartSectionData(
                  color: Colors.deepPurple,
                  value: doctorsCount.toDouble(),
                  title:
                      '${((doctorsCount / total) * 100).toStringAsFixed(1)}%',
                  radius: 80,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfitChart() {
    List<FlSpot> profits = [
      const FlSpot(0, 1000),
      const FlSpot(1, 3000),
      const FlSpot(2, 2000),
      const FlSpot(3, 4000),
      const FlSpot(4, 3500),
      const FlSpot(5, 5000),
    ];

    if (profits.isEmpty) {
      return const Center(child: Text("No data available for profit chart"));
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text('Jan');
                        case 1:
                          return const Text('Feb');
                        case 2:
                          return const Text('Mar');
                        case 3:
                          return const Text('Apr');
                        case 4:
                          return const Text('May');
                        case 5:
                          return const Text('Jun');
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: profits,
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsOverview() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Appointments Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: const [
                    Text(
                      "Total",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text("120"),
                  ],
                ),
                Column(
                  children: const [
                    Text(
                      "Approved",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("85"),
                  ],
                ),
                Column(
                  children: const [
                    Text(
                      "Pending",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("25"),
                  ],
                ),
                Column(
                  children: const [
                    Text(
                      "Declined",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("10"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Scrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Welcome back!",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildCard(
                              icon: Icons.people,
                              title: "Employees",
                              subtitle: "Total active employees",
                              count: employeesCount,
                              color: Colors.indigo,
                            ),
                            _buildCard(
                              icon: Icons.person_outline,
                              title: "Patients",
                              subtitle: "Total registered patients",
                              count: patientsCount,
                              color: Colors.teal,
                            ),
                            _buildCard(
                              icon: Icons.medical_services_outlined,
                              title: "Doctors",
                              subtitle: "Total available doctors",
                              count: doctorsCount,
                              color: Colors.deepPurple,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Center(child: _buildPieChart()),
                        const SizedBox(height: 30),
                        Center(child: _buildProfitChart()),
                        const SizedBox(height: 30),
                        Center(child: _buildAppointmentsOverview()),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
