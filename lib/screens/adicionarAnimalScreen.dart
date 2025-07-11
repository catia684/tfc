import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import 'package:tinder_para_caes/firebaseLogic/utilizadorProvider.dart';
import 'package:tinder_para_caes/models/utilizador.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AdicionarAnimalScreen extends StatefulWidget {
  const AdicionarAnimalScreen({super.key});

  @override
  _AdicionarAnimalScreenState createState() => _AdicionarAnimalScreenState();
}

class _AdicionarAnimalScreenState extends State<AdicionarAnimalScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _chipController = TextEditingController();
  TextEditingController _dataNascimentoController = TextEditingController();
  final TextEditingController _donoLegalController = TextEditingController();
  final TextEditingController _alergiasController = TextEditingController();
  final TextEditingController _comportamentoController = TextEditingController();
  final TextEditingController _racaController = TextEditingController();

  String? _genero;
  bool _castrado = false;
  String? _porte;
  String? _especie;
  bool _temPadrinho = false;
  bool _temFat = false;
  bool _visivel = true;
  DateTime? _dataNascimento;


  List<String> racas = [];
  List<String> _racasFiltradas = [];



  @override
  void initState() {
    super.initState();
    _initializeDogBreeds();
  }

  Future<void> _initializeDogBreeds() async {
    try {
      final dogBreeds = await Animal.loadDogBreeds();
      setState(() {
        racas = dogBreeds;
      });
    } catch (e) {
      print('Erro ao carregar os distritos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Animal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: "Nome do Animal",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _chipController,
                  decoration: InputDecoration(
                    labelText: "Micro-chip (opcional)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _dataNascimentoController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Data de Nascimento",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? dataEscolhida = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );

                    if (dataEscolhida != null) {
                      setState(() {
                        _dataNascimento = dataEscolhida; // ✅ Guarda a data como DateTime
                        _dataNascimentoController.text =
                        '${dataEscolhida.day.toString().padLeft(2, '0')}/'
                            '${dataEscolhida.month.toString().padLeft(2, '0')}/'
                            '${dataEscolhida.year}';
                      });
                    }
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Gênero",
                    border: OutlineInputBorder(),
                  ),
                  value: _genero,
                  items: ["Feminino", "Masculino"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _genero = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _castrado,
                      onChanged: (bool? value) {
                        setState(() {
                          _castrado = value ?? false;
                        });
                      },
                    ),
                    Text("Castrado/Esterilizado"),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _donoLegalController,
                  decoration: InputDecoration(
                    labelText: "Dono Legal (opcional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _alergiasController,
                  decoration: InputDecoration(
                    labelText: "Alergias ou problemas de saúde (opcional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Porte",
                    border: OutlineInputBorder(),
                  ),
                  value: _porte,
                  items: ["Pequeno", "Médio", "Grande", "Gigante"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _porte = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _comportamentoController,
                  decoration: InputDecoration(
                    labelText: "Comportamento",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Espécie",
                    border: OutlineInputBorder(),
                  ),
                  value: _especie,
                  items: [
                    "Cão",
                    "Gato",
                    "Aves",
                    "Chinchilas",
                    "Porquinhos da Índia",
                    "Cavalos",
                    "Ovelhas",
                    "Hamsters"
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _especie = value;
                      _racaController.clear();
                      _racasFiltradas.clear();
                    });
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _racaController,
                  decoration: InputDecoration(
                    labelText: "Raça",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _racasFiltradas = racas
                          .where((raca) => raca.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
                if (_racasFiltradas.isNotEmpty)
                  Container(
                    constraints: BoxConstraints(maxHeight: 150),
                    child: ListView.builder(
                      itemCount: _racasFiltradas.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_racasFiltradas[index]),
                          onTap: () {
                            setState(() {
                              _racaController.text = _racasFiltradas[index];
                              _racasFiltradas = [];
                            });
                          },
                        );
                      },
                    ),
                  ),
                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: guardarAnimal,
                  child: Text("Registar animal"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _todosCamposObrigatoriosPreenchidos() {
    return _nomeController.text.trim().isNotEmpty &&
        _dataNascimento != null &&
        _genero != null &&
        _porte != null &&
        _comportamentoController.text.trim().isNotEmpty &&
        _especie != null &&
        _racaController.text.trim().isNotEmpty;
  }


  void guardarAnimal() async {
    if (!_todosCamposObrigatoriosPreenchidos()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor preencha todos os campos obrigatórios!")),
      );
      return;
    }

    final associacao = Provider.of<AssociacaoProvider>(context, listen: false).association;
    final utilizador = Provider.of<UtilizadorProvider>(context, listen: false).user;

    String donoID;
    bool isAssociacao = false;

    if (associacao != null) {
      donoID = associacao.uid;
      isAssociacao = true;
    } else if (utilizador != null) {
      donoID = utilizador.uid;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: Nenhum dono identificado!")),
      );
      return;
    }

    CollectionReference animaisRef = FirebaseFirestore.instance.collection('animal');
    CollectionReference usersRef = FirebaseFirestore.instance.collection('utilizador');
    CollectionReference associacoesRef = FirebaseFirestore.instance.collection('associacao');

    try {
      // Gerar UID manualmente
      String novoId = animaisRef.doc().id;

      // Criar o documento com UID definido
      await animaisRef.doc(novoId).set({
        'uid': novoId,
        'nome': _nomeController.text.trim(),
        'chip': _chipController.text.isNotEmpty ? int.tryParse(_chipController.text) : null,
        'dataNascimento': _dataNascimento != null ? Timestamp.fromDate(_dataNascimento!) : null,
        'genero': _genero,
        'castrado': _castrado,
        'donoLegal': _donoLegalController.text.trim().isNotEmpty ? _donoLegalController.text.trim() : null,
        'alergias': _alergiasController.text.trim().isNotEmpty ? _alergiasController.text.trim() : null,
        'porte': _porte,
        'comportamento': _comportamentoController.text.trim(),
        'especie': _especie,
        'raca': _racaController.text.trim(),
        'temPadrinho': _temPadrinho,
        'temFat': _temFat,
        'numeroDePasseiosDados': 0,
        'reviews': [],
        'donoID': donoID,
        'criado_em': Timestamp.now(),
        'imagens': [],
        'visivel': _visivel,
      });

      // Atualizar a lista de animais do dono
      if (isAssociacao) {
        await associacoesRef.doc(donoID).update({
          'animais': FieldValue.arrayUnion([novoId])
        });
      } else {
        await usersRef.doc(donoID).update({
          'osSeusAnimais': FieldValue.arrayUnion([novoId])
        });
      }

      //se for utilizador campos a true
      if (!isAssociacao) {
        _temPadrinho = true;
        _temFat = true;
      }

      await mostrarPopupAdicionarFotos(novoId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Animal adicionado com sucesso!")),
      );

      //atualizar os dados dos providers
      await Provider.of<UtilizadorProvider>(context, listen: false).recarregarUtilizador();
      await Provider.of<AssociacaoProvider>(context, listen: false).recarregarAssociacao();


      Navigator.pop(context, true);
    } catch (e) {
      print("Erro ao guardar no Firestore: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao adicionar animal!")),
      );
    }
  }


  Future<void> mostrarPopupAdicionarFotos(String animalId) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Deseja adicionar fotos ao animal agora?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context); // fecha o popup
                    await selecionarEGuardarFotos(animalId);
                  },
                  icon: Icon(Icons.photo),
                  label: Text('Adicionar fotos agora'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // fecha o popup
                  },
                  child: Text('Mais tarde'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> selecionarEGuardarFotos(String animalId) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(); // permite selecionar várias imagens

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      List<String> downloadUrls = [];

      for (var pickedFile in pickedFiles) {
        File imageFile = File(pickedFile.path);
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('animais/$animalId/$fileName.jpg');

        await storageRef.putFile(imageFile);
        String url = await storageRef.getDownloadURL();
        downloadUrls.add(url);
      }

      // Atualizar Firestore com os URLs das imagens
      await FirebaseFirestore.instance
          .collection('animal')
          .doc(animalId)
          .update({
        'imagens': FieldValue.arrayUnion(downloadUrls),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fotos adicionadas com sucesso!")),
      );
    }
  }

}