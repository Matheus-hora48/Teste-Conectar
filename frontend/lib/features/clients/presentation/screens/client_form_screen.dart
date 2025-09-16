import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/utils/validators.dart';
import 'package:frontend/core/widgets/custom_text_field.dart';
import 'package:frontend/features/clients/domain/models/client.dart';
import 'package:get/get.dart';
import '../controllers/clients_controller.dart';
import '../widgets/client_form_appbar_widget.dart';

class ClientFormScreen extends StatefulWidget {
  final int? clientId;

  const ClientFormScreen({super.key, this.clientId});

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final ClientsController _controller = Get.find<ClientsController>();

  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _razaoSocialController = TextEditingController();
  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _complementoController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactPersonController = TextEditingController();

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _isEditMode = widget.clientId != null;

    if (_isEditMode) {
      _loadClientData();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nomeController.dispose();
    _cnpjController.dispose();
    _razaoSocialController.dispose();
    _cepController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _complementoController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _contactPersonController.dispose();
    super.dispose();
  }

  Future<void> _loadClientData() async {
    try {
      await _controller.loadClientById(widget.clientId!);

      final client = _controller.selectedClient;

      if (mounted && client != null) {
        _nomeController.text = client.storeFrontName;
        _cnpjController.text = client.cnpj;
        _razaoSocialController.text = client.companyName;
        _cepController.text = client.cep;
        _ruaController.text = client.street;
        _numeroController.text = client.number;
        _bairroController.text = client.neighborhood;
        _cidadeController.text = client.city;
        _estadoController.text = client.state;
        _complementoController.text = client.complement ?? '';
        _phoneController.text = client.phone ?? '';
        _emailController.text = client.email ?? '';
        _contactPersonController.text = client.contactPerson ?? '';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveClient() async {
    if (_formKey.currentState!.validate()) {
      _controller.isLoadingForm = true;

      try {
        final client = Client(
          id: _isEditMode ? widget.clientId! : 0,
          storeFrontName: _nomeController.text,
          cnpj: _cnpjController.text,
          companyName: _razaoSocialController.text,
          cep: _cepController.text,
          street: _ruaController.text,
          number: _numeroController.text,
          neighborhood: _bairroController.text,
          city: _cidadeController.text,
          state: _estadoController.text,
          complement: _complementoController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          contactPerson: _contactPersonController.text,
          status: ClientStatus.ativo,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        bool success = false;
        if (_isEditMode) {
          success = await _controller.updateClient(client);
        } else {
          success = await _controller.createClient(client);
        }

        if (mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEditMode
                    ? 'Cliente atualizado com sucesso!'
                    : 'Cliente criado com sucesso!',
              ),
              backgroundColor: AppColors.primaryColor,
            ),
          );

          Navigator.of(context).pop();
        } else if (mounted && !success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao salvar cliente'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        _controller.isLoadingForm = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: ClientFormAppBarWidget(
        title: _isEditMode ? 'Editar Cliente' : 'Novo Cliente',
        tabController: _tabController,
        onSave: _saveClient,
        isLoading: _controller.isLoadingForm,
      ),
      body: Container(
        color: Colors.white,
        child: Obx(
          () => _controller.isLoadingForm
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDadosCadastraisTab(),

                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Informações Internas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Esta seção está em desenvolvimento',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Usuários Atribuídos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Esta seção está em desenvolvimento',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
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
    );
  }

  Widget _buildDadosCadastraisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Dados da Empresa',
              children: [
                CustomTextField(
                  controller: _nomeController,
                  label: 'Nome Fachada *',
                  hintText: 'Digite o nome fantasia da empresa',
                  validator: (value) => Validators.customRequired(
                    value,
                    'Nome fantasia obrigatório',
                  ),
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: _cnpjController,
                  hintText: '00.000.000/0000-00',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      String text = newValue.text;
                      if (text.length >= 2) {
                        text = '${text.substring(0, 2)}.${text.substring(2)}';
                      }
                      if (text.length >= 6) {
                        text = '${text.substring(0, 6)}.${text.substring(6)}';
                      }
                      if (text.length >= 10) {
                        text = '${text.substring(0, 10)}/${text.substring(10)}';
                      }
                      if (text.length >= 15) {
                        text = '${text.substring(0, 15)}-${text.substring(15)}';
                      }
                      return TextEditingValue(
                        text: text,
                        selection: TextSelection.collapsed(offset: text.length),
                      );
                    }),
                  ],
                  validator: (value) => Validators.cnpj(value),
                  label: 'CNPJ *',
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: _razaoSocialController,
                  label: 'Razão Social *',
                  hintText: 'Digite a razão social completa',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Razão social é obrigatória';
                    }
                    return null;
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSection(
              title: 'Endereço',
              children: [
                CustomTextField(
                  controller: _cepController,
                  label: 'CEP *',
                  hintText: '12345-678',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      String text = newValue.text;
                      if (text.length >= 5) {
                        text = '${text.substring(0, 5)}-${text.substring(5)}';
                      }
                      return TextEditingValue(
                        text: text,
                        selection: TextSelection.collapsed(offset: text.length),
                      );
                    }),
                  ],
                  validator: (value) => Validators.cep(value),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CustomTextField(
                        controller: _ruaController,
                        label: 'Rua *',
                        hintText: 'Digite o nome da rua',
                        validator: (value) => Validators.customRequired(
                          value,
                          'Rua é obrigatória',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: CustomTextField(
                        controller: _numeroController,
                        label: 'Nº *',
                        hintText: '123',
                        keyboardType: TextInputType.number,
                        validator: (value) => Validators.customRequired(
                          value,
                          'Número é obrigatório',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _bairroController,
                        label: 'Bairro *',
                        hintText: 'Digite o bairro',
                        validator: (value) => Validators.customRequired(
                          value,
                          'Bairro é obrigatório',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        controller: _cidadeController,
                        label: 'Cidade *',
                        hintText: 'Digite a cidade',
                        validator: (value) => Validators.customRequired(
                          value,
                          'Cidade é obrigatória',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomTextField(
                        controller: _estadoController,
                        label: 'Estado *',
                        hintText: 'UF',
                        maxLength: 2,
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) => Validators.customRequired(
                          value,
                          'Estado é obrigatório',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: CustomTextField(
                        controller: _complementoController,
                        label: 'Complemento',
                        hintText: 'Apartamento, sala, etc. (opcional)',
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSection(
              title: 'Informações de Contato',
              children: [
                CustomTextField(
                  controller: _phoneController,
                  label: 'Telefone',
                  hintText: '(11) 99999-9999',
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'contato@empresa.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => Validators.email(value),
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: _contactPersonController,
                  label: 'Pessoa de Contato',
                  hintText: 'Nome do responsável',
                ),
              ],
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  onPressed: _controller.isLoadingForm ? null : _saveClient,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: _controller.isLoadingForm
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          _isEditMode ? 'Atualizar Cliente' : 'Salvar Cliente',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}
