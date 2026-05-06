abstract interface class INoSpoilerRepository {
  Future<bool> get();
  Future<void> save(bool enabled);
}
