import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:ahlachat/util/Localization.dart';

import '../../../viewmodels/Music_Viewmodel/MusicViewmodel.dart';
import '../../../viewmodels/Agora_ViewModel/AgoraViewmodel.dart';

class SelectMusicScrean extends StatefulWidget {
  const SelectMusicScrean({super.key});

  @override
  State<SelectMusicScrean> createState() => _SelectMusicScreanState();
}

class _SelectMusicScreanState extends State<SelectMusicScrean> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final music = context.read<MusicViewModel>();

      if (!music.initialized && !music.loading) {
        music.loadSongs();
      } else {
        music.addsongs();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles(MusicViewModel music) async {
    await music.pickAudioFiles();

    if (!mounted) return;

    // Reset search so newly imported songs are visible.
    _searchController.clear();
    music.Filtercity('');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MusicViewModel, AgoraViewmodel>(
      builder: (context, music, agora, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF10152B),
          appBar: AppBar(
            title: Text(
              getLang(context: context, key: 'Choose_music'),
            ),
            backgroundColor: const Color(0xFF10152B),
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                tooltip: getLang(
                  context: context,
                  key: 'Browse_audio_files',
                ),
                onPressed: music.loading ? null : () => _pickFiles(music),
                icon: const Icon(Icons.audio_file),
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
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: music.Filtercity,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: getLang(
                      context: context,
                      key: 'Search_songs_artists_albums',
                    ),
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white70,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        music.Filtercity('');
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white70,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1A2038),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FilledButton.icon(
                    onPressed: music.loading ? null : () => _pickFiles(music),
                    icon: const Icon(Icons.folder_open),
                    label: Text(
                      getLang(
                        context: context,
                        key: 'Browse_audio_files',
                      ),
                    ),
                  ),
                ),
              ),
              if (music.loading) const LinearProgressIndicator(),
              if (music.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    music.errorMessage!,
                    style: const TextStyle(color: Colors.orangeAccent),
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: music.loading && music.searchResult.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : music.searchResult.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.library_music_outlined,
                                    size: 56,
                                    color: Colors.white38,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    music.songs.isEmpty
                                        ? getLang(
                                            context: context,
                                            key: 'No_imported_songs',
                                          )
                                        : getLang(
                                            context: context,
                                            key: 'No_matching_songs',
                                          ),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (music.songs.isEmpty) ...[
                                    const SizedBox(height: 16),
                                    FilledButton.icon(
                                      onPressed: music.loading
                                          ? null
                                          : () => _pickFiles(music),
                                      icon: const Icon(Icons.folder_open),
                                      label: Text(
                                        getLang(
                                          context: context,
                                          key: 'Choose_audio_files',
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: music.searchResult.length,
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              color: Colors.white12,
                            ),
                            itemBuilder: (context, index) {
                              final song = music.searchResult[index];

                              final isAdded = music.SongsList.any(
                                (item) => item.id == song.id,
                              );

                              final isPlaying =
                                  agora.PlaySong.contains(song.title);

                              return ListTile(
                                leading: QueryArtworkWidget(
                                  id: song.id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: const CircleAvatar(
                                    backgroundColor: Color(0xFF242D4A),
                                    child: Icon(
                                      Icons.music_note,
                                      color: Colors.white70,
                                    ),
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
                                    key: isAdded
                                        ? 'Remove_from_playlist'
                                        : 'Add_to_playlist',
                                  ),
                                  onPressed: () async {
                                    if (isAdded) {
                                      await music.UnSelectMusic(song);
                                    } else {
                                      await music.SelectMusic(song);
                                    }
                                  },
                                  icon: Icon(
                                    isAdded
                                        ? Icons.check_circle
                                        : Icons.add_circle_outline,
                                    color: isAdded
                                        ? Colors.tealAccent
                                        : Colors.white70,
                                    size: 28,
                                  ),
                                ),
                              );
                            },
                          ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.done),
                      label: Text(
                        '${getLang(context: context, key: 'Done')} '
                        '(${music.SongsList.length} '
                        '${getLang(context: context, key: 'Songs_in_playlist')})',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}