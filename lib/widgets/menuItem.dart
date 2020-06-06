import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String menuName;
  final IconData icon;
  final MaterialPageRoute materialPageRoute;
  MenuItem({this.materialPageRoute, this.icon, this.menuName});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).backgroundColor,
      ),
      child: ListTile(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            materialPageRoute,
          );
        },
        leading:
            Icon(icon, color: Theme.of(context).primaryColor.withOpacity(.9)),
        title: Text(
          menuName,
          style: TextStyle(
            color: Theme.of(context).primaryColor.withOpacity(.9),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
