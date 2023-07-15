class Window {
  final String name;
  bool isShown = false;
  final int pageViewIndex;

  Map<String, dynamic> attributes = {};

  Window({required this.name, required this.pageViewIndex});
}
