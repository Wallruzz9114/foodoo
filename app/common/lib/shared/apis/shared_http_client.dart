import 'package:common/models/http_result.dart';
import 'package:common/shared/apis/i_http_client.dart';
import 'package:http/http.dart';

class SharedHttpClient implements IHttpClient {
  SharedHttpClient(this.client);

  final Client client;

  @override
  Future<HttpResult> get(
    String url,
    Map<String, String>? headers,
  ) async {
    final Uri uri = Uri.parse(url);
    final Response response = await client.get(uri, headers: headers);
    return HttpResult(data: response.body, status: _setStatus(response));
  }

  @override
  Future<HttpResult> post(
    String url,
    String body,
    Map<String, String>? headers,
  ) async {
    final Uri uri = Uri.parse(url);
    final Response response = await client.post(
      uri,
      body: body,
      headers: headers,
    );
    return HttpResult(data: response.body, status: _setStatus(response));
  }

  Status _setStatus(Response response) {
    if (response.statusCode != 200) {
      return Status.failure;
    }

    return Status.success;
  }
}
