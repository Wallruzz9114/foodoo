class HttpResult {
  HttpResult({required this.data, required this.status});

  final String data;
  final Status status;
}

enum Status { success, failure }
