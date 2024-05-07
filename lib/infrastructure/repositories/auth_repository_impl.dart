import 'package:ecommerce_beta/domain/domain.dart';
import '../infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository{
  
  final AuthDataSource dataSource;

  AuthRepositoryImpl(
   [AuthDataSource? dataSource]
  ): dataSource = dataSource ?? AuthDatasourceImpl();


  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String phoneNumber, String password) {
    return dataSource.login(email, phoneNumber, password);
  }

  @override
  Future<User> register(String email, String phoneNumber, String password, String fullName) {
     return dataSource.register(email, phoneNumber, password, fullName);
  }
  
  @override
  Future<User> simulatedLogin(String email, String password) {
      return dataSource.simulatedLogin(email, password);
     
  }  
  
}