import 'package:flutter/material.dart';
import 'package:login_signup/theme/app_colors.dart';

class DockingBar extends StatefulWidget {
  final Function(int) onIndexChanged;
  const DockingBar({super.key, required this.onIndexChanged});

  @override
  State<DockingBar> createState() => _DockingBarState();
}

class _DockingBarState extends State<DockingBar> {
  int activeIndex = 0;

  final List<IconData> icons = [
    Icons.home_rounded,
    Icons.notifications_rounded,
    Icons.logout_rounded,
  ];

  final List<String> labels = ['Home', 'Alerts', 'Logout'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (i) {
          final isActive = i == activeIndex;
          return GestureDetector(
            onTap: () {
              setState(() => activeIndex = i);
              widget.onIndexChanged(i);
            },
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: isActive ? 20 : 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primaryBg : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icons[i],
                    size: 22,
                    color: isActive ? AppColors.primary : AppColors.textHint,
                  ),
                  if (isActive) ...[
                    const SizedBox(width: 8),
                    Text(
                      labels[i],
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
