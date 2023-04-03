import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const MyApp());

const imcCalcRoute = 'imc-calc';
RegExp decimalRegex = RegExp(r'^\d+\.?\d{0,2}');

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          name: imcCalcRoute,
          path: '$imcCalcRoute/:weight/:height/:age/:sex',
          builder: (BuildContext context, GoRouterState state) => ImcCalcScreen(
            weight: double.parse(state.params['weight']!),
            height: double.parse(state.params['height']!),
            age: int.parse(state.params['age']!),
            sex: double.parse(state.params['sex']!),
          ),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _gender = 1.0;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Altura (cm)',
              ),
            ),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(decimalRegex)
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Peso (kg)',
              ),
            ),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Idade',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: 1.0,
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = 1.0;
                    });
                  },
                ),
                const Text('Homem'),
                Radio(
                  value: 0.8,
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = 0.8;
                    });
                  },
                ),
                const Text('Mulher'),
              ],
            ),
            ElevatedButton(
              onPressed: () => context.goNamed(imcCalcRoute, params: {
                "weight": _weightController.text,
                "height": _heightController.text,
                "age": _ageController.text,
                "sex": _gender.toString(),
              }),
              child: const Text('Calcular IMC e IGC'),
            ),
          ],
        ),
      ),
    );
  }
}

class ImcCalcScreen extends StatelessWidget {
  double weight;
  double height;
  double sex;
  int age;
  double imc = 0;
  double igc = 0;
  ImcCalcScreen({
    super.key,
    required this.weight,
    required this.height,
    required this.age,
    required this.sex,
  });

  @override
  Widget build(BuildContext context) {
    imc = _calculateImc();
    igc = _calculateIgc();
    return Scaffold(
      appBar: AppBar(title: const Text('Imc calc Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("IMC: ${imc.toStringAsFixed(2)}kg/m2"),
            Text("IGC: ${igc.toStringAsFixed(2)}"),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('VOLTAR'),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateImc() {
    return weight / ((height / 100) * (height / 100));
  }

  double _calculateIgc() {
    return (1.2 * imc) + (0.23 * age) - (10.8 * sex) - 5.4;
  }
}
