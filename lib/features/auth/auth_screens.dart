import 'package:flutter/material.dart';
import 'package:dorama_nest/core/locale_text.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/core/widgets/nest_widgets.dart';
import 'package:dorama_nest/core/validators.dart';
import 'package:dorama_nest/state/app_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool obscure = true;
  bool busy = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    setState(() => busy = true);
    final stored = AppScope.of(context).nickname;
    await AppScope.of(context)
        .signIn(stored.isEmpty ? email.text.trim().split('@').first : stored);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: NestBackBar(title: tx(context, 'Вход')),
      body: SingleChildScrollView(
          child: Padding(
              padding: pagePadding,
              child: Form(
                  key: form,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 43),
                        Container(
                            width: 61,
                            height: 61,
                            decoration: BoxDecoration(
                                color: context.nestSoftBlue,
                                borderRadius: BorderRadius.circular(18)),
                            child: const Icon(Icons.favorite_border_rounded,
                                size: 35, color: NestColors.blue)),
                        const SizedBox(height: 26),
                        Text(tx(context, 'Рады видеть\nтебя снова!'),
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 10),
                        Text(
                            tx(context,
                                'Войди, чтобы сохранить свои любимые истории.'),
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 35),
                        NestField(
                            label: tx(context, 'Email'),
                            hint: 'hello@example.com',
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => _localizedEmail(context, v)),
                        const SizedBox(height: 19),
                        NestField(
                            label: tx(context, 'Пароль'),
                            hint: tx(context, 'Не менее 6 символов'),
                            controller: password,
                            obscure: obscure,
                            validator: (v) => _localizedPassword(context, v),
                            suffix: IconButton(
                                icon: Icon(
                                    obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: NestColors.blue,
                                    size: 20),
                                onPressed: () =>
                                    setState(() => obscure = !obscure))),
                        const SizedBox(height: 14),
                        Text(tx(context, 'Введите email и пароль'),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 10)),
                        const SizedBox(height: 24),
                        NestButton(
                            label: tx(context, busy ? 'Входим…' : 'Войти →'),
                            onPressed: busy ? null : submit),
                        const SizedBox(height: 17),
                        Center(
                            child: Text(tx(context, 'или'),
                                style: Theme.of(context).textTheme.bodySmall)),
                        const SizedBox(height: 17),
                        NestButton(
                            label: tx(context, 'Создать аккаунт'),
                            secondary: true,
                            onPressed: () =>
                                Navigator.pushNamed(context, '/register')),
                        const SizedBox(height: 20),
                        const SizedBox(height: 30),
                      ])))));
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool accepted = false;
  bool obscure = true;
  bool busy = false;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    if (!accepted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              tx(context, 'Примите правила приложения, чтобы продолжить'))));
      return;
    }
    setState(() => busy = true);
    await AppScope.of(context).signIn(name.text);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: NestBackBar(title: tx(context, 'Регистрация')),
      body: SingleChildScrollView(
          child: Padding(
              padding: pagePadding,
              child: Form(
                  key: form,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(tx(context, 'Начнём нашу\nисторию? ✨'),
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 8),
                        Text(
                            tx(context,
                                'Создай маленький уголок для любимых дорам.'),
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 29),
                        NestField(
                            label: tx(context, 'Имя или никнейм'),
                            hint: tx(context, 'Например, dorama.mia'),
                            controller: name,
                            validator: (v) =>
                                _localizedRequired(context, v, field: 'Имя')),
                        const SizedBox(height: 19),
                        NestField(
                            label: tx(context, 'Email'),
                            hint: 'you@example.com',
                            controller: email,
                            validator: (v) => _localizedEmail(context, v),
                            keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 19),
                        NestField(
                            label: tx(context, 'Пароль'),
                            hint: tx(context, 'Не менее 6 символов'),
                            controller: password,
                            validator: (v) => _localizedPassword(context, v),
                            obscure: obscure,
                            suffix: IconButton(
                                onPressed: () =>
                                    setState(() => obscure = !obscure),
                                icon: Icon(
                                    obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 19))),
                        const SizedBox(height: 25),
                        CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            value: accepted,
                            activeColor: NestColors.blue,
                            title: Text(
                                tx(context, 'Согласна с правилами приложения'),
                                style: Theme.of(context).textTheme.bodySmall),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (v) =>
                                setState(() => accepted = v ?? false)),
                        const SizedBox(height: 25),
                        NestButton(
                            label: tx(context,
                                busy ? 'Создаём…' : 'Создать аккаунт →'),
                            onPressed: busy ? null : submit),
                        const SizedBox(height: 18),
                        Center(
                            child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                    tx(context, 'Уже есть аккаунт? Войти'),
                                    style: const TextStyle(
                                        color: NestColors.blue,
                                        fontWeight: FontWeight.w800)))),
                        const SizedBox(height: 35),
                      ])))));
}

String? _localizedEmail(BuildContext context, String? value) {
  final error = NestValidators.email(value);
  return error == null ? null : tx(context, error);
}

String? _localizedPassword(BuildContext context, String? value) {
  final error = NestValidators.password(value);
  return error == null ? null : tx(context, error);
}

String? _localizedRequired(BuildContext context, String? value,
    {required String field}) {
  final error = NestValidators.requiredText(value, name: field);
  return error == null ? null : tx(context, error);
}
