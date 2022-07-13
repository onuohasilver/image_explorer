class CustomResponse implements Exception {
  final String? _message;
  final bool isSuccess;

  CustomResponse(this.isSuccess, [this._message = "Success"]);
  String get message => _message!.replaceAll('Exception: ', '');

  @override
  String toString() {
    return message.toString().replaceAll('Exception:', '');
  }
}

class Success extends CustomResponse {
  Success() : super(true);
}

class Failure extends CustomResponse {
  Failure(String message) : super(false, message);
}
