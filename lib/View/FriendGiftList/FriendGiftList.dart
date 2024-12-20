import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/Config/theme.dart';
import 'package:hedieaty/Controller/GiftController.dart';
import 'package:hedieaty/Firebase/FirebaseFriendService.dart';
import 'package:hedieaty/Firebase/FirebaseGiftService.dart';
import 'package:hedieaty/Model/Event.dart';
import 'package:hedieaty/Model/Gift.dart';
import 'package:hedieaty/View/Widgets/AppBar.dart';
import 'package:hedieaty/View/Widgets/GeneralSwitchListTile.dart';
import 'package:hedieaty/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FriendGiftListScreen extends StatefulWidget {
  final Event event;
  const FriendGiftListScreen({super.key, required this.event});

  @override
  State<FriendGiftListScreen> createState() => _FriendGiftListScreenState();
}

class _FriendGiftListScreenState extends State<FriendGiftListScreen> {
  TextEditingController searchBarController = TextEditingController();
  String selectedSort = 'name';
  Query<Map<String, dynamic>>? baseQuery;
  List<Gift> allGifts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadGifts();

    searchBarController.addListener(_onSearchChanged);
  }

  Future<void> _loadGifts() async {
    try {
      allGifts = await FirebaseGiftService().getGiftsByEvent(widget.event.id);
      setState(() {
        isLoading = false;
      });
      _applyFilters(); // Apply initial sorting
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print('Error loading gifts: $e');
    }
  }

  @override
  void dispose() {
    searchBarController.removeListener(_onSearchChanged);
    searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredGifts = _getFilteredAndSortedGifts();

    return Scaffold(
      appBar: CustomAppBar(
        appBarActions: [],
        title: "${widget.event.name} gift list",
        isTherebackButton: true,
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.inkDrop(
                  color: ThemeClass.blueThemeColor, size: 60))
          : RefreshIndicator(
              onRefresh: _loadGifts,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: SearchBar(
                            controller: searchBarController,
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            hintText: '  search gifts',
                            hintStyle: WidgetStatePropertyAll(
                              Theme.of(context).textTheme.bodySmall,
                            ),
                            textStyle: WidgetStatePropertyAll(
                              Theme.of(context).textTheme.bodySmall,
                            ),
                            elevation: const WidgetStatePropertyAll(0),
                            leading: Image.asset(
                              'assets/icons/HomeScreenIcons/search.png',
                              width: 25,
                              height: 25,
                            ),
                            trailing: [
                              if (searchBarController.text.isNotEmpty)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      searchBarController.clear();
                                    });
                                  },
                                  icon: const Icon(Icons.cancel),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: _showSortDialog,
                          icon: const Icon(
                            Icons.filter_list_rounded,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.fromLTRB(15, 0, 3, 0),
                          decoration: BoxDecoration(
                            color: ThemeClass.blueThemeColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Available',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.fromLTRB(15, 0, 3, 0),
                          decoration: BoxDecoration(
                            color: ThemeClass.greenThemeColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Pledged',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.fromLTRB(15, 0, 3, 0),
                          decoration: BoxDecoration(
                            color: ThemeClass.yellowThemeColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'You Pledged',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredGifts.length,
                      itemBuilder: (context, index) {
                        final gift = filteredGifts[index];
                        bool isPledgedByOtherUser = gift.pledgerId != null &&
                            gift.pledgerId != currentUser.id;

                        return GeneralSwitchListTile(
                          hideToggle: isPledgedByOtherUser,
                          tileColor: gift.status == 'Available'
                              ? ThemeClass.blueThemeColor
                              : gift.pledgerId == currentUser.id
                                  ? ThemeClass.yellowThemeColor
                                  : ThemeClass.greenThemeColor,
                          text: gift.name,
                          leadingImgPath: gift.imageUrl ??
                              'assets/icons/Miscellaneous/gift.png',
                          subtitile:
                              "Category: ${gift.category} \nPrice: ${gift.price}",
                          toggleValue: gift.status != 'Available',
                          onToggleChanged: (value) async {
                            isLoading = true;
                            setState(() {});
                            if (value) {
                              gift.status = "Pledged";
                              gift.pledgerId = currentUser.id;
                              await FirebaseFriendService().sendNotification(
                                userId: widget.event.userId!,
                                title: "Gift Pledged 🎉",
                                message:
                                    "${currentUser.name} Pledged ${gift.name} for event ${widget.event.name}",
                              );
                            } else {
                              gift.status = "Available";
                              gift.pledgerId = null;
                              await FirebaseFriendService().sendNotification(
                                userId: widget.event.userId!,
                                title: "Gift Unpledged 😔",
                                message:
                                    "${currentUser.name} Unpledged ${gift.name} for event ${widget.event.name}",
                              );
                            }
                            await GiftController.updateGift(gift);
                            _loadGifts(); // reload the gifts after update
                            isLoading = false;
                            setState(() {});
                          },
                          tileOnTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(gift.name),
                                  content: gift.imageUrl == null
                                      ? Image.asset(
                                          'assets/icons/Miscellaneous/gift.png')
                                      : Image.network(gift.imageUrl!),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    if (filteredGifts.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            allGifts.isEmpty
                                ? 'No gifts yet for this event!'
                                : 'No gifts match your search.',
                            style: ThemeClass.theme.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  List<Gift> _getFilteredAndSortedGifts() {
    final searchQuery = searchBarController.text.toLowerCase();
    List<Gift> filtered = searchQuery.isEmpty
        ? List.from(allGifts)
        : allGifts
            .where((gift) =>
                (gift.name.toLowerCase().contains(searchQuery)) ||
                (gift.category.toLowerCase().contains(searchQuery)))
            .toList();

    switch (selectedSort) {
      case 'name':
        filtered.sort((a, b) => (a.name).compareTo(b.name));
      case 'category':
        filtered.sort((a, b) => (a.category).compareTo(b.category));
      case 'price':
        filtered.sort((a, b) => (a.price).compareTo(b.price));
    }
    // FocusManager.instance.primaryFocus?.unfocus();
    return filtered;
  }

  void _onSearchChanged() {
    setState(() {});
  }

  void _applyFilters() {
    setState(() {});
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Sort by',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Name'),
                leading: Radio<String>(
                  value: 'name',
                  groupValue: selectedSort,
                  onChanged: (String? value) {
                    setState(() {
                      selectedSort = value!;
                      _applyFilters();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Category'),
                leading: Radio<String>(
                  value: 'category',
                  groupValue: selectedSort,
                  onChanged: (String? value) {
                    setState(() {
                      selectedSort = value!;
                      _applyFilters();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Price'),
                leading: Radio<String>(
                  value: 'price',
                  groupValue: selectedSort,
                  onChanged: (String? value) {
                    setState(() {
                      selectedSort = value!;
                      _applyFilters();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
