import 'package:dio/dio.dart';
import 'package:ecommerce_beta/config/config.dart';
import 'package:ecommerce_beta/domain/domain.dart';
import 'package:ecommerce_beta/infrastructure/infrastructure.dart';

class AuthDatasourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String phoneNumber, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      // on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      ;
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Chequear conexion a Internet');
      }
      //throw ConnectionTimeout();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(
      String email, String phoneNumber, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
