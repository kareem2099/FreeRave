import 'package:flutter/material.dart';
import 'package:freerave/connections/screens/connections_screen.dart';
import 'package:freerave/cut_loose/views/cut_loose_view.dart';
import 'package:freerave/note/screen/notes_screen.dart';
import 'package:freerave/quiz/screens/home_screen.dart';
import '../widget/grid_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FreeRave'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 items per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 80,
              ),
              itemCount: gridItems.length, // Use the length of gridItems
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConnectionsScreen(),
                        ),
                      );
                    }
                    if (index == 4) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotesScreen(),
                        ),
                      );
                    }
                    if (index == 5) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CutLooseView(),
                        ),
                      );
                    }
                    if (index == 7) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                 const HomeScreenQuiz()),
                      );
                    }
                  },
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(seconds: 1),
                    child: GridTile(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            gridItems[index].icon,
                            // Use the icon from gridItems
                            size: 50,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              gridItems[index].label,
                              // Use the label from gridItems
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
