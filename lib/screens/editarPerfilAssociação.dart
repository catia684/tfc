import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tinder_para_caes/firebaseLogic/authenticationService.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import 'package:tinder_para_caes/screens/editarFuncionalidades.dart';
import '../theme/theme.dart';
import 'package:tinder_para_caes/screens/associacaoHomeScreen.dart';

class EditarPerfilAssociacao extends StatefulWidget {
  const EditarPerfilAssociacao({super.key});

  @override
  _EditarPerfilAssociacaoState createState() => _EditarPerfilAssociacaoState();
}

class _EditarPerfilAssociacaoState extends State<EditarPerfilAssociacao> {
  bool shareLocation = false;
  final Authenticationservice authService = Authenticationservice();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController email1Controller = TextEditingController();
  final TextEditingController email2Controller = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController telefone1Controller = TextEditingController();
  final TextEditingController telefone2Controller = TextEditingController();
  final TextEditingController moradaController = TextEditingController();
  final TextEditingController distritoController = TextEditingController();
  final TextEditingController localidadeController = TextEditingController();
  final TextEditingController necessidadesController = TextEditingController();
  final TextEditingController ibanController = TextEditingController();


  void atualizar() async {
    final associacaoProvider = Provider.of<AssociacaoProvider>(context, listen: false);
    final associacao = associacaoProvider.association;

    if (associacao == null) return;

    final Map<String, dynamic> dadosAtualizados = {};

    if (nomeController.text.isNotEmpty) {
      dadosAtualizados['nome'] = nomeController.text;
    }
    if (email1Controller.text.trim().isNotEmpty) {
      dadosAtualizados['email1'] = email1Controller.text.trim();
    }
    if (email2Controller.text.trim().isNotEmpty) {
      dadosAtualizados['email2'] = email2Controller.text.trim();
    }
    if (telefone1Controller.text.trim().isNotEmpty) {
      dadosAtualizados['telemovel1'] = telefone1Controller.text.trim();
    }
    if (telefone2Controller.text.trim().isNotEmpty) {
      dadosAtualizados['telemovel2'] = telefone2Controller.text.trim();
    }
    if (distritoController.text.trim().isNotEmpty) {
      dadosAtualizados['distrito'] = distritoController.text.trim();
    }
    if (localidadeController.text.isNotEmpty) {
      dadosAtualizados['localidade'] = localidadeController.text;
    }
    if (necessidadesController.text.isNotEmpty) {
      dadosAtualizados['necessidades'] = necessidadesController.text;
    }
    if (ibanController.text.isNotEmpty) {
      dadosAtualizados['iban'] = ibanController.text;
    }
    if (shareLocation) {
      dadosAtualizados['partilharLocalizacao'] = true;
      if (moradaController.text.trim().isNotEmpty) {
        dadosAtualizados['morada'] = moradaController.text.trim();
      }
    } else {
      dadosAtualizados['partilharLocalizacao'] = false;
      dadosAtualizados['morada'] = ""; // limpa se o utilizador desativar
    }

    // Atualizar palavra-passe se for válida e coincidir
    if (passwordController.text.trim().isNotEmpty &&
        passwordController.text == confirmPasswordController.text) {
      await authService.atualizarPassword(passwordController.text.trim());
    }

    // Atualizar o email se for diferente do atual
    if (email1Controller.text.trim().isNotEmpty &&
        email1Controller.text.trim() != associacao.generalEmail) {
      await authService.atualizarEmail(email1Controller.text.trim());
      dadosAtualizados['email1'] = email1Controller.text.trim();
    }

    await FirebaseFirestore.instance
        .collection('associacao')
        .doc(associacao.uid)
        .update(dadosAtualizados);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );

    // Atualizar o provider local
    await associacaoProvider.recarregarAssociacao();

  }


  List<String> distritos = [];

  @override
  void initState() {
    super.initState();
    _initializeDistritos();
  }

  static Future<List<String>> loadDistritos() async {
    final String response = await rootBundle.loadString('assets/distritos.txt');
    return response.split('\n').map((line) => line.trim()).toList();
  }

  Future<void> _initializeDistritos() async {
    try {
      final distritosLista = await loadDistritos();
      setState(() {
        distritos = distritosLista;
      });
    } catch (e) {
      print('Erro ao carregar os distritos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Obtém o tema

    return Scaffold(
      appBar: AppBar(title: const Text('Alteração dos seus dados')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Preencha apenas os campos em que pretende alterar os seus dados"),
            const SizedBox(height: 20),
            TextField(
              controller: necessidadesController,
              decoration: InputDecoration(labelText: 'Lista das necessidades da associação'),
              keyboardType: TextInputType.multiline,
              maxLines: null, // permite número ilimitado de linhas
              minLines: 3,    // número mínimo de linhas visíveis
              textInputAction: TextInputAction.newline, // insere nova linha ao carregar "Enter"
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Palavra-passe'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirmação da Palavra-passe'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: telefone1Controller,
              decoration: InputDecoration(labelText: 'Telemóvel 1'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: telefone2Controller,
              decoration: InputDecoration(labelText: 'Telemóvel 2'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: email1Controller,
              decoration: InputDecoration(labelText: 'Email 1'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: email2Controller,
              decoration: InputDecoration(labelText: 'Email 2'),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text('Partilhar localização?'),
              value: shareLocation,
              tileColor: Colors.transparent,
              onChanged: (bool? value) {
                setState(() {
                  shareLocation = value ?? false;
                });
              },
            ),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return distritos.where((String distrito) =>
                    distrito.toLowerCase().contains(textEditingValue.text.toLowerCase()));
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                distritoController.text = textEditingController.text;
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'Distrito'),
                );
              },
              onSelected: (String selection) {
                distritoController.text = selection;
              },
            ),

            if (shareLocation) ...[
              TextField(
                controller: moradaController,
                decoration: const InputDecoration(labelText: 'Morada'),
              ),
            ],
            const SizedBox(height: 10),
            TextField(
              controller: localidadeController,
              decoration: InputDecoration(labelText: 'Localidade'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ibanController,
              decoration: InputDecoration(labelText: 'IBAN para o qual recebem donativos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditarFuncionalidades()));
              },
              child: Text("Editar as suas Funcionalidades"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor),
              onPressed: (){
                atualizar();
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AssociacaoHomeScreen()));
              },

              child: const Text("Atualizar Perfil"),
            ),
          ],
        ),
      ),
    );
  }
}