import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/theme_switch.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;
  final String location;

  const AppScaffold({super.key, required this.child, required this.location});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  late Animation<double> _widthAnimation;
  bool _showRailContent = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _widthAnimation = Tween<double>(
      begin: 0,
      end: 208,
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.ease));

    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          _showRailContent = true;
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _showRailContent = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleRail() {
    if (_controller == null) return;
    if (_controller!.isDismissed) {
      _controller!.forward();
    } else if (_controller!.isCompleted) {
      _controller!.reverse();
    }
  }

  void _onDestinationSelected(int index) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/favorites');
      case 2:
        context.go('/generator');
    }
    _controller?.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:
              _controller == null
                  ? const Icon(Icons.menu)
                  : AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _controller!,
                  ),
          onPressed: _toggleRail,
        ),
        title: const Text('Todo App'),
        actions: [const ThemeSwitch(), const SizedBox(width: 16)],
      ),
      body: Stack(
        children: [
          widget.child,
          AnimatedBuilder(
            animation: _widthAnimation,
            builder: (context, child) {
              final showRail = _showRailContent && _widthAnimation.value > 200;

              return Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                width: _widthAnimation.value,
                child: Material(
                  elevation: 8,
                  color: Theme.of(context).colorScheme.surface,
                  child:
                      showRail
                          ? NavigationRail(
                            extended: true,
                            selectedIndex: _calculateSelectedIndex(
                              widget.location,
                            ),
                            onDestinationSelected: _onDestinationSelected,
                            destinations: const [
                              NavigationRailDestination(
                                icon: Icon(Icons.home_outlined),
                                selectedIcon: Icon(Icons.home),
                                label: Text('Home'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.favorite_outline),
                                selectedIcon: Icon(Icons.favorite),
                                label: Text('Favorites'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.auto_awesome_outlined),
                                selectedIcon: Icon(Icons.auto_awesome),
                                label: Text('Generator'),
                              ),
                            ],
                          )
                          : null,
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _widthAnimation,
            builder: (context, child) {
              double opacity =
                  (_widthAnimation.value / 208).clamp(0.0, 1.0) * 0.5;
              if (_widthAnimation.value == 0) return const SizedBox.shrink();
              return Positioned(
                top: 0,
                left: 208,
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _toggleRail,
                  behavior: HitTestBehavior.translucent,
                  child: Container(color: Color.fromRGBO(0, 0, 0, opacity)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/favorites')) {
      return 1;
    } else if (location.startsWith('/generator')) {
      return 2;
    }
    return 0;
  }
}
