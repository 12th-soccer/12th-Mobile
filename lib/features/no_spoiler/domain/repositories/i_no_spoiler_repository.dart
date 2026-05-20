abstract interface class INoSpoilerRepository {
  Future<bool> get();
  Future<bool> save(bool enabled);
}
