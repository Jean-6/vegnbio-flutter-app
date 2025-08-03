enum ERole{
  CUSTOMER,
  RESTORER,
  SUPPLIER,
  ADMIN;

  // Convert String to ERole
  static ERole fromString(String value)=>
      ERole.values.firstWhere((e) => e.name == value);
}