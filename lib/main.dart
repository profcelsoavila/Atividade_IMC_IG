import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//Lista com os itens do DropDownButton
List<String> ltsexo = <String>['Masculino', 'Feminino'];
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //definição das rotas
    final GoRouter _router = GoRouter(routes: [
      GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) => HomePage(),
          routes: [
            GoRoute(
                name: 'calc',
                path: 'calc/:altura/:peso/:idade/:sexo',
                builder: (context, state) => CalcPage(
                      altura: state.params["altura"]!,
                      peso: state.params["peso"]!,
                      idade: state.params["idade"]!,
                      sexo: state.params["sexo"]!,
                    )),
          ])
    ]);

    return (MaterialApp.router(
      theme: ThemeData(
        primaryColor: Colors.lightBlue[800],
        fontFamily: 'Georgia',
      ),
      routerConfig: _router,
      title: 'Cálculos Saudáveis',
    ));
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final txtAltura = TextEditingController();
  final txtpeso = TextEditingController();
  final txtidade = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cálculos Saudáveis')),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(
          Icons.accessibility_new_rounded,
          color: Colors.lightBlue,
          size: 180.0,
        ),
        Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: txtAltura,
                decoration: const InputDecoration(
                  labelText: 'Altura',
                  labelStyle: TextStyle(
                    color: Colors.lightBlue,
                  ),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.blue, fontSize: 12.0),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              )),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: txtpeso,
                decoration: const InputDecoration(
                  labelText: 'Peso',
                  labelStyle: TextStyle(
                    color: Colors.lightBlue,
                  ),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.blue, fontSize: 12.0),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              )),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: txtidade,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  labelStyle: TextStyle(
                    color: Colors.lightBlue,
                  ),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.blue, fontSize: 12.0),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('Sexo: '),
              DropDownSexo(),
            ],
          ),
          ElevatedButton(
              onPressed: () => context.goNamed(
                    "calc",
                    params: {
                      "altura": txtAltura.text,
                      "peso": txtpeso.text,
                      "idade": txtidade.text,
                      "sexo": _DropDownSexo().valor,
                    },
                  ),
              child: const Text('Calcular índices')),
        ])
      ]),
    );
  }
}

class DropDownSexo extends StatefulWidget {
  const DropDownSexo({super.key});

  @override
  State<DropDownSexo> createState() => _DropDownSexo();
}

class _DropDownSexo extends State<DropDownSexo> {
  String valor = ltsexo.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: valor,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.lightBlue),
      borderRadius: BorderRadius.circular(20.0),
      underline: Container(
        height: 2,
        color: Colors.lightBlue,
      ),
      onChanged: (String? value) {
        // Quando o usuário selecionar um item
        setState(() {
          valor = value!;
        });
      },
      items: ltsexo.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class CalcPage extends StatelessWidget {
  final String altura;
  final String peso;
  final String idade;
  final String sexo;

  const CalcPage(
      {super.key,
      required this.altura,
      required this.peso,
      required this.idade,
      required this.sexo});

  @override
  Widget build(BuildContext context) {
    double valorImc = _calculoIMC(altura, peso);
    String imcString = valorImc.toStringAsFixed(2);

    double valorIg = _calculoIG(altura, peso, idade, sexo);
    String igString = valorIg.toStringAsFixed(2);

    return Scaffold(
        appBar: AppBar(title: const Text('Resultados do Cálculo Saudável')),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  'IMC: $imcString',
                  style: const TextStyle(fontSize: 30.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Índice de Gordura: $igString',
                  style: const TextStyle(fontSize: 30.0),
                ),
              )
            ]));
  }

  double _calculoIMC(String altura, String peso) {
    // return ((double.parse(peso)) / (pow(double.parse(altura), 2));
    // double imc = (double.parse(peso)) / (pow(double.parse(altura), 2));
    return (double.parse(peso)) / (pow(double.parse(altura), 2));
  }

  double _calculoIG(String altura, String peso, String idade, String sexo) {
    double fator;
    double imc = _calculoIMC(altura, peso);
    if (sexo == 'Masculino') {
      fator = 1.0;
    } else {
      fator = 0.8;
    }
    return ((1.2 * imc) + (0.23 * int.parse(idade) - (10.8 * fator) - 5.4));
  }
}
