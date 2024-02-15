import 'package:flukefy_admin/model/user.dart';
import 'package:flukefy_admin/view_model/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../../animations/slide_animation.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
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
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SlideAnimation(
                      delay: 300,
                      child: Text(
                        user.email,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                SlideAnimation(
                  delay: 500,
                  child: Text(
                    Helper.getLastSeenFromDate(user.lastLoggedTime),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
                  ),
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SlideAnimation(
                delay: 100,
                child: Padding(padding: const EdgeInsets.only(top: 7), child: Text('Name : ${user.name}')),
              ),
              SlideAnimation(
                delay: 200,
                child: Padding(padding: const EdgeInsets.only(top: 7), child: Text('Phone : ${user.phone}')),
              ),
              SlideAnimation(
                delay: 300,
                child: Padding(padding: const EdgeInsets.only(top: 7), child: Text('Email : ${user.email}')),
              ),
              SlideAnimation(
                delay: 400,
                child: Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    'Last seen : ${DateFormat('E, MMM d').format(user.lastLoggedTime)}',
                  ),
                ),
              ),
              SlideAnimation(
                delay: 500,
                child: Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    'Joined date : ${DateFormat('E, MMM d').format(user.createdTime)}',
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SlideAnimation(
                delay: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FilledButton.icon(
                      onPressed: () => Fluttertoast.showToast(msg: 'Coming soon'),
                      icon: const Icon(Icons.block),
                      label: const Text('Block'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton.icon(
                      onPressed: () => Fluttertoast.showToast(msg: 'Coming soon'),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
