# My Books To Read

![header][header_image_url]

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Flutter Firebase CI/CD][ci_badge]][ci_badge_link]

A Flutter application for managing your reading list. Search for books, save them to your reading list, and keep track of what you want to read next.

## Features

- Search books using Open Library API
- Browse trending books
- Save books to your reading list
- Authentication support
- Cross-platform support (iOS, Android)
- Material Design UI
- Infinite scrolling for book lists

## Installation

1. **Clone the repository:**

    ```sh
    git clone https://github.com/makjac/my_books_to_read.git
    ```

2. **Firebase Setup:**

    - Install Firebase CLI:

      ```sh
      npm install -g firebase-tools
      ```

    - Log in to Firebase:

      ```sh
      firebase login
      ```

    - Configure Firebase for your project by providing your Firebase Project ID:

      ```sh
      flutterfire configure --project=<your-project-id>
      ```

      Replace `<your-project-id>` with your Firebase Project ID.

3. **Build Runner Setup:**

    - Run the build_runner to generate necessary files:

      ```sh
      dart run build_runner build
      ```

4. **Run the application:**

    - Simply run the following command:

      ```sh
      flutter run
      ```

## Running Tests

### Unit Tests

To run the unit tests for the application, use the following command:

```sh
flutter test
```

### Integration Tests

To run the integration tests, use the following command:

```sh
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart
```

<!-- end:excluded_rules_table -->

[header_image_url]: https://raw.githubusercontent.com/makjac/images/refs/heads/main/My%20Books%20To%20Read/my_books_to_read.png

[ci_badge]: https://github.com/makjac/my_books_to_read/actions/workflows/build-and-test.yml/badge.svg
[ci_badge_link]: https://github.com/makjac/my_books_to_read/actions/workflows/build-and-test.yml

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
