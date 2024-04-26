

class ConnectionTimeout implements Exception{}
class InvalidToken implements Exception{}
class WrongCredentials implements Exception{}

class CustomError implements Exception{
  final String message;
  //final bool loggedRequired; // Este atributo nos permite pos si va a usar un logger de errores
  //final int errorCode;

   CustomError(this.message);
  //CustomError(this.message, [this.loggedRequired = false]);
  //CustomError(this.message, this.errorCode);
}

