import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:dialogflow_flutter/language.dart';
import 'package:flutter/material.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';

class LogTab extends StatefulWidget {
  @override
  _LogTabState createState() => _LogTabState();
}

class _LogTabState extends State<LogTab> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message to the chat
    setState(() {
      _messages.add({"sender": "user", "text": message});
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Initialize Dialogflow
      AuthGoogle authGoogle =
          await AuthGoogle(fileJson: "assets/dialogflow.json").build();
      DialogFlow dialogflow =
          DialogFlow(authGoogle: authGoogle, language: Language.english);

      // Get the bot response
      AIResponse response = await dialogflow.detectIntent(message);
      String botReply = response.getMessage() ?? "Sorry, I didn't understand that.";

      // Add bot response to the chat
      setState(() {
        _messages.add({"sender": "bot", "text": botReply});
      });
    } catch (e) {
      // Handle errors gracefully
      setState(() {
        _messages.add({"sender": "bot", "text": "Error: Unable to connect to the chatbot."});
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatbot"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isUserMessage = message["sender"] == "user";

                return Align(
                  alignment:
                      isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Colors.teal[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message["text"] ?? "",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.teal),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
