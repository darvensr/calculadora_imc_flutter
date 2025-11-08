import 'package:flutter/material.dart';

void main() {
  runApp(const AppIMC());
}

class AppIMC extends StatelessWidget {
  const AppIMC({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Colors.blueAccent,
          secondary: Colors.lightBlueAccent,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
        ),
      ),
      home: const TelaIMC(),
    );
  }
}

class TelaIMC extends StatefulWidget {
  const TelaIMC({super.key});

  @override
  State<TelaIMC> createState() => _TelaIMCState();
}

class _TelaIMCState extends State<TelaIMC> {
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  double? _imc;
  String _classificacao = '';
  bool _isMale = true;

  void _calcularIMC() {
    final double? peso = double.tryParse(_pesoController.text);
    final double? alturaCm = double.tryParse(_alturaController.text);

    if (peso == null || alturaCm == null || alturaCm <= 0) {
      setState(() {
        _imc = null;
        _classificacao = 'Por favor, insira valores válidos.';
      });
      return;
    }

    final altura = alturaCm / 100; // converte cm para metros
    final imc = peso / (altura * altura);

    setState(() {
      _imc = double.parse(imc.toStringAsFixed(1));
      _classificacao = _definirClassificacao(imc);
    });
  }

  String _definirClassificacao(double imc) {
    if (imc < 18.5) return "Abaixo do peso";
    if (imc < 25) return "Peso normal";
    if (imc < 30) return "Sobrepeso";
    return "Obesidade";
  }

  void _resetar() {
    _pesoController.clear();
    _alturaController.clear();
    setState(() {
      _imc = null;
      _classificacao = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black87),
        title: const Text(
          'Seu corpo',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Calculadora de IMC',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 30),

              // Ícones de gênero
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cardGenero("Masculino", Icons.male, _isMale),
                  const SizedBox(width: 30),
                  _cardGenero("Feminino", Icons.female, !_isMale),
                ],
              ),
              const SizedBox(height: 40),

              // Campos de entrada
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _campoEntrada(
                    label: "Seu peso (kg)",
                    controller: _pesoController,
                  ),
                  _campoEntrada(
                    label: "Sua altura (cm)",
                    controller: _alturaController,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Botão de cálculo
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calcularIMC,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Calcular seu IMC",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Resultado
              if (_imc != null)
                Column(
                  children: [
                    const Text(
                      'Seu IMC',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_imc',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _classificacao,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _resetar,
                      child: const Text(
                        "Calcular novamente",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 30),

              // Categorias de IMC
              Container(
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Categorias de IMC",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text("Menos de 18.5  →  Abaixo do peso"),
                    Text("18.5 a 24.9    →  Peso normal"),
                    Text("25 a 29.9      →  Sobrepeso"),
                    Text("30 ou mais     →  Obesidade"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoEntrada({
    required String label,
    required TextEditingController controller,
  }) {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 16),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _cardGenero(String titulo, IconData icone, bool selecionado) {
    return GestureDetector(
      onTap: () => setState(() => _isMale = titulo == "Masculino"),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor:
                selecionado ? Colors.blueAccent : Colors.grey.shade300,
            child: Icon(icone, size: 45, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  selecionado ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
