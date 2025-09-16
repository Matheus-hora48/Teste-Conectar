import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/main_app_bar_widget.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/users_controller.dart';
import '../../domain/models/user_model.dart';

class UserFormScreen extends StatefulWidget {
  final int? userId;

  const UserFormScreen({super.key, this.userId});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final UsersController _controller = Get.find<UsersController>();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  UserRole _selectedRole = UserRole.user;
  bool _obscurePassword = true;
  bool _isLoading = false;

  bool get isEditing => widget.userId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadUser();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loadUser() async {
    if (widget.userId == null) return;

    setState(() => _isLoading = true);

    try {
      final user = await _controller.getUserById(widget.userId!);
      _nameController.text = user.name;
      _emailController.text = user.email;
      _selectedRole = user.role;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao carregar usuário: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (isEditing) {
        await _controller.updateUserWithParams(
          id: widget.userId!,
          name: _nameController.text,
          email: _emailController.text,
          role: _selectedRole,
        );

        Get.snackbar(
          'Sucesso',
          'Usuário atualizado com sucesso!',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        await _controller.createUserWithParams(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          role: _selectedRole,
        );

        Get.snackbar(
          'Sucesso',
          'Usuário criado com sucesso!',
          snackPosition: SnackPosition.TOP,
        );
      }

      Get.offAllNamed('/users');
    } catch (e) {
      Get.snackbar(
        'Erro',
        isEditing
            ? 'Erro ao atualizar usuário: $e'
            : 'Erro ao criar usuário: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const MainAppBarWidget(currentTab: 'usuarios'),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Get.back(),
                                icon: const Icon(Icons.arrow_back),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                isEditing ? 'Editar Usuário' : 'Novo Usuário',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          const Text(
                            'Informações Básicas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _nameController,
                            label: 'Nome completo',
                            hintText: 'Digite o nome completo',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nome é obrigatório';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _emailController,
                            label: 'Email',
                            hintText: 'Digite o email',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email é obrigatório';
                              }
                              if (!GetUtils.isEmail(value)) {
                                return 'Email inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          if (!isEditing) ...[
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                hintText: 'Digite a senha',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Senha é obrigatória';
                                }
                                if (value.length < 6) {
                                  return 'Senha deve ter pelo menos 6 caracteres';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],

                          DropdownButtonFormField<UserRole>(
                            value: _selectedRole,
                            decoration: const InputDecoration(
                              labelText: 'Perfil',
                              border: OutlineInputBorder(),
                            ),
                            items: UserRole.values.map((role) {
                              return DropdownMenuItem(
                                value: role,
                                child: Text(
                                  role == UserRole.admin
                                      ? 'Administrador'
                                      : 'Usuário',
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedRole = value;
                                });
                              }
                            },
                          ),

                          const SizedBox(height: 32),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Cancelar'),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _saveUser,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(isEditing ? 'Atualizar' : 'Criar'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
