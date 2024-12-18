// services/dialogflow_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getDialogflowResponse(String query) async {
  try {
    final response = await http.post(
      Uri.parse('YOUR_DIALOGFLOW_ENDPOINT'), // Replace with your Dialogflow endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_DIALOGFLOW_ACCESS_TOKEN', // Replace with your token
      },
      body: json.encode({
        'queryInput': {
          'text': {
            'text': query,
            'languageCode': 'en',
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['queryResult']['fulfillmentText']; // Assuming this is the response format
    } else {
      return 'Error: Unable to reach Dialogflow.';
    }
  } catch (e) {
    return 'Error: Could not connect to Dialogflow.';
  }
}
