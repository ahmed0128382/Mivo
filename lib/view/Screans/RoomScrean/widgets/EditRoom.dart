import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';

class EditRoom extends StatefulWidget {
  const EditRoom({Key? key}) : super(key: key);

  @override
  State<EditRoom> createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  @override
  Widget build(BuildContext context) {
    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(context, listen: true);

    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(context, listen: true);

    final bool canSave = room.EditRoomName.text.trim().isNotEmpty &&
        room.EditRoomDescription.text.trim().isNotEmpty &&
        room.choosen2.isNotEmpty &&
        room.backchoosen2.isNotEmpty &&
        room.flagchoosen2.isNotEmpty;

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CustomScrollView(
          slivers: [
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 30),
            ),

            // Room image and close button.
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => room.getImage2(),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 90,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: room.Roomimage2 == null
                          ? CachedNetworkImage(
                              imageUrl: room.Currentroom?.image ?? '',
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) =>
                                  const Icon(
                                Icons.meeting_room_outlined,
                                color: Colors.grey,
                                size: 32,
                              ),
                            )
                          : Image.file(
                              room.Roomimage2!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      room.clearadd2();
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.clear,
                      size: 25,
                      color: MainColor,
                    ),
                  ),
                ],
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 8),
            ),

            // Room name.
            SliverToBoxAdapter(
              child: _RoomEditField(
                controller: room.EditRoomName,
                hint: getLang(
                  context: context,
                  key: 'Name_Room',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),

            // Room description.
            SliverToBoxAdapter(
              child: _RoomEditField(
                controller: room.EditRoomDescription,
                hint: getLang(
                  context: context,
                  key: 'Room_ADS',
                ),
                maxLines: 3,
                onChanged: (_) => setState(() {}),
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),

            // Room categories.
            SliverToBoxAdapter(
              child: const Text(
                'Room categories',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),

            SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 2.7,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final String category =
                      user.Roomcatigoris[index]['name'].toString();

                  final bool selected =
                      room.choosen2.contains(category);

                  return InkWell(
                    onTap: () {
                      setState(() {
                        room.choosen2
                          ..clear()
                          ..add(category);
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? MainColor.withOpacity(0.8)
                            : Colors.black.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Center(
                        child: Text(
                          '# $category',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1,
                            color: selected
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: user.Roomcatigoris.length,
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),

            // Room background selection.
            SliverToBoxAdapter(
              child: const Text(
                'Room background',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),

            SliverToBoxAdapter(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: InkWell(
                        onTap: () => room.getImage3(),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 140,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              color: MainColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        user.background.length,
                        (index) {
                          final String image =
                              user.background[index]['image']
                                  .toString();

                          final bool selected =
                              room.backchoosen2.contains(image);

                          return InkWell(
                            onTap: () {
                              setState(() {
                                room.backchoosen2
                                  ..clear()
                                  ..add(image);
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Container(
                                height: 140,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                    color: selected
                                        ? MainColor
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      AppConstants.Image_URL + image,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 15),
            ),

            // Save room settings.
            SliverToBoxAdapter(
              child: InkWell(
                onTap: () {
                  if (!canSave) return;

                  Navigator.pop(context);
                  room.updateRoom();
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: SizeConfig.screenWidth ?? double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: canSave
                        ? MainColor
                        : Colors.black26,
                  ),
                  child: Center(
                    child: Text(
                      getLang(
                        context: context,
                        key: 'Edit',
                      ),
                      style: style1,
                    ),
                  ),
                ),
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomEditField extends StatelessWidget {
  const _RoomEditField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: onChanged,
        cursorColor: MainColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
