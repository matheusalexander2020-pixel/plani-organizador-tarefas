import 'package:material_ui/material_ui.dart';
import 'planner_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegister = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;

    final emailName = _emailController.text.trim().split('@').first;
    final displayName = _isRegister && _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : (emailName.isEmpty ? 'Pessoa usuária' : emailName);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PlannerScreen(userName: displayName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF5143D9), Color(0xFF7868FF), Color(0xFF35C8C2)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -65,
              right: -45,
              child: _GlowCircle(size: 210, color: const Color(0x55FFFFFF)),
            ),
            Positioned(
              bottom: -85,
              left: -55,
              child: _GlowCircle(size: 250, color: const Color(0x3354F0D4)),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isWide ? 460 : 460),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 76,
                          width: 76,
                          decoration: BoxDecoration(
                            color: Colors.white..withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 39,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'plani',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 38,
                            letterSpacing: -1.5,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Seu dia, do seu jeito.',
                          style: TextStyle(
                            color: Colors.white..withValues(alpha: 0.85),
                            fontSize: 15,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.fromLTRB(24, 26, 24, 22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x330F164A),
                                blurRadius: 32,
                                offset: Offset(0, 18),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isRegister ? 'Crie sua conta' : 'Boas-vindas!',
                                  style: const TextStyle(
                                    color: Color(0xFF24213B),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _isRegister
                                      ? 'Comece a organizar seus dias.'
                                      : 'Entre e tire seus planos do papel.',
                                  style: const TextStyle(
                                    color: Color(0xFF88869A),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 23),
                                if (_isRegister) ...[
                                  _fieldLabel('SEU NOME'),
                                  TextFormField(
                                    controller: _nameController,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      hintText: 'Como podemos te chamar?',
                                      prefixIcon: Icon(Icons.person_outline),
                                    ),
                                    validator: (value) {
                                      if (_isRegister && (value == null || value.trim().isEmpty)) {
                                        return 'Informe seu nome.';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                _fieldLabel('E-MAIL'),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    hintText: 'voce@email.com',
                                    prefixIcon: Icon(Icons.mail_outline_rounded),
                                  ),
                                  validator: (value) {
                                    if (value == null || !value.contains('@') || !value.contains('.')) {
                                      return 'Informe um e-mail válido.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                _fieldLabel('SENHA'),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _hidePassword,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _continue(),
                                  decoration: InputDecoration(
                                    hintText: 'Mínimo de 6 caracteres',
                                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(() => _hidePassword = !_hidePassword),
                                      icon: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.length < 6) {
                                      return 'A senha deve ter pelo menos 6 caracteres.';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 23),
                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: FilledButton(
                                    onPressed: _continue,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFF6253EA),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      _isRegister ? 'Criar conta' : 'Entrar',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: TextButton(
                                    onPressed: () => setState(() => _isRegister = !_isRegister),
                                    child: Text(
                                      _isRegister
                                          ? 'Já tem uma conta? Entrar'
                                          : 'Ainda não tem conta? Cadastre-se',
                                      style: const TextStyle(
                                        color: Color(0xFF6253EA),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Center(
                                  child: Text(
                                    'Modo demonstração • sem Firebase',
                                    style: TextStyle(
                                      color: Color(0xFFAAA8B7),
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF777489),
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
