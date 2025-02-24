class ApiConfig {
  // Base URL
  static const String baseUrl = 'https://openlibrary.org';

  // Endpoints
  static String search(String query, {int? limit, int? offset}) =>
      _buildUrl('/search.json', {'q': query, 'limit': limit, 'offset': offset});

  static String trending({int? limit, int? offset}) =>
      _buildUrl('/trending/daily.json', {'limit': limit, 'offset': offset});

  static String workDetails(String id) => _buildUrl('/works/$id.json');

  // Helper method
  static String _buildUrl(String path, [Map<String, dynamic>? params]) {
    final uri = Uri.parse('$baseUrl$path');

    if (params != null) {
      return uri.replace(queryParameters: _cleanParams(params)).toString();
    }
    return uri.toString();
  }

  static Map<String, dynamic> _cleanParams(Map<String, dynamic> params) {
    return params..removeWhere((key, value) => value == null);
  }
}
