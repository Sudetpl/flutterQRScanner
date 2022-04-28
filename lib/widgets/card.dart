import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subTitle;
  final void Function() onTap;
  final List<Widget> actions;

  const ListItem({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.subTitle,
    this.onTap,
    this.actions: const [Icon(Icons.star_outline)],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            child: icon,
          ),
          SizedBox(
            width: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(subTitle)
            ],
          ),
          Spacer(),
          ...actions,
        ],
      ),
    );
  }
}

class CardListItem extends StatelessWidget {
  final Widget icon;
  final String text;
  final void Function() onTap;
  final Widget suffixIcon;
  final bool centerText;

  const CardListItem({
    Key key,
    @required this.text,
    this.icon,
    this.suffixIcon: const Icon(Icons.navigate_next),
    this.onTap,
    this.centerText: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(children: [
        icon != null ? CircleAvatar(child: icon) : Container(),
        centerText ? Spacer() : SizedBox(width: 10.0),
        Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        Spacer(),
        suffixIcon,
      ]),
    );
  }
}

class CardList extends StatelessWidget {
  final List<Widget> items;

  const CardList({Key key, this.items: const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TopCard(
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) => items[index],
        separatorBuilder: (_, __) => Divider(
          thickness: 1,
        ),
        itemCount: items.length,
      ),
    );
  }
}

class TopCard extends StatelessWidget {
  final Widget child;

  const TopCard({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: child,
        ),
      ),
    );
  }
}
