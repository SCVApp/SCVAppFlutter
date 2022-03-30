import 'package:flutter/material.dart';

class malica_Jed extends Container{
  final String naslov;
  final String imeJedi;
  final AssetImage slika;
  VoidCallback onTap;

  malica_Jed({this.imeJedi="",this.naslov="",this.slika});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            spreadRadius: 1.5,
            blurRadius: 2,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(this.naslov != "") Text(
            this.naslov,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
            ),
          Image(
            image: this.slika,
            height: 150,
          ),
          Text(
            this.imeJedi,
            ),
        ],
      ),
    ),
    );
  }
}

class malica_Info extends Container{

  final String opis;
  final String informacija;
  final Widget infoWidget;
  final double height;
  VoidCallback onTap;

  malica_Info({this.opis="",this.informacija="",this.infoWidget=null,this.height=50,this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      height: this.height,
      padding: EdgeInsets.only(right: 15,left: 15),
      decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor,
          spreadRadius: 1.5,
          blurRadius: 2,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
      borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Padding(padding: EdgeInsets.only(top:15)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: this.informacija.length < 10 ? 3 : 1,
                child: Text(this.opis)
              ),
              this.infoWidget == null ? Expanded(
                flex: 1,
                    child: Text(
                  this.informacija,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  ),
                ):infoWidget,
            ],
          ),
          // Padding(padding: EdgeInsets.only(bottom:15)),
        ],
      )
    ),
    );

  }
}

class malica_Jed_Izbira extends Container{
  final String naslov;
  final String imeJedi;
  final AssetImage slika;
  VoidCallback onTap;
  final bool izbrana;

  malica_Jed_Izbira({this.imeJedi="",this.naslov="",this.slika,this.izbrana=false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      height: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            spreadRadius: 1.5,
            blurRadius: 2,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        border: this.izbrana == true ? Border.all(color: Colors.green,width: 4):null,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(this.naslov != "") Text(
            this.naslov,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
            ),
          Image(
            image: this.slika,
            height: 120,
          ),
          Text(
            this.imeJedi,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    ),
    );
  }
}