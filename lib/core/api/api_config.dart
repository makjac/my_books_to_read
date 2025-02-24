mixin ApiConfig {
  // Base URL
  static const String baseUrl = 'https://openlibrary.org';

  // Endpoints
  String search(String query, {int offset = 0, int limit = 10}) {
    assert(query.isNotEmpty, 'Query must not be empty');
    assert(limit >= 1, 'Limit must be greater than or equal to 1');
    assert(offset >= 0, 'Offset must be greater than or equal to 0');

    return _buildUrl('/search.json', {
      'q': query,
      'limit': limit.toString(),
      'offset': offset.toString(),
    });
  }

  String trending({int page = 1, int limit = 10}) {
    assert(limit >= 1, 'Limit must be greater than or equal to 1');
    assert(page >= 1, 'Page must be greater than or equal to 1');

    return _buildUrl('/trending/daily.json', {
      'page': page.toString(),
      'limit': limit.toString(),
    });
  }

  String bookDetails(String id) => _buildUrl('/works/$id.json');

  // Helper method
  String _buildUrl(String path, [Map<String, dynamic>? params]) {
    final uri = Uri.parse('$baseUrl$path');

    if (params != null) {
      return uri.replace(queryParameters: params).toString();
    }
    return uri.toString();
  }
}
