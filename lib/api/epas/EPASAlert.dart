class EPASAlert {
  String info = "";
  bool isOk = false;
  bool isShow = false;

  void show(String info, bool isOk) {
    this.info = info;
    this.isOk = isOk;
    this.isShow = true;
  }

  void hide() {
    this.isShow = false;
  }
}
