import os
import re
import sys

def migrate_youtube_video(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Only process files that have video_player import
    if "import 'package:video_player/video_player.dart';" not in content:
        return False

    original_content = content

    # 1. Update the import
    content = content.replace(
        "import 'package:video_player/video_player.dart';",
        "import 'package:youtube_player_iframe/youtube_player_iframe.dart';"
    )

    # 2. Add an import for foundation if it isn't there
    if "import 'package:flutter/foundation.dart';" not in content:
        content = content.replace(
            "import 'package:flutter/material.dart';",
            "import 'package:flutter/material.dart';\nimport 'package:flutter/foundation.dart';"
        )

    # 3. Replace the URL constant with the Youtube Video ID
    # Pattern looks for String videoUrl = 'https://firebasestorage...';
    url_pattern = r"(const\s+)?String(\s+\w+)?\s*videoUrl\s*=\s*('[^']+'|\"[^\"]+\");"
    
    # Example generic constitution video
    placeholder_youtube_id = '1b-b3P0E5C4' 
    
    content = re.sub(
        url_pattern, 
        f"const String youtubeVideoId = '{placeholder_youtube_id}';", 
        content
    )

    # 4. Replace VideoPlayerController with YoutubePlayerController
    content = content.replace('late VideoPlayerController _controller;', 'late YoutubePlayerController _controller;')
    content = content.replace('VideoPlayerController _controller', 'YoutubePlayerController _controller')
    
    # 5. Replace Initialization Logic inside _loadVideo or similar
    # The logic usually looks like:
    # _controller = VideoPlayerController.network(videoUrl)
    #   ..initialize().then((_) {
    #     setState(() {
    #       _isVideoLoaded = true;
    #     }); ... });
    
    init_pattern = r"_controller\s*=\s*VideoPlayerController\.network(?:Url)?\([^)]+\)[^}]+\}\)[^;]*;"
    
    youtube_init = """_controller = YoutubePlayerController.fromVideoId(
      videoId: youtubeVideoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    setState(() {
      _isVideoLoaded = true;
    });"""

    content = re.sub(init_pattern, youtube_init, content)

    # Clean up any leftover listeners if they exist separately
    content = re.sub(r"_controller\.addListener\([^;]+;\s*\}\);", "", content)

    # 6. Adjust Dispose logic
    # The old logic has _controller.dispose(); 
    # For youtube_player_iframe, dispose is replaced with close
    content = content.replace('_controller.dispose();', '_controller.close();')

    # 7. Replace the VideoPlayer Widget with YoutubePlayer
    widget_pattern = r"AspectRatio\s*\([^)]+\bchild:\s*VideoPlayer\(_controller\),?\s*\)"
    
    youtube_widget = """YoutubePlayer(
                          controller: _controller,
                          aspectRatio: 16 / 9,
                        )"""
    
    content = re.sub(widget_pattern, youtube_widget, content)
    
    # There's also sometimes a check for aspect ratio inside a Center that has to be replaced
    if "VideoPlayer(_controller)" in content:
         content = content.replace("VideoPlayer(_controller)", "YoutubePlayer(controller: _controller)")

    # 8. Adjust the Play/Pause floating action button because youtube interface is async
    content = content.replace('_controller.value.isPlaying', '_controller.value.playerState == PlayerState.playing')
    content = content.replace('Icons.pause : Icons.play_arrow', 'Icons.close : Icons.play_arrow') # Floating icon is mostly useless with embedded iframe controls
    
    # Usually floating player is hard to sync perfectly without async/await for YoutubeIframe
    # Let's just remove the floatingActionButton completely by replacing it with null if it depends on isPlaying
    fab_pattern = r"floatingActionButton:\s*_isVideoLoaded\s*\?\s*FloatingActionButton\([^;]+icons\.play_arrow[^;]+,\s*\)\s*:\s*null"
    content = re.sub(fab_pattern, "floatingActionButton: null", content)

    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False

def main():
    lib_dir = "d:\\ROICONSI-main\\roi_app\\lib"
    modified_count = 0
    for root, _, files in os.walk(lib_dir):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                try:
                    if migrate_youtube_video(file_path):
                        modified_count += 1
                        print(f"Migrated: {file_path}")
                except Exception as e:
                    print(f"Error migrating {file_path}: {e}")
    
    print(f"Total files migrated: {modified_count}")

if __name__ == "__main__":
    main()
