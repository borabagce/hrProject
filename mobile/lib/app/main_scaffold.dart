import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../features/sync/connectivity_banner.dart';
import 'router.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({required this.child, super.key});

  final Widget child;

  static const List<_NavItem> _items = <_NavItem>[
    _NavItem(AppRoutes.home, Icons.home_filled, AppStrings.tabHome),
    _NavItem(AppRoutes.tests, Icons.assignment_outlined, AppStrings.tabTests),
    _NavItem(
      AppRoutes.analytics,
      Icons.bar_chart_rounded,
      AppStrings.tabAnalytics,
    ),
    _NavItem(AppRoutes.profile, Icons.menu_rounded, AppStrings.tabMore),
  ];

  static const List<BottomNavigationBarItem> _navItems =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home_filled),
      label: AppStrings.tabHome,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.assignment_outlined),
      label: AppStrings.tabTests,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart_rounded),
      label: AppStrings.tabAnalytics,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.menu_rounded),
      label: AppStrings.tabMore,
    ),
  ];

  int _indexFromLocation(String location) {
    for (int i = 0; i < _items.length; i++) {
      if (location.startsWith(_items[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final String loc = GoRouterState.of(context).matchedLocation;
    final int index = _indexFromLocation(loc);

    return Scaffold(
      body: Column(
        children: <Widget>[
          const ConnectivityBanner(),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color(0x0F000000),
                offset: Offset(0, -2),
                blurRadius: 8,
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: index,
            onTap: (int i) => context.go(_items[i].path),
            items: _navItems,
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.path, this.icon, this.label);
  final String path;
  final IconData icon;
  final String label;
}
