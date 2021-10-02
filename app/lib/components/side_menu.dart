import 'package:dlxstudios_app/components/logo.dart';
import 'package:dlxstudios_app/data.dart';
import 'package:dlxstudios_app/state/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  final void Function(int index) onTap;
  final int? selectedIndex;

  const SideMenu({
    Key? key,
    required this.onTap,
    this.selectedIndex,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<DashAppState>(
      builder: (context, app, child) {
        // print(app.routesForDrawer);
        var children = app.routesForDrawer
            .asMap()
            .map((index, e) => MapEntry(
                index,
                _SideMenuIconTab(
                  selected: selectedIndex == index ? true : false,
                  iconData: e.icon!,
                  title: e.title!,
                  onTap: () => onTap(index),
                )))
            .values
            .toList();
        return Container(
          height: double.infinity,
          // width: 280.0,
          // color: Theme.of(context).accentColor,
          child: Column(
            children: [
              AspectRatio(
                  aspectRatio: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DLXLogo(),
                  )),
              ...children,
              _LibraryPlaylists(),
            ],
          ),
        );
      },
    );
  }
}

class _SideMenuIconTab extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTap;
  final bool? selected;

  const _SideMenuIconTab({
    Key? key,
    required this.iconData,
    required this.title,
    required this.onTap,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedTileColor: Theme.of(context).accentColor,
      selected: selected ?? false,
      leading: Icon(
        iconData,
        color: selected != null && selected == true
            ? ThemeData.estimateBrightnessForColor(
                        Theme.of(context).accentColor) ==
                    Brightness.dark
                ? Colors.white
                : Colors.black87
            : Theme.of(context).iconTheme.color,
        size: 28.0,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: selected != null && selected == true
                  ? ThemeData.estimateBrightnessForColor(
                              Theme.of(context).accentColor) ==
                          Brightness.dark
                      ? Colors.white
                      : Colors.black87
                  : Theme.of(context).iconTheme.color,
            ),
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}

class _LibraryPlaylists extends StatefulWidget {
  @override
  __LibraryPlaylistsState createState() => __LibraryPlaylistsState();
}

class __LibraryPlaylistsState extends State<_LibraryPlaylists> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          physics: const ClampingScrollPhysics(),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Text(
                    'YOUR LIBRARY',
                    // style: Theme.of(context).textTheme.headline4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ...yourLibrary
                    .map((e) => ListTile(
                          dense: true,
                          title: Text(
                            e,
                            style: Theme.of(context).textTheme.bodyText2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            var app = context.read<DashAppState>();
                            print(app.user);
                          },
                        ))
                    .toList(),
              ],
            ),
            const SizedBox(height: 24.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Text(
                    'PLAYLISTS',
                    // style: Theme.of(context).textTheme.headline4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ...playlists
                    .map((e) => ListTile(
                          dense: true,
                          title: Text(
                            e,
                            style: Theme.of(context).textTheme.bodyText2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {},
                        ))
                    .toList(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
