import 'package:equatable/equatable.dart';

enum ClientStatus { ativo, inativo, pendente }

class Client extends Equatable {
  final int? id;
  final String storeFrontName; 
  final String cnpj;
  final String companyName; 
  final String cep;
  final String street; 
  final String neighborhood; 
  final String city;
  final String state;
  final String number;
  final String? complement;
  final ClientStatus status;
  final String? phone;
  final String? email;
  final String? contactPerson; 
  final int? assignedUserId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Client({
    this.id,
    required this.storeFrontName,
    required this.cnpj,
    required this.companyName,
    required this.cep,
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.number,
    this.complement,
    this.status = ClientStatus.ativo,
    this.phone,
    this.email,
    this.contactPerson,
    this.assignedUserId,
    this.createdAt,
    this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as int?,
      storeFrontName: json['storeFrontName'] as String,
      cnpj: json['cnpj'] as String,
      companyName: json['companyName'] as String,
      cep: json['cep'] as String,
      street: json['street'] as String,
      neighborhood: json['neighborhood'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      number: json['number'] as String,
      complement: json['complement'] as String?,
      status: _statusFromString(json['status'] as String),
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      contactPerson: json['contactPerson'] as String?,
      assignedUserId: json['assignedUserId'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson({bool includeAutoFields = true}) {
    return {
      if (includeAutoFields && id != null) 'id': id,
      'storeFrontName': storeFrontName,
      'cnpj': cnpj,
      'companyName': companyName,
      'cep': cep,
      'street': street,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'number': number,
      if (complement != null) 'complement': complement,
      'status': _statusToString(status),
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (contactPerson != null) 'contactPerson': contactPerson,
      if (assignedUserId != null) 'assignedUserId': assignedUserId,
      if (includeAutoFields && createdAt != null)
        'createdAt': createdAt!.toIso8601String(),
      if (includeAutoFields && updatedAt != null)
        'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  static ClientStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'ativo':
        return ClientStatus.ativo;
      case 'inativo':
        return ClientStatus.inativo;
      case 'pendente':
        return ClientStatus.pendente;
      default:
        return ClientStatus.ativo;
    }
  }

  static String _statusToString(ClientStatus status) {
    switch (status) {
      case ClientStatus.ativo:
        return 'Ativo';
      case ClientStatus.inativo:
        return 'Inativo';
      case ClientStatus.pendente:
        return 'Pendente';
    }
  }

  Client copyWith({
    int? id,
    String? storeFrontName,
    String? cnpj,
    String? companyName,
    String? cep,
    String? street,
    String? neighborhood,
    String? city,
    String? state,
    String? number,
    String? complement,
    ClientStatus? status,
    String? phone,
    String? email,
    String? contactPerson,
    int? assignedUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Client(
      id: id ?? this.id,
      storeFrontName: storeFrontName ?? this.storeFrontName,
      cnpj: cnpj ?? this.cnpj,
      companyName: companyName ?? this.companyName,
      cep: cep ?? this.cep,
      street: street ?? this.street,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      state: state ?? this.state,
      number: number ?? this.number,
      complement: complement ?? this.complement,
      status: status ?? this.status,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      contactPerson: contactPerson ?? this.contactPerson,
      assignedUserId: assignedUserId ?? this.assignedUserId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get statusText => _statusToString(status);

  @override
  List<Object?> get props => [
    id,
    storeFrontName,
    cnpj,
    companyName,
    cep,
    street,
    neighborhood,
    city,
    state,
    number,
    complement,
    status,
    phone,
    email,
    contactPerson,
    assignedUserId,
    createdAt,
    updatedAt,
  ];
}
