import 'package:money_formatter/money_formatter.dart';
import 'package:pdf/widgets.dart';

class EstadoCuentaReport extends StatelessWidget {
  final List<List<dynamic>> tablaCargosAbonos;
  final String nombre;
  final double saldoTotal;
  final double saldoCargos;
  final double saldoAbonos;
  EstadoCuentaReport({
    this.tablaCargosAbonos = const [],
    this.nombre = "",
    this.saldoTotal = 0,
    this.saldoCargos = 0,
    this.saldoAbonos = 0,
  });

  @override
  Widget build(Context context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Estado de Cuenta',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              nombre,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
          ],
        ),SizedBox(height: 2,),
        TableHelper.fromTextArray(
          context: context,
          cellAlignment: Alignment.center,
          data: tablaCargosAbonos,
        ),
        SizedBox(height: 13,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Abono: ${MoneyFormatter(amount: saldoAbonos).output.symbolOnLeft}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Cargos: ${MoneyFormatter(amount: saldoCargos).output.symbolOnLeft}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
        SizedBox(height: 6,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Saldo: ${MoneyFormatter(amount: saldoTotal).output.symbolOnLeft}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ],
    );
  }
}