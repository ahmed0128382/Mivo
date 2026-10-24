
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/app_constants.dart';

/// Resolves a user's selected frame to its static PNG image.
///
/// Examples:
///   1789734084.svg       -> 1789734084.png
///   1789734084.svga      -> 1789734084.png
///   https://host/x.svg   -> https://host/x.png
///
/// The API value itself is not modified or saved by this function.
String? resolveFramePngUrl(String? frame) {
  if (frame == null) return null;

  String path = frame.trim();

  if (path.isEmpty || path.toLowerCase() == 'null') {
    return null;
  }

  final Uri? parsed = Uri.tryParse(path);
  final bool isAbsoluteUrl = parsed != null &&
      (parsed.scheme == 'http' || parsed.scheme == 'https') &&
      parsed.host.isNotEmpty;

  // Preserve query parameters and other URL components when present.
  if (isAbsoluteUrl) {
    final uri = parsed!;
    final String uriPath = uri.path;
    final String lowerPath = uriPath.toLowerCase();

    String? replacement;

    if (lowerPath.endsWith('.svg')) {
      replacement = '${uriPath.substring(0, uriPath.length - 4)}.png';
    } else if (lowerPath.endsWith('.svga')) {
      replacement = '${uriPath.substring(0, uriPath.length - 5)}.png';
    }

    if (replacement != null) {
      return uri.replace(path: replacement).toString();
    }

    return path;
  }

  // For relative filenames, change only the extension.
  final String lowerPath = path.toLowerCase();

  if (lowerPath.endsWith('.svg')) {
    path = '${path.substring(0, path.length - 4)}.png';
  } else if (lowerPath.endsWith('.svga')) {
    path = '${path.substring(0, path.length - 5)}.png';
  }

  // Support filenames and paths such as /images/frame.png.
  final String relativePath = path.startsWith('/images/')
      ? path.substring('/images/'.length)
      : path.startsWith('images/')
          ? path.substring('images/'.length)
          : path.startsWith('/')
              ? path.substring(1)
              : path;

  final String baseUrl = AppConstants.Image_URL.trim();

  if (baseUrl.isEmpty) return null;

  final String normalizedBase =
      baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

  return '$normalizedBase$relativePath';
}

Widget _buildAvatar(String? image, {double radius = 24}) {
  final String url = image?.trim() ?? '';

  if (url.isEmpty || url.toLowerCase() == 'null') {
    return const SizedBox.shrink();
  }

  return CircleAvatar(
    backgroundColor: Colors.transparent,
    radius: radius,
    backgroundImage: CachedNetworkImageProvider(url),
  );
}

Widget _buildFrame(String? frame) {
  final String? url = resolveFramePngUrl(frame);

  if (url == null) return const SizedBox.shrink();

  return IgnorePointer(
    child: SizedBox.expand(
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.contain,
        placeholder: (_, __) => const SizedBox.shrink(),
        errorWidget: (_, __, error) {
          debugPrint('[FRAME_IMAGE] Failed to load $url: $error');
          return const SizedBox.shrink();
        },
      ),
    ),
  );
}

class PhotoFrame extends StatelessWidget {
  final String? image;
  final String? Frame;

  const PhotoFrame({super.key, this.image, this.Frame});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Center(child: _buildAvatar(image)),
          _buildFrame(Frame),
          if (image == null || image!.isEmpty)
            Image.asset(Images.Chairs, fit: BoxFit.contain),
        ],
      ),
    );
  }
}

class UserFrame extends StatelessWidget {
  final String? image;
  final String? Frame;

  const UserFrame({super.key, this.image, this.Frame});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Center(child: _buildAvatar(image)),
          _buildFrame(Frame),
          if (image == null || image!.isEmpty)
            Image.asset(Images.Chairs, fit: BoxFit.contain),
        ],
      ),
    );
  }
}

class MainFrame extends StatelessWidget {
  final String? image;
  final String? Frame;

  const MainFrame({super.key, this.image, this.Frame});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Center(child: _buildAvatar(image, radius: 30)),
          _buildFrame(Frame),
        ],
      ),
    );
  }
}

class PhotoFrame2 extends StatelessWidget {
  final String? image;
  final String? Frame;

  const PhotoFrame2({super.key, this.image, this.Frame});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Center(child: _buildAvatar(image, radius: 47)),
          _buildFrame(Frame),
        ],
      ),
    );
  }
}

class FrameUserProfile extends StatelessWidget {
  final String? image;
  final String? Frame;

  const FrameUserProfile({super.key, this.image, this.Frame});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Center(child: _buildAvatar(image, radius: 40)),
          _buildFrame(Frame),
        ],
      ),
    );
  }
}

class FrameRelationsProfile extends StatelessWidget {
  final String? image;
  final String? Frame;

  const FrameRelationsProfile({super.key, this.image, this.Frame});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Center(child: _buildAvatar(image, radius: 30)),
          _buildFrame(Frame),
        ],
      ),
    );
  }
}

/// Kept as an asset-based widget for existing local leaderboard frames.
class LeaderboardFrame extends StatelessWidget {
  final String? image;
  final String? Frame;

  const LeaderboardFrame({super.key, this.image, this.Frame});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (image != null && image!.isNotEmpty)
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 30,
              backgroundImage: CachedNetworkImageProvider(image!),
            ),
          if (Frame != null && Frame!.isNotEmpty)
            Image.asset(Frame!, fit: BoxFit.contain),
        ],
      ),
    );
  }
}
