
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Repositores/Music_repositores/Musicapi.dart';
import '../../models/UserMusic.dart';

class DurationState {
  DurationState({
    this.position = Duration.zero,
    this.total = Duration.zero,
  });

  final Duration position;
  final Duration total;
}

class MusicViewModel extends ChangeNotifier {
  static const String _playlistKey = 'Songs';
  static const String _playlistIdsKey = 'SongsIds';
  static const String _musicFolderName = 'music_library';

  final TextEditingController NameController = TextEditingController();

  List<SongModel> songs = [];
  List<SongModel> SongsList = [];
  List<SongModel> searchResult = [];
  List<SongModel> SelectedMusic = [];

  bool loading = false;
  bool permissionDenied = false;
  bool initialized = false;
  String? errorMessage;

  int index = 0;
  int currentIndex = 0;
  String currentSongTitle = '';
  Object? Crunnetdata;

  bool get hasSongs => songs.isNotEmpty;
  bool get hasPlaylist => SongsList.isNotEmpty;

  Future<Directory> _getMusicDirectory() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final musicDirectory = Directory(
      '${appDirectory.path}/$_musicFolderName',
    );

    if (!await musicDirectory.exists()) {
      await musicDirectory.create(recursive: true);
    }

    return musicDirectory;
  }

  bool _isAudioFile(String path) {
    final extension = path.split('.').last.toLowerCase();

    return const {
      'mp3',
      'm4a',
      'aac',
      'wav',
      'ogg',
      'opus',
      'flac',
      'wma',
      'aiff',
      'aif',
      'amr',
      '3gp',
      'mp4',
    }.contains(extension);
  }

  int _stableId(String value) {
    // Deterministic ID: the same stored path produces the same ID.
    var hash = 0x811c9dc5;

    for (final unit in value.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }

    return hash == 0 ? 1 : hash;
  }

  SongModel _createSongModel(File file) {
    final path = file.path;
    final fileName = path.split(Platform.pathSeparator).last;
    final title = fileName.contains('.')
        ? fileName.substring(0, fileName.lastIndexOf('.'))
        : fileName;
    final stat = file.statSync();
    final id = _stableId(path);

    return SongModel({
      '_id': id,
      'id': id,
      '_data': path,
      'data': path,
      '_display_name': fileName,
      'display_name': fileName,
      '_size': stat.size,
      'size': stat.size,
      'title': title.isEmpty ? fileName : title,
      'artist': 'Unknown artist',
      'artist_id': -1,
      'album': '',
      'album_id': -1,
      'duration': 0,
      'date_added': stat.changed.millisecondsSinceEpoch ~/ 1000,
      'date_modified': stat.modified.millisecondsSinceEpoch ~/ 1000,
      'track': 0,
      'year': 0,
      'is_music': 1,
    });
  }

  Future<List<SongModel>> _readImportedSongs() async {
    final directory = await _getMusicDirectory();
    final result = <SongModel>[];

    await for (final entity in directory.list(followLinks: false)) {
      if (entity is! File || !_isAudioFile(entity.path)) {
        continue;
      }

      try {
        result.add(_createSongModel(entity));
      } catch (e) {
        debugPrint('[MUSIC] Skipping unreadable file ${entity.path}: $e');
      }
    }

    result.sort(
      (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    );

    return result;
  }

  /// Kept for compatibility with existing screens.
  /// File-picker access does not require broad audio-storage permission.
  Future<bool> requestStoragePermission() async {
    permissionDenied = false;
    return true;
  }

  Future<void> Initsong() async {
    await loadSongs();
  }

  /// Loads only files that the user previously imported into this app.
  /// It does not scan the entire device.
  Future<void> loadSongs() async {
    if (loading) {
      debugPrint('[MUSIC] loadSongs skipped: already loading.');
      return;
    }

    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      debugPrint('[MUSIC] Loading imported music from app storage...');

      songs = await _readImportedSongs();
      SelectedMusic = List<SongModel>.from(songs);

      await _restorePlaylist();

      searchResult = List<SongModel>.from(songs);
      initialized = true;
      permissionDenied = false;

      debugPrint('[MUSIC] Imported songs: ${songs.length}');
      debugPrint('[MUSIC] Playlist songs: ${SongsList.length}');
    } catch (e, stackTrace) {
      errorMessage = 'Could not load imported music: $e';

      debugPrint('[MUSIC] LOAD ERROR: $e');
      debugPrint('[MUSIC] STACK TRACE: $stackTrace');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Opens Android's file picker and copies selected audio into app storage.
  Future<void> pickAudioFiles() async {
    if (loading) return;

    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await FilePicker.pickFiles(
  type: FileType.audio,
  allowMultiple: true,
  withData: false,
);

      if (result == null || result.files.isEmpty) {
        debugPrint('[MUSIC] File picker cancelled.');
        return;
      }

      final directory = await _getMusicDirectory();
      var importedCount = 0;
      var failedCount = 0;

      for (final pickedFile in result.files) {
        final sourcePath = pickedFile.path;

        if (sourcePath == null || sourcePath.isEmpty) {
          failedCount++;
          debugPrint(
            '[MUSIC] No readable file path for ${pickedFile.name}.',
          );
          continue;
        }

        try {
          final source = File(sourcePath);

          if (!await source.exists()) {
            failedCount++;
            debugPrint('[MUSIC] Selected file no longer exists: $sourcePath');
            continue;
          }

          final safeName = pickedFile.name.replaceAll(
            RegExp(r'[\\/:*?"<>|]'),
            '_',
          );

          var destination = File(
            '${directory.path}/$safeName',
          );

          if (await destination.exists()) {
            final existingSize = await destination.length();

            if (existingSize != pickedFile.size) {
              final dotIndex = safeName.lastIndexOf('.');
              final baseName = dotIndex > 0
                  ? safeName.substring(0, dotIndex)
                  : safeName;
              final extension = dotIndex > 0
                  ? safeName.substring(dotIndex)
                  : '';

              destination = File(
                '${directory.path}/${baseName}_${DateTime.now().microsecondsSinceEpoch}$extension',
              );
            } else {
              // This file is already imported with the same name and size.
              importedCount++;
              continue;
            }
          }

          await source.copy(destination.path);
          importedCount++;

          debugPrint('[MUSIC] Imported: ${destination.path}');
        } catch (e) {
          failedCount++;
          debugPrint('[MUSIC] Could not import ${pickedFile.name}: $e');
        }
      }

      songs = await _readImportedSongs();
      SelectedMusic = List<SongModel>.from(songs);

      await _restorePlaylist();

      searchResult = List<SongModel>.from(songs);
      initialized = true;
      permissionDenied = false;

      if (importedCount == 0 && failedCount > 0) {
        errorMessage =
            'Could not import the selected files. Please select them again.';
      } else if (failedCount > 0) {
        errorMessage =
            'Imported $importedCount file(s); $failedCount file(s) could not be imported.';
      }

      debugPrint(
        '[MUSIC] Import finished. Imported=$importedCount, failed=$failedCount',
      );
    } catch (e, stackTrace) {
      errorMessage = 'Could not choose audio files: $e';

      debugPrint('[MUSIC] FILE PICKER ERROR: $e');
      debugPrint('[MUSIC] STACK TRACE: $stackTrace');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> _restorePlaylist() async {
    final prefs = await SharedPreferences.getInstance();

    final savedIds = prefs.getStringList(_playlistIdsKey);
    final savedTitles = prefs.getStringList(_playlistKey);

    if (savedIds != null && savedIds.isNotEmpty) {
      final ids = savedIds.toSet();

      SongsList = songs
          .where((song) => ids.contains(song.id.toString()))
          .toList();

      // If old MediaStore IDs no longer match, try the previous title format.
      if (SongsList.isNotEmpty) {
        debugPrint(
          '[MUSIC] Restored playlist by IDs: ${SongsList.length} songs.',
        );
        return;
      }
    }

    if (savedTitles != null && savedTitles.isNotEmpty) {
      final titles = savedTitles.toSet();

      SongsList = songs
          .where((song) => titles.contains(song.title))
          .toList();

      await _savePlaylist();

      debugPrint(
        '[MUSIC] Restored/migrated playlist by titles: ${SongsList.length} songs.',
      );
      return;
    }

    SongsList = [];
    debugPrint('[MUSIC] No saved playlist found.');
  }

  Future<void> _savePlaylist() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      _playlistIdsKey,
      SongsList.map((song) => song.id.toString()).toSet().toList(),
    );

    await prefs.setStringList(
      _playlistKey,
      SongsList.map((song) => song.title).toList(),
    );
  }

  Future<void> SelectMusic(SongModel song) async {
    if (SongsList.any((item) => item.id == song.id)) {
      debugPrint('[MUSIC] Song already selected: ${song.title}');
      return;
    }

    SongsList.add(song);
    await _savePlaylist();

    debugPrint('[MUSIC] Added to playlist: ${song.title}');
    notifyListeners();
  }

  Future<void> UnSelectMusic(SongModel song) async {
    SongsList.removeWhere((item) => item.id == song.id);
    await _savePlaylist();

    debugPrint('[MUSIC] Removed from playlist: ${song.title}');

    if (SongsList.isEmpty) {
      currentIndex = 0;
      currentSongTitle = '';
      index = 0;
    } else if (currentIndex >= SongsList.length) {
      updateCurrentSong(SongsList.length - 1);
      return;
    }

    notifyListeners();
  }

  Future<void> SelectMusicFile(SongModel song) async {
    await SelectMusic(song);
  }

  void addsongs() {
    searchResult = List<SongModel>.from(songs);
    notifyListeners();
  }

  void Filtercity(String enteredKeyword) {
    final query = enteredKeyword.trim().toLowerCase();

    searchResult = query.isEmpty
        ? List<SongModel>.from(songs)
        : songs.where((song) {
            return song.title.toLowerCase().contains(query) ||
                (song.artist ?? '').toLowerCase().contains(query) ||
                (song.album ?? '').toLowerCase().contains(query);
          }).toList();

    debugPrint(
      '[MUSIC] Search "$query": ${searchResult.length} matching songs.',
    );

    notifyListeners();
  }

  void setindex({
    required int value,
    required dynamic data,
  }) {
    index = value;
    Crunnetdata = data;
    notifyListeners();
  }

  void updateCurrentSong(int value) {
    if (SongsList.isEmpty) {
      currentIndex = 0;
      currentSongTitle = '';
      index = 0;
    } else {
      currentIndex = value.clamp(0, SongsList.length - 1).toInt();
      index = currentIndex;
      currentSongTitle = SongsList[currentIndex].title;
    }

    notifyListeners();
  }

  Future<usermusic?> AddNewMusic({
    required BuildContext context,
    SongModel? song,
  }) async {
    final selectedSong = song ??
        (SelectedMusic.isNotEmpty ? SelectedMusic.first : null);

    if (selectedSong == null) {
      errorMessage = 'Select a song first.';
      notifyListeners();
      return null;
    }

    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      debugPrint(
        '[MUSIC] Uploading "${selectedSong.title}" '
        'from "${selectedSong.data}"',
      );

      final result = await Musicapi().AddMusic(Music: selectedSong);

      debugPrint('[MUSIC] Upload completed successfully.');
      return result;
    } catch (e, stackTrace) {
      errorMessage = e.toString();

      debugPrint('[MUSIC] UPLOAD ERROR: $e');
      debugPrint('[MUSIC] UPLOAD STACK TRACE: $stackTrace');

      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    NameController.dispose();
    super.dispose();
  }
}
