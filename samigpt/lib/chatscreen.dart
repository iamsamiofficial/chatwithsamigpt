import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:samigpt/chatmessage.dart';
import 'package:samigpt/threedots.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List <ChatMessage>_messages = [];

  ChatGPT ? chatGPT;
  StreamSubscription ? _subscription;
  bool _isTyping = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatGPT = ChatGPT.instance;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _subscription?.cancel();
    super.dispose();
  }
  void _sendMessage(){
    ChatMessage message = ChatMessage(text: _controller.text, sender:'user');


    setState(() {
      _messages.insert(0,message);
      _isTyping = true;
    });
    _controller.clear();

  final request = CompleteReq(prompt: message.text, model: kTranslateModelV3,max_tokens: 500);
  _subscription = chatGPT!.builder("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",orgId: "")
  .onCompleteStream(request: request).listen((response) {
    Vx.log(response!.choices[0].text);
    ChatMessage botmessage = ChatMessage(text: response.choices[0].text, sender:'SamiGPT');

  setState(() {
    _isTyping = false;
    _messages.insert(0, botmessage);
    
  });
  });

  }



  Widget _buildTextComposer(){
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left:16.0),
        child: Row(
          children: [
            Expanded(
              child:TextField(
                controller: _controller,
                onSubmitted: (value)=>_sendMessage(),
                decoration: const InputDecoration.collapsed(hintText: 'Send a text to SamiGPT'),
              ),
              ),
            IconButton(
              onPressed: ()=>_sendMessage(),
              icon: const Icon(Icons.send)
              ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SamiGPT'),),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              padding: Vx.m8,
              itemBuilder: (context,index){
                
                return _messages[index];
              
              }),),
          if (_isTyping) const ThreeDots(),
          const Divider(
            height: 1.0,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,

            ),
            child: _buildTextComposer(),
          ),
        ],
      ),

    );
  }
}