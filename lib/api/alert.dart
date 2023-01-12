class GlobalAlert {
  bool isShow = false;
  String text = '';

  bool show(String text) {
    if (isShow == true) {
      return false;
    }
    this.text = text;
    this.isShow = true;
    return true;
  }

  void hide() {
    this.text = '';
    this.isShow = false;
  }
}
