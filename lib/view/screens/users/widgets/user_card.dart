import 'package:flukefy_admin/model/user.dart';
import 'package:flukefy_admin/view_model/utils/helper.dart';
import 'package:flutter/material.dart';

import '../../../animations/slide_animation.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: InkWell(
          borderRadius: BorderRadius.circular(7),
          onTap: () {
            showUserDialog(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SlideAnimation(
                      delay: 100,
                      child: Text(
                        user.name,
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SlideAnimation(
                      delay: 300,
                      child: Text(
                        user.email,
                        style: const TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                Text(
                  getLastSeen(user.lastLoggedTime),
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showUserDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
              content: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text('Name : ${user.name}', style: const TextStyle(fontSize: 17)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text('Phone : ${user.phone}', style: const TextStyle(fontSize: 17)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text('Email : ${user.email}', style: const TextStyle(fontSize: 17)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text('Last seen : ${getLastSeen(user.lastLoggedTime)}', style: const TextStyle(fontSize: 17)),
              ),
            ],
          ));
        });
  }
}
