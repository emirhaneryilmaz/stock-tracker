import 'dart:async';

class UserAssetsEvent {
  static final StreamController<void> onUserAssetsChanged = StreamController<void>.broadcast();

  static void notifyUserAssetsChanged() {
    onUserAssetsChanged.add(null);
  }
}
