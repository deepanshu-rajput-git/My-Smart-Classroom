import 'package:gsheets/gsheets.dart';

class SmartClassroomSheetsApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "smart-classroom-421916",
  "private_key_id": "94b2043be826665fc56f82666cf44fb6ef588be3",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDcaLCRZw4T9kZB\nrFAecDEDGsOmBzdNaULdqwi2h4wc8ZqpDDbbftm8+S11FhVr/fGSQkAEVg+jrcSt\ncUIZ0i2qLRImrDAphjjPFIz423DaJoY9/UKAtDjijTYm5ortlL1d5WYxGaFZgKkI\nMS9z5ThTJOzaSnnfmU7EqArggwDLY9eJlxhb4trwyzmT1bXQEvIyeMvMBlnK4nRE\nJn9c4XBlfbpXLQ8/0d7DWTcXc5kNu5R9LrGXHo8ZMxwQvX5f5YKkqzK0E8YKgmmg\nbgQuztYr3UOBJgMPqsIfDQDGngBOINPW4qToJj9ZzJZPJYJ9V4UDWsoXUt2Ho4BN\n0OdzJfWrAgMBAAECggEAHf7lYLRstwzCHPftY2cTVH/U9ohu30se/XnkUqr5x4qd\n6Lmv0Yle6pfitteNjMffk28OtUhdEoJ4jL4oJ8lxy4IcwUSXvV715kC+urNqlVW+\n2TrZTRi50SM0pnCjoZenedrZYH9DdSHMX0AKXDRqyO3yifauxV5g2OShrlJFzmgE\nT8FQnjaEzj/jI8sfNITYwVW3zGvC9VsF4AhqhuVGgDz7PqtgRMxWjLkY8t7RaGw6\nNvsRLd7e9HGGj9Uxy3MUT8GtORjUayWOnBm2rLTAGWco0iWfTm5YQ+lP9ubXmJpb\nWMBOv2o+wtvMjUzpxQzwFewo+sIk++nSdTEd70AmeQKBgQD7eFp8eEeO+Xt59wrc\nj53pcz7CBugwJWvX3k5bUwfna4pAQw9bNpDW6CqGsmoJqy5WdsSTZNiH155IhKyQ\nu4qOpFEeLZz95aNPnLaX6qAgpWAoHcTpmG4+0maYusW1mZ7pGd/8R4hTDYd/nF9x\nKjnG/SYEzSpCHq0aAP1sQri8twKBgQDgYRk8hflpn2dcFJcY+3RHr9tuFQn5R2BN\nYKQHeGPI8KqO1zg59VEfeg/1MjYgpIzDxiQUH52E9xzR5poF/f9l7WiMBXjkGehh\nLbMJsGEz7Y2MGF3BxvuRNoDslupU4b6RPW++XQWmWKdE4NQLPaBOqVh6zu8fcOsx\n43EVoNMCrQKBgEslK+UGDFwtMTjBGf3O7OFWDursJXY9uHxJciDYLwR4nleVsoEP\nTTjrJ8oYhpddD/vGgfeJqyrsw9/nxal6YW0+rP7XopI8jRC9Q9Mhybf3s0RJoQ4s\n/sTHGuGI7ovV3CbMFKLOvW4UHOmFUQAAHkPYYgQNSxN3F0MuCIzRY2MBAoGAJDEl\nS/DkQRg4KM8dbCcrI2EHSONV34KW0wRSkO3nUoMXT8EBTb/3HNeoeUlnF67TEcUF\nDsXmt4rQeD70+yB0MLGxmlxLmqdfJ0Wiyl5L339ixIUtolMBQvQCqabSF2zuOyko\nvBDvF1zXZjHJoiKHmAiSwARe57hkB4EDPZTaVGUCgYBQRL0ETfZgMeLrQWg2qDvn\nf9wClgXXaRoXvHFwz7H4NFT3Q8KIRRSx0LxavGd4uLrDyx++x3YQ1pT3olOdfRrW\nMBTaIKKjeAr5PE/lpbrpNuB5uNPd61UH8d8tERXmQjXuVIn9icUXOt4RVVd8Zr/i\nv12cKXgxTC71mgxpP4396A==\n-----END PRIVATE KEY-----\n",
  "client_email": "smart-classroom@smart-classroom-421916.iam.gserviceaccount.com",
  "client_id": "111485771711953466249",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/smart-classroom%40smart-classroom-421916.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';
  static const _spreadsheetId = '1ixDkS0dZKk6uLtvSksOgDmwQdox4h7_lD8eQZudI7Xg';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _smartClassroomSheet;

  static Future init() async {
    final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    _smartClassroomSheet =
        await _getWorksheet(spreadsheet, title: "smart_classroom");
  }

  static Future<Worksheet> _getWorksheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future<List<String>?> getLatestData() async {
    if (_smartClassroomSheet == null) return [];

    final thirdRow =
        await _smartClassroomSheet!.values.row(3, fromColumn: 9, length: 7);
    return thirdRow;
  }

  static Future<List<List<String>?>> getAllData() async {
    if (_smartClassroomSheet == null) return [];

    final allData = await _smartClassroomSheet!.values
        .allRows(fromRow: 2, fromColumn: 1, length: 7);
    return allData;
  }
}
