final chatProvider = StreamProvider<List<String>>((ref) async* {
  // Connect to an API using sockets, and decode the output
  final socket = await Socket.connect('my-api', 4242);
  ref.onDispose(socket.close);

  var allMessages = const <String>[];
  await for (final message in socket.map(utf8.decode)) {
    // A new message has been received. Let's add it to the list of all messages.
    allMessages = [...allMessages, message];
    yield allMessages;
  }
});

Widget build(BuildContext context, WidgetRef ref) {
  final liveChats = ref.watch(chatProvider);
  // Like FutureProvider, it is possible to handle loading/error states using AsyncValue.when
  return liveChats.when(
    loading: () => const CircularProgressIndicator(),
    error: (error, stackTrace) => Text(error.toString()),
    data: (messages) {
      // Display all the messages in a scrollable list view.
      return ListView.builder(
        // Show messages from bottom to top
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Text(message);
        },
      );
    },
  );
}
