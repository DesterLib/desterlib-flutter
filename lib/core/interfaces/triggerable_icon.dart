/// Implemented by any icon State that can be animated on demand.
/// Static icons simply don't implement it — the button checks for it.
abstract interface class TriggerableIcon {
  void trigger();
}
