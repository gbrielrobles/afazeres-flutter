import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatefulWidget {
  const MeuApp({Key? key}) : super(key: key);

  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  final List<Tarefa> _tarefas = [];
  final TextEditingController controlador = TextEditingController();
  Tarefa? _tarefaSelecionada;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Afazeres'),
        ),
        body: ListView.builder(
          itemCount: _tarefas.length,
          itemBuilder: (context, index) {
            final item = _tarefas[index];
            return Container(
              color: index % 2 == 0 ? Colors.grey[300] : Colors.white,
              child: Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red),
                onDismissed: (direction) {
                  setState(() {
                    _tarefas.removeAt(index);
                  });
                },
                child: ListTile(
                  title: Text(item.descricao),
                  trailing: Checkbox(
                    value: item.status,
                    onChanged: (novoValor) {
                      setState(() {
                        item.status = novoValor ?? false;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _tarefaSelecionada = item;
                      controlador.text = item.descricao;
                    });
                  },
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controlador,
                    decoration: const InputDecoration(
                      hintText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (controlador.text.isEmpty) {
                      return;
                    }
                    if (_tarefaSelecionada != null) {
                      setState(() {
                        _tarefaSelecionada!.descricao = controlador.text;
                        _tarefaSelecionada = null;
                        controlador.clear();
                      });
                    } else {
                      setState(() {
                        _tarefas.add(
                          Tarefa(
                            descricao: controlador.text,
                            status: false,
                          ),
                        );
                        controlador.clear();
                      });
                    }
                  },
                  child: Text(_tarefaSelecionada != null ? 'Salvar' : 'Adicionar Tarefa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Tarefa {
  String descricao;
  bool status;

  Tarefa({required this.descricao, required this.status});
}
