import 'package:chat/constants.dart';
import 'package:chat/cubits/chat/chat_state.dart';
import 'package:chat/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);

  List<Message> messagesList = [];


  void sendMessage({required var email, required String data, }) {
    messages.add(
      {kMessage: data, kCreatedAt: DateTime.now(), 'id': email},
    );
  }



  void getMessages() {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event){

    messagesList.clear();
      for(var doc in event.docs){
        messagesList.add(Message.fromJson(doc));
      }
    
      emit(ChatSuccess(messages: messagesList));
    });
    }
}
