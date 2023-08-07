import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taximetro/services/auth.services.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del conductor.'),
      ),
      body: SingleChildScrollView(
        // Agrega SingleChildScrollView
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: _FormContent(),
          ),
        ),
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _carRegistrationController = TextEditingController();
  final _adminCodeController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<void> loadDataInputs() async {
    final preferences = await SharedPreferences.getInstance();
    final adminCode = preferences.getString('adminCode');
    if (adminCode != null) {
      _nameController.text = preferences.getString('name')!;
      _emailController.text = preferences.getString('email')!;
      _phoneController.text = preferences.getString('phone')!;
      _licensePlateController.text = preferences.getString('licensePlate')!;
      _carRegistrationController.text =
          preferences.getString('carRegistration')!;
      _adminCodeController.text = preferences.getString('adminCode')!;
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, perform registration logic here
      String name = _nameController.text;
      String email = _emailController.text;
      String phone = _phoneController.text;
      String licensePlate = _licensePlateController.text;
      String carRegistration = _carRegistrationController.text;
      String adminCode = _adminCodeController.text;

      AuthService.sendFormData(
              name: name,
              email: email,
              phone: phone,
              licensePlate: licensePlate,
              carRegistration: carRegistration,
              adminCode: adminCode)
          .then((success) {
        if (success) {
          // Datos enviados correctamente, muestra un mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sus datos han sido guardados.')),
          );
        } else {
          // Ocurrió un error al enviar los datos, muestra un mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al enviar los datos.')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor entre el nombre.';
                }

                bool emailValid = RegExp(r"^[a-zA-Z]+").hasMatch(value);
                if (!emailValid) {
                  return 'Entre un nombre válido.';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Entre su nombre',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _phoneController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor entre el teléfono.';
                }

                bool emailValid = RegExp(r"^[a-zA-Z0-9]+").hasMatch(value);
                if (!emailValid) {
                  return 'Por favor entre un número de teléfono válido';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                hintText: 'Entre el teléfono',
                prefixIcon: Icon(Icons.phone_android_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor entre el correo electrónico';
                }

                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return 'Por favor entre un correo electrónico válido';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                hintText: 'Entre el correo electrónico',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _licensePlateController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor entre el código de licencia.';
                }

                bool emailValid = RegExp(r"^[a-zA-Z0-9]+").hasMatch(value);
                if (!emailValid) {
                  return 'Por favor entre un código de licencia válido';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Código de licencia',
                hintText: 'Entre el código de licencia',
                prefixIcon: Icon(Icons.numbers_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _carRegistrationController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor entre la matrícula del auto';
                }

                bool emailValid = RegExp(r"^[a-zA-Z0-9]+").hasMatch(value);
                if (!emailValid) {
                  return 'Por favor entre una matrícula de auto válida';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Matrícula del auto',
                hintText: 'Entre la matrícula del auto',
                prefixIcon: Icon(Icons.numbers_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _adminCodeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor entre el código del controlador.';
                }

                bool emailValid = RegExp(r"^[a-zA-Z0-9]+").hasMatch(value);
                if (!emailValid) {
                  return 'Por favor entre un código del controlador válido';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Código del controlador',
                hintText: 'Entre el código del controlador',
                prefixIcon: Icon(Icons.numbers_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            /*  CheckboxListTile(
              value: _rememberMe,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _rememberMe = value;
                });
              },
              title: const Text('Remember me'),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: const EdgeInsets.all(0),
            ),
            _gap(),*/
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Guardar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  _submitForm();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
