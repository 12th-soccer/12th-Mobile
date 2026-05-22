import 'dart:async';

class SessionManager {
  SessionManager._();

  static final _controller = StreamController<void>.broadcast();

  static Stream<void> get onSessionExpired => _controller.stream;

  static void notifyExpired() => _controller.add(null);
}
