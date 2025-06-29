import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/store.dart';
// import '../state/actions.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({Key? key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  // final List<Map<String, dynamic>> templates = [];
  // final store = Provider.of<AppStore>(context, listen: false);
  // final templates = store.state.templates;

  late AppStore store;
  late List<Map<String, dynamic>> templates;

  void _navigateToAddDetail(BuildContext context) async {
    // Get the ID of the last item in the list and increment it
    final lastId = templates.isEmpty ? 0 : int.parse(templates.last['id']);
    final newId = (lastId + 1).toString();

    await context.push('/generator/add/$newId');
  }

  @override
  Widget build(BuildContext context) {
    store = Provider.of<AppStore>(context, listen: false);
    templates = store.state.templates;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Todo Generator',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              IconButton(
                onPressed: () => _navigateToAddDetail(context),
                icon: Icon(Icons.note_add_outlined),
              ),
            ],
          ),
          Expanded(
            child:
                templates.isEmpty
                    ? Center(
                      child: Text(
                        'No templates yet. Add one with the + button.',
                      ),
                    )
                    : ListView.builder(
                      itemCount: templates.length,
                      itemBuilder: (context, index) {
                        final template = templates[index];
                        return ListTile(
                          title: Text(template['title']),
                          subtitle: Text(template['address']),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            context.push(
                              '/generator/detail/${template['id']}',
                              extra: template,
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
