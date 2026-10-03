import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../util/Dialogs.dart';
import '../../../../util/Localization.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

class AddRoomScrean extends StatefulWidget {
  const AddRoomScrean({
    Key? key,
  }) : super(key: key);

  @override
  State<AddRoomScrean> createState() =>
      _AddRoomScreanState();
}

class _AddRoomScreanState
    extends State<AddRoomScrean> {
  @override
  Widget build(BuildContext context) {
    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(
      context,
      listen: true,
    );

    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: true,
    );

    final bool canSave =
        room.RoomName.text.trim().isNotEmpty &&
            room.RoomAds.text.trim().isNotEmpty &&
            room.choosen.isNotEmpty &&
            room.Roomimage != null &&
            room.RoomBackgroundImage != null;

    return Material(
      color: Colors.white,
      borderRadius:
          const BorderRadius.vertical(
        top: Radius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: CustomScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            // =================================================
            // HEADER
            // =================================================

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  8,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 42,
                      height: 5,
                      decoration:
                          BoxDecoration(
                        color: Colors.black12,
                        borderRadius:
                            BorderRadius.circular(
                          50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Create Room',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius:
                              BorderRadius.circular(
                            30,
                          ),
                          onTap: () {
                            room.clearadd();
                            Navigator.pop(
                              context,
                            );
                          },
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration:
                                BoxDecoration(
                              color: Colors.black
                                  .withOpacity(0.06),
                              shape:
                                  BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 21,
                              color:
                                  Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment:
                          Alignment.centerLeft,
                      child: Text(
                        'Set up your room',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black
                              .withOpacity(0.45),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =================================================
            // ROOM COVER
            // =================================================

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  12,
                ),
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                  onTap: () async {
                    await room.getImage();
                  },
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration:
                        BoxDecoration(
                      color: Colors.grey
                          .withOpacity(0.08),
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                      border: Border.all(
                        color:
                            room.Roomimage !=
                                    null
                                ? MainColor
                                    .withOpacity(
                                    0.45,
                                  )
                                : Colors.black12,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child:
                              room.Roomimage ==
                                      null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        Container(
                                          width: 58,
                                          height: 58,
                                          decoration:
                                              BoxDecoration(
                                            color: MainColor
                                                .withOpacity(
                                              0.10,
                                            ),
                                            shape: BoxShape
                                                .circle,
                                          ),
                                          child:
                                              Icon(
                                            Icons
                                                .add_a_photo_outlined,
                                            color:
                                                MainColor,
                                            size:
                                                28,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                10),
                                        const Text(
                                          'Add room photo',
                                          style:
                                              TextStyle(
                                            fontSize:
                                                15,
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                4),
                                        Text(
                                          'Choose a photo from your gallery',
                                          style:
                                              TextStyle(
                                            fontSize:
                                                12,
                                            color: Colors
                                                .black45,
                                          ),
                                        ),
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        20,
                                      ),
                                      child:
                                          Image.file(
                                        room.Roomimage!,
                                        width: double
                                            .infinity,
                                        height: double
                                            .infinity,
                                        fit: BoxFit
                                            .cover,
                                      ),
                                    ),
                        ),
                        if (room.Roomimage != null)
                          Positioned(
                            right: 12,
                            bottom: 12,
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration:
                                  BoxDecoration(
                                color: Colors.white,
                                shape:
                                    BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(
                                      0.12,
                                    ),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                color: MainColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // =================================================
            // ROOM NAME
            // =================================================

            SliverToBoxAdapter(
              child: _buildField(
                child: TextFormField(
                  controller: room.RoomName,
                  textInputAction:
                      TextInputAction.next,
                  maxLength: 40,
                  onChanged: (_) {
                    setState(() {});
                  },
                  cursorColor: MainColor,
                  decoration:
                      InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: getLang(
                      context: context,
                      key: "Name_Room",
                    ),
                    prefixIcon: Icon(
                      Icons
                          .meeting_room_outlined,
                      color: MainColor,
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),

            // =================================================
            // ROOM ADS
            // =================================================

            SliverToBoxAdapter(
              child: _buildField(
                child: TextFormField(
                  controller: room.RoomAds,
                  maxLength: 100,
                  maxLines: 2,
                  onChanged: (_) {
                    setState(() {});
                  },
                  cursorColor: MainColor,
                  decoration:
                      InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: getLang(
                      context: context,
                      key: "Room_ADS",
                    ),
                    prefixIcon: Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Icon(
                        Icons
                            .campaign_outlined,
                        color: MainColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),

            // =================================================
            // CATEGORY TITLE
            // =================================================

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: _sectionTitle(
                  title: 'Category',
                  icon: Icons.sell_outlined,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),

            // =================================================
            // CATEGORY CHIPS
            // =================================================

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child:
                    user.Roomcatigoris.isEmpty
                        ? Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets
                                    .all(
                              14,
                            ),
                            decoration:
                                BoxDecoration(
                              color: Colors.black
                                  .withOpacity(
                                0.04,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),
                            ),
                            child: const Text(
                              'No categories available',
                              style:
                                  TextStyle(
                                fontSize: 13,
                                color: Colors
                                    .black45,
                              ),
                            ),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                List.generate(
                              user.Roomcatigoris
                                  .length,
                              (index) {
                                final String
                                    category =
                                    user.Roomcatigoris[
                                                index]
                                            ['name']
                                        .toString();

                                final bool
                                    selected =
                                    room.choosen
                                        .contains(
                                  category,
                                );

                                return InkWell(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    30,
                                  ),
                                  onTap: () {
                                    room.choosen
                                      ..clear()
                                      ..add(
                                        category,
                                      );

                                    setState(
                                      () {},
                                    );
                                  },
                                  child:
                                      AnimatedContainer(
                                    duration:
                                        const Duration(
                                      milliseconds:
                                          180,
                                    ),
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal:
                                          14,
                                      vertical: 9,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: selected
                                          ? MainColor
                                          : Colors
                                              .black
                                              .withOpacity(
                                              0.06,
                                            ),
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        30,
                                      ),
                                      border:
                                          Border.all(
                                        color: selected
                                            ? MainColor
                                            : Colors
                                                .black12,
                                      ),
                                    ),
                                    child: Text(
                                      '# $category',
                                      style:
                                          TextStyle(
                                        fontSize:
                                            12,
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                        color: selected
                                            ? Colors
                                                .white
                                            : Colors
                                                .black87,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 18),
            ),

            // =================================================
            // BACKGROUND TITLE
            // =================================================

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: _sectionTitle(
                  title: 'Room Background',
                  icon:
                      Icons.wallpaper_outlined,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),

            // =================================================
            // ROOM BACKGROUND
            // User uploads a File just like room photo.
            // =================================================

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                  onTap: () async {
                    await room.getImage3();
                  },
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration:
                        BoxDecoration(
                      color: Colors.grey
                          .withOpacity(0.08),
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                      border: Border.all(
                        color: room
                                    .RoomBackgroundImage !=
                                null
                            ? MainColor
                                .withOpacity(
                                0.45,
                              )
                            : Colors.black12,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: room
                                      .RoomBackgroundImage ==
                                  null
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                  children: [
                                    Container(
                                      width: 58,
                                      height: 58,
                                      decoration:
                                          BoxDecoration(
                                        color: MainColor
                                            .withOpacity(
                                          0.10,
                                        ),
                                        shape: BoxShape
                                            .circle,
                                      ),
                                      child: Icon(
                                        Icons
                                            .add_photo_alternate_outlined,
                                        color:
                                            MainColor,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 10),
                                    const Text(
                                      'Add room background',
                                      style:
                                          TextStyle(
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 4),
                                    Text(
                                      'Choose a background image from your gallery',
                                      textAlign:
                                          TextAlign
                                              .center,
                                      style:
                                          TextStyle(
                                        fontSize: 12,
                                        color: Colors
                                            .black45,
                                      ),
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    20,
                                  ),
                                  child:
                                      Image.file(
                                    room
                                        .RoomBackgroundImage!,
                                    width: double
                                        .infinity,
                                    height: double
                                        .infinity,
                                    fit: BoxFit
                                        .cover,
                                  ),
                                ),
                        ),
                        if (room
                                .RoomBackgroundImage !=
                            null)
                          Positioned(
                            right: 12,
                            bottom: 12,
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration:
                                  BoxDecoration(
                                color: Colors.white,
                                shape:
                                    BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(
                                      0.12,
                                    ),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                color: MainColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // =================================================
            // SAVE
            // =================================================

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  22,
                  16,
                  8,
                ),
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                  onTap: () async {
                    FocusScope.of(context)
                        .unfocus();

                    final String roomName =
                        room.RoomName.text.trim();

                    final String roomAds =
                        room.RoomAds.text.trim();

                    if (roomName.isEmpty) {
                      Dialogs().showtoast(
                        getLang(
                          context: context,
                          key: "Name_Room",
                        ),
                      );
                      return;
                    }

                    if (roomAds.isEmpty) {
                      Dialogs().showtoast(
                        getLang(
                          context: context,
                          key: "Room_ADS",
                        ),
                      );
                      return;
                    }

                    if (room.Roomimage ==
                        null) {
                      Dialogs().showtoast(
                        'Please add a room photo',
                      );
                      return;
                    }

                    if (room.choosen.isEmpty) {
                      Dialogs().showtoast(
                        'Please choose a category',
                      );
                      return;
                    }

                    if (room
                            .RoomBackgroundImage ==
                        null) {
                      Dialogs().showtoast(
                        'Please choose a room background',
                      );
                      return;
                    }

                    final bool existed =
                        insult.any(
                      (item) =>
                          item.contains(
                        roomName,
                      ),
                    );

                    if (existed) {
                      room.Addinsults(
                        context: context,
                        message: roomName,
                        type: 'Create Room',
                      );

                      Dialogs().showdialog4(
                        context: context,
                        content: getLang(
                          context: context,
                          key: "sults",
                        ),
                      );

                      return;
                    }

                    final NavigatorState
                        navigator =
                        Navigator.of(
                      context,
                    );

                    final bool success =
                        await room.CreateRoom(
                      context: context,
                      name: roomName,
                      Category:
                          room.choosen.first,
                      city:
                          room.flagchoosen,
                      backgroundimage:
                          room
                              .RoomBackgroundImage!,
                    );

                    if (!mounted) {
                      return;
                    }

                    if (success) {
                      navigator.pop();

                      navigator.pushNamed(
                        AppConstants
                            .Room_Screan,
                      );
                    }
                  },
                  child:
                      AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds: 180,
                    ),
                    height: 54,
                    width: double.infinity,
                    decoration:
                        BoxDecoration(
                      color: canSave
                          ? MainColor
                          : Colors.black12,
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                      boxShadow: canSave
                          ? [
                              BoxShadow(
                                color: MainColor
                                    .withOpacity(
                                  0.25,
                                ),
                                blurRadius: 14,
                                offset:
                                    const Offset(
                                  0,
                                  6,
                                ),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          Icon(
                            Icons
                                .add_circle_outline,
                            color: canSave
                                ? Colors.white
                                : Colors.black38,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            getLang(
                              key: "Save",
                              context: context,
                            ),
                            style:
                                style1.copyWith(
                              color: canSave
                                  ? Colors.white
                                  : Colors.black38,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required Widget child,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Container(
        decoration:
            BoxDecoration(
          color: Colors.grey
              .withOpacity(0.07),
          borderRadius:
              BorderRadius.circular(
            16,
          ),
          border: Border.all(
            color: Colors.black
                .withOpacity(0.05),
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 2,
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _sectionTitle({
    required String title,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: MainColor,
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}