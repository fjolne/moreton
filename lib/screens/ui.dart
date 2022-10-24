import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.shield),
          label: "Wallet",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: "Discover",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view),
          label: "Browser",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}

typedef ActionButtonCallback = void Function();

class ActionButton extends StatelessWidget {
  final Icon icon;
  final String text;
  final ActionButtonCallback onPressed;

  const ActionButton(
      {required this.icon,
      required this.text,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return Column(
      children: [
        CircleAvatar(
            radius: 24,
            backgroundColor: cs.primary,
            child: IconButton(
              iconSize: 24,
              icon: icon,
              color: cs.onPrimary,
              onPressed: onPressed,
            )),
        const SizedBox(
          height: 4,
        ),
        Text(text, style: tt.bodySmall?.copyWith(color: cs.secondary))
      ],
    );
  }
}

void pushModal(BuildContext context, Widget Function(BuildContext) builder) {
  var cs = Theme.of(context).colorScheme;
  var tt = Theme.of(context).textTheme;
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: cs.surfaceVariant,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    context: context,
    builder: builder,
  );
}
