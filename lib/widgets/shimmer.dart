import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shimmer/shimmer.dart';

class Shimmers {
  //home shimmers
  static final homeShimmer = Shimmer.fromColors(
    baseColor: Colors.grey[900]!,
    highlightColor: Colors.grey[600]!,
    child: ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: ShadCard(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: ListTile(
              leading: ShadAvatar('assets/images/updated.png'),
              title: Container(width: 100, height: 20, color: Colors.grey[900]),
              subtitle: Container(
                width: 100,
                height: 20,
                color: Colors.grey[900],
              ),
              trailing: ShadButton(
                onPressed: () {},
                // variant: ButtonVariant.secondary,
                child: const Text("Update"),
              ),
            ),
          ),
        );
      },
    ),
  );
}
