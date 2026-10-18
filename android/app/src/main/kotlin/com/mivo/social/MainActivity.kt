
package com.mivo.social

import android.content.ContentUris
import android.database.Cursor
import android.provider.MediaStore
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.mivo.social/local_music"
        private const val GET_SONGS = "getSongs"
        private const val TAG = "LocalMusic"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                GET_SONGS -> {
                    try {
                        result.success(queryLocalSongs())
                    } catch (e: Exception) {
                        Log.e(TAG, "MediaStore query failed", e)

                        result.error(
                            "MUSIC_QUERY_FAILED",
                            "Could not query Android MediaStore: ${e.message}",
                            null
                        )
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun queryLocalSongs(): List<Map<String, Any?>> {
    val volumes = listOf(
        MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
        MediaStore.Audio.Media.getContentUri(
            MediaStore.VOLUME_EXTERNAL_PRIMARY
        )
    )

    for (uri in volumes) {
        try {
            contentResolver.query(
                uri,
                arrayOf(
                    MediaStore.Audio.Media._ID,
                    MediaStore.Audio.Media.DISPLAY_NAME,
                    MediaStore.Audio.Media.TITLE
                ),
                null,
                null,
                null
            )?.use { cursor ->
                Log.d(
                    "LocalMusic",
                    "URI=$uri, rows=${cursor.count}"
                )

                if (cursor.count > 0) {
                    val songs = mutableListOf<Map<String, Any?>>()

                    while (cursor.moveToNext()) {
                        val idIndex = cursor.getColumnIndex(
                            MediaStore.Audio.Media._ID
                        )
                        val nameIndex = cursor.getColumnIndex(
                            MediaStore.Audio.Media.DISPLAY_NAME
                        )
                        val titleIndex = cursor.getColumnIndex(
                            MediaStore.Audio.Media.TITLE
                        )

                        if (idIndex < 0) continue

                        val id = cursor.getLong(idIndex)
                        val displayName = if (nameIndex >= 0) {
                            cursor.getString(nameIndex)
                        } else {
                            null
                        }
                        val title = if (titleIndex >= 0) {
                            cursor.getString(titleIndex)
                        } else {
                            null
                        }

                        val contentUri = ContentUris
                            .withAppendedId(uri, id)
                            .toString()

                        songs.add(
                            mapOf(
                                "id" to id,
                                "_id" to id,
                                "data" to contentUri,
                                "_data" to contentUri,
                                "uri" to contentUri,
                                "title" to (
                                    title
                                        ?: displayName
                                        ?: "Audio $id"
                                ),
                                "display_name" to (
                                    displayName ?: "audio_$id"
                                ),
                                "_display_name" to (
                                    displayName ?: "audio_$id"
                                )
                            )
                        )
                    }

                    Log.d(
                        "LocalMusic",
                        "Returning ${songs.size} songs from $uri"
                    )
                    return songs
                }
            } ?: Log.w(
                "LocalMusic",
                "Null cursor for $uri"
            )
        } catch (e: Exception) {
            Log.e(
                "LocalMusic",
                "Query failed for $uri",
                e
            )
        }
    }

    Log.w("LocalMusic", "No audio rows found in tested volumes")
    return emptyList()
}

    private fun Cursor.stringValue(column: String): String? {
        val index = getColumnIndex(column)

        if (index < 0 || isNull(index)) {
            return null
        }

        return getString(index)
    }

    private fun Cursor.longValue(column: String): Long? {
        val index = getColumnIndex(column)

        if (index < 0 || isNull(index)) {
            return null
        }

        return getLong(index)
    }
}
