import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ProfileCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Color(0xFFF47814),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF59597C),
                    fontWeight: FontWeight.w500,
                    fontFamily: "Outfit",
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Outfit",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {},
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      minVerticalPadding: 0,
      visualDensity: VisualDensity.compact,
    );
  }
}
