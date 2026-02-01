import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter_sound/flutter_sound.dart'; // Uncomment when implementing logic

class CreateTaskScreen extends ConsumerStatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  ConsumerState<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  
  // Media State
  final List<String> _imagePaths = [];
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    // High Contrast Theme colors
    final backgroundColor = Colors.white;

    final primaryColor = Colors.blue[900]; // Deep Blue for visibility

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("NOUVELLE TÂCHE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 1.2)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildSectionHeader("DÉTAILS"),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    labelText: 'TITRE DE LA TÂCHE',
                    border: OutlineInputBorder(borderSide: BorderSide(width: 2.0)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (v) => v!.isEmpty ? 'Requis' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'DESCRIPTION / NOTES',
                    border: OutlineInputBorder(borderSide: BorderSide(width: 2.0)),
                    alignLabelWithHint: true,
                  ),
                ),
                
                const SizedBox(height: 30),
                _buildSectionHeader("MÉDIAS (OBLIGATOIRE)"),
                const SizedBox(height: 10),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildLargeButton(
                        icon: Icons.camera_alt,
                        label: "PHOTO",
                        color: Colors.orange[800]!,
                        onTap: _pickImage,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildLargeButton(
                        icon: _isRecording ? Icons.stop : Icons.mic,
                        label: _isRecording ? "STOP" : "VOCAL",
                        color: _isRecording ? Colors.red : Colors.green[800]!,
                        onTap: _toggleRecording,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                if (_imagePaths.isNotEmpty) ...[
                  const Text("Photos ajoutées:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imagePaths.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: kIsWeb 
                            ? Image.network(_imagePaths[index], width: 100, height: 100, fit: BoxFit.cover)
                            : Image.file(File(_imagePaths[index]), width: 100, height: 100, fit: BoxFit.cover),
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 40),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Max Contrast
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _submitTask,
                    child: const Text("CRÉER LA TÂCHE", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      color: Colors.grey[200],
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildLargeButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 2), // High definition border
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.camera); // Direct to camera for field work
    if (file != null) {
      setState(() => _imagePaths.add(file.path));
    }
  }

  void _toggleRecording() {
    // Implement Recorder logic
    setState(() => _isRecording = !_isRecording);
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      // Call Repository
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tâche sauvegardée localement (Sync...)')));
    }
  }
}
