import 'package:chat/constants.dart';
import 'package:chat/blocs/chat/chat_cubit.dart';
import 'package:chat/blocs/chat/chat_state.dart';
import 'package:chat/widgets/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';

  final _controller = ScrollController();

  TextEditingController controller = TextEditingController();
  ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    ChatCubit cubit = BlocProvider.of<ChatCubit>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kLogo,
              height: 50,
            ),
            const Text('chat'),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
             
              builder: (context, state) {
                return ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: cubit.messagesList.length,
                    itemBuilder: (context, index) {
                      return cubit.messagesList[index].id == email
                          ? ChatBuble(
                              message: cubit.messagesList[index],
                            )
                          : ChatBubleForFriend(message: cubit.messagesList[index]);
                    });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller,
              onSubmitted: (data) {
                cubit.sendMessage(
                  data: data,
                  email: email,
                );

                // cubit.messages.add(
                //   {
                //     kMessage: data,
                //     kCreatedAt: DateTime.now(),
                //     'id': email
                //   },
                // );
                controller.clear();
                _controller.animateTo(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
              decoration: InputDecoration(
                hintText: 'Send Message',
                suffixIcon: const Icon(
                  Icons.send,
                  color: kPrimaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
