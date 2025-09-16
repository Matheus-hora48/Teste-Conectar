class Validators {
  /// Email validation
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-mail é obrigatório';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'E-mail inválido';
    }

    return null;
  }

  /// Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }

    return null;
  }

  /// Required field validation
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  /// CNPJ validation
  static String? cnpj(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNPJ é obrigatório';
    }

    String cnpj = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cnpj.length != 14) {
      return 'CNPJ deve ter 14 dígitos';
    }

    return null;
  }

  /// CEP validation
  static String? cep(String? value) {
    if (value == null || value.isEmpty) {
      return 'CEP é obrigatório';
    }

    String cep = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cep.length != 8) {
      return 'CEP deve ter 8 dígitos';
    }

    return null;
  }

  /// Phone validation
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }

    String phone = value.replaceAll(RegExp(r'[^\d]'), '');

    if (phone.length < 10 || phone.length > 11) {
      return 'Telefone inválido';
    }

    return null;
  }

  /// Name validation
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }

    if (value.trim().length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }

    return null;
  }

  /// Custom field validation with custom message
  static String? customRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  /// Confirm password validation
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }

    if (value != password) {
      return 'Senhas não coincidem';
    }

    return null;
  }

  /// Numeric validation
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Este campo'} é obrigatório';
    }

    if (double.tryParse(value.replaceAll(',', '.')) == null) {
      return '${fieldName ?? 'Este campo'} deve ser um número válido';
    }

    return null;
  }
}
