import 'package:flutter/material.dart';
import 'package:chantier_manager/src/features/teams/presentation/team_management_screen.dart';
import 'package:chantier_manager/src/features/teams/presentation/group_management_screen.dart';
import 'package:chantier_manager/src/features/settings/presentation/settings_screen.dart';
import 'package:chantier_manager/src/features/planning/presentation/planning_screen.dart';
import 'package:chantier_manager/src/features/finance/presentation/finance_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            extended: true,
            backgroundColor: Colors.blueGrey[900],
            unselectedIconTheme: const IconThemeData(color: Colors.white70),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
            selectedIconTheme: const IconThemeData(color: Colors.white),
            selectedLabelTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text("Vue Globale")),
              NavigationRailDestination(icon: Icon(Icons.people), label: Text("Équipes")),
              NavigationRailDestination(icon: Icon(Icons.groups), label: Text("Sous-équipes")),
              NavigationRailDestination(icon: Icon(Icons.calendar_today), label: Text("Planning")),
              NavigationRailDestination(icon: Icon(Icons.euro), label: Text("Finances")),
              NavigationRailDestination(icon: Icon(Icons.settings), label: Text("Configuration")),
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: (val) {
              setState(() {
                _selectedIndex = val;
              });
            },
          ),
          
          // Main Content
          Expanded(
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(24),
              child: _buildContent(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildGlobalView();
      case 1:
        return const TeamManagementScreen();
      case 2:
        return const GroupManagementScreen();
      case 3:
        return const PlanningScreen();
      case 4:
        return const FinanceScreen();
      case 5:
        return const SettingsScreen();
      default:
        return _buildGlobalView();
    }
  }

  Widget _buildPlaceholder(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          const Text("Module en cours de développement", style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildGlobalView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                "Tableau de Bord - Chantier A", 
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download),
              label: const Text("Export Rapport (PDF)"),
            )
          ],
        ),
        const SizedBox(height: 30),
        
        // KPI Cards
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildKPICard("Avancement Global", "68%", Colors.blue),
            _buildKPICard("Budget Consommé", "42%", Colors.green),
            _buildKPICard("Effectif Présent", "24/30", Colors.orange),
            _buildKPICard("Alertes Sécurité", "0", Colors.red),
          ],
        ),
        
        const SizedBox(height: 30),
        
        // Kanban / Gantt Area
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recent Tasks (Kanban-ish)
              Expanded(
                flex: 2,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tâches en Cours (Live)", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const Divider(),
                        Expanded(
                          child: ListView(
                            children: [
                              _buildTaskItem("Coulage Béton B2", "En cours - 40%", Colors.orange),
                              _buildTaskItem("Pose Placo Apt 104", "En attente validation", Colors.blue),
                              _buildTaskItem("Électricité Gaine Tech", "Terminé", Colors.green),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Activity Feed
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Activités Récentes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Divider(),
                        const ListTile(
                          leading: Icon(Icons.audiotrack, color: Colors.purple),
                          title: Text("Note audio ajoutée"),
                          subtitle: Text("Chef Chantier • Il y a 5 min"),
                        ),
                        const ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.green),
                          title: Text("Tâche validée: Mur Séjour"),
                          subtitle: Text("Admin • Il y a 12 min"),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildKPICard(String title, String value, Color color) {
    return Container(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 200),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 10),
              Text(value, style: TextStyle(color: color, fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem(String title, String status, Color color) {
    return Card(
      elevation: 0,
      color: Colors.grey[50], // minimal
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(status, style: TextStyle(color: color)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
