

class User {
  final String id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final List<String>roles; // Posibles valores: COMERCIO - CLIENTE -ADMIN*
  final String token;

  User({
    required this.id,
    required this.email, 
    required this.fullName, 
    required this.phoneNumber, 
    required this.roles, 
    required this.token
    });

  bool get isAdmin{
    return roles.contains('ADMIN');    
  }

   bool get isCommerce{
    return roles.contains('COMERCIO');    
  }

   bool get isClient{
    return roles.contains('CLIENTE');    
  }
}