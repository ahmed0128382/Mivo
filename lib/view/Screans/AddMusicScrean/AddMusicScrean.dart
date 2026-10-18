import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ahlachat/util/Localization.dart';

import '../../../viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import '../../../viewmodels/Music_Viewmodel/MusicViewmodel.dart';
import 'SelectMusicList.dart';

class AddMusicScrean extends StatefulWidget {
  const AddMusicScrean({super.key});

  @override
  State<AddMusicScrean> createState() => _AddMusicScreanState();
}

class _AddMusicScreanState extends State<AddMusicScrean> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final music = context.read<MusicViewModel>();

      if (!music.initialized && !music.loading) {
        music.loadSongs();
      }
    });
  }

  Future<void> _openSongPicker() async {
    final music = context.read<MusicViewModel>();

    if (!music.initialized && !music.loading) {
      await music.loadSongs();
    }

    if (!mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SelectMusicScrean(),
      ),
    );
  }

  Future<void> _playSong(
    BuildContext context,
    MusicViewModel music,
    AgoraViewmodel agora,
    int index,
  ) async {
    if (index < 0 || index >= music.SongsList.length) return;

    final song = music.SongsList[index];

    try {
      await agora.StartAudioMexing(
        filePath: song.data,
        duration: song.duration ?? 0,
        tittle: song.title,
        indexsong: index,
      );

      if (!context.mounted) return;

      if (!agora.isAudioMixingActive) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              getLang(
                context: context,
                key: 'Audio_playback_failed',
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${getLang(context: context, key: 'Could_not_play_song')}: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MusicViewModel, AgoraViewmodel>(
      builder: (context, music, agora, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF10152B),
          appBar: AppBar(
            title: Text(
              getLang(context: context, key: 'Music_Playlist'),
            ),
            backgroundColor: const Color(0xFF10152B),
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                tooltip: getLang(
                  context: context,
                  key: 'Add_songs_from_files',
                ),
                onPressed: music.loading ? null : _openSongPicker,
                icon: const Icon(Icons.add),
              ),
              IconButton(
                tooltip: getLang(
                  context: context,
                  key: 'Refresh_imported_music',
                ),
                onPressed: music.loading ? null : music.loadSongs,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: music.loading && !music.initialized
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    if (music.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          music.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.queue_music,
                            color: Colors.tealAccent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${music.SongsList.length} '
                              '${getLang(context: context, key: 'Songs_in_playlist')}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (music.SongsList.isNotEmpty)
                            TextButton.icon(
                              onPressed: () async {
                                await _playSong(
                                  context,
                                  music,
                                  agora,
                                  0,
                                );
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: Text(
                                getLang(
                                  context: context,
                                  key: 'Play_first',
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white12),
                    Expanded(
                      child: music.SongsList.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.library_music_outlined,
                                      size: 64,
                                      color: Colors.white38,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      getLang(
                                        context: context,
                                        key: 'Playlist_empty',
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      getLang(
                                        context: context,
                                        key: 'Choose_audio_description',
                                      ),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    FilledButton.icon(
                                      onPressed: music.loading
                                          ? null
                                          : _openSongPicker,
                                      icon: const Icon(Icons.folder_open),
                                      label: Text(
                                        getLang(
                                          context: context,
                                          key: 'Choose_audio_files',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: music.SongsList.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 1,
                                color: Colors.white12,
                              ),
                              itemBuilder: (context, index) {
                                final song = music.SongsList[index];

                                final isPlaying =
                                    agora.PlaySong.contains(song.title) &&
                                        agora.playmusic;

                                return ListTile(
                                  onTap: () => _playSong(
                                    context,
                                    music,
                                    agora,
                                    index,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFF242D4A),
                                    child: Icon(
                                      isPlaying
                                          ? Icons.graphic_eq
                                          : Icons.music_note,
                                      color: isPlaying
                                          ? Colors.tealAccent
                                          : Colors.white70,
                                    ),
                                  ),
                                  title: Text(
                                    song.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isPlaying
                                          ? Colors.tealAccent
                                          : Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    song.artist?.trim().isNotEmpty == true
                                        ? song.artist!
                                        : getLang(
                                            context: context,
                                            key: 'Unknown_artist',
                                          ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    tooltip: getLang(
                                      context: context,
                                      key: 'Remove_from_playlist',
                                    ),
                                    onPressed: () async {
                                      if (isPlaying) {
                                        await agora.stopAudioMexing(context);
                                      }

                                      await music.UnSelectMusic(song);
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.white54,
                                    ),
                                  ),
                                );
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