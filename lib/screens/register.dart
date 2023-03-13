import 'package:brasil_fields/brasil_fields.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:http/http.dart' as htpp;

class Registrer extends StatefulWidget {
  Registrer({
    Key? key,
  }) : super(key: key);

  @override
  State<Registrer> createState() => _RegistrerState();
}

class _RegistrerState extends State<Registrer> {
  final nameControler = TextEditingController();
  final emailControler = TextEditingController();
  final foneControler = TextEditingController();
  final cpfControler = TextEditingController();
  final birthControler = TextEditingController();
  final sexoControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 90,
              width: 70,
              child: SvgPicture.asset('asset/svg/logo.svg'),
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: Text('Cadastrar Usuario'))
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'nome'),
              controller: nameControler,
            ),
            TextFormField(
                decoration: InputDecoration(labelText: 'email'),
                controller: emailControler),
            TextFormField(
                decoration: InputDecoration(labelText: 'telefone'),
                controller: foneControler),
            TextFormField(
              decoration: InputDecoration(labelText: 'cpf'),
              controller: cpfControler,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter()
              ],
              validator: (value) =>
                  Validator.cpf(value) ? ' CPF INVALIDO' : null,
            ),
            DateTimePicker(
              controller: birthControler,
              type: DateTimePickerType.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              dateLabelText: 'Nascimento',
              dateMask: 'yyyy-MM-dd',
              validator: (value) {
                if (value!.isEmpty) return 'Data Invalida';
                return null;
              },
            ),
            TextFormField(
                decoration: InputDecoration(labelText: 'sexo'),
                controller: sexoControler),
            SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                insertUser();
              },
              child: Text('Cadastrar'),
            )
          ],
        ),
      ),
    );
  }

  void updateUser({required int id}) async {
    var url = Uri.parse(
        'https://provisorio.sousmol.com.br/vagaflutter/crud-cliente/$id');
    var response = await htpp.put(url);
  }

  void insertUser() async {
    var url = Uri.parse(
        'https://provisorio.sousmol.com.br/vagaflutter/crud-cliente/');
    var response = await htpp.post(url);
    if (response.statusCode == 200) {
      await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User Cadastrado'),
          backgroundColor: Colors.greenAccent,
        ),
      );
      Navigator.pop(context);
    }
  }
}
