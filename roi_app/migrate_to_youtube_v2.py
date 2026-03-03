import os
import re

PLACEHOLDER_ID = '1b-b3P0E5C4'

def get_title(content):
    """Extract the AppBar title from the original file."""
    m = re.search(r"title:\s*Text\('([^']+)'\)", content)
    return m.group(1) if m else 'Video'

def get_description(content):
    """Extract the description text from the original file."""
    m = re.search(r"AlertDialog\([^)]+content:\s*Text\(\s*'([^']+)'", content, re.DOTALL)
    return m.group(1) if m else 'No description available.'

def get_class_names(content):
    """Extract the StatefulWidget class name and State class name."""
    widget = re.search(r'class\s+(\w+)\s+extends\s+StatefulWidget', content)
    state = re.search(r'class\s+(\w+)\s+extends\s+State<', content)
    return (widget.group(1) if widget else 'VideoScreen', 
            state.group(1) if state else '_VideoScreenState')

def get_youtube_id(content):
    """Try to find any existing youtube ID or fall back to placeholder."""
    m = re.search(r"youtubeVideoId\s*=\s*'([^']+)'", content)
    return m.group(1) if m else PLACEHOLDER_ID

def rewrite_video_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Only process files that have video_player or youtube_player_iframe
    if ('video_player' not in content and 'youtube_player_iframe' not in content):
        return False

    title = get_title(content)
    description = get_description(content)
    widget_class, state_class = get_class_names(content)
    youtube_id = get_youtube_id(content)

    new_content = f"""import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

const String youtubeVideoId = '{youtube_id}';

class {widget_class} extends StatefulWidget {{
  @override
  {state_class} createState() => {state_class}();
}}

class {state_class} extends State<{widget_class}> {{
  late YoutubePlayerController _controller;
  bool _isVideoLoaded = false;

  @override
  void initState() {{
    super.initState();
  }}

  void _loadVideo() {{
    _controller = YoutubePlayerController.fromVideoId(
      videoId: youtubeVideoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    setState(() {{
      _isVideoLoaded = true;
    }});
  }}

  void _showDescriptionDialog() {{
    showDialog(
      context: context,
      builder: (BuildContext context) {{
        return AlertDialog(
          title: Text('Video Description'),
          content: Text(
            '{description}',
          ),
          actions: [
            TextButton(
              onPressed: () {{
                Navigator.of(context).pop();
              }},
              child: Text('Close'),
            ),
          ],
        );
      }},
    );
  }}

  @override
  void dispose() {{
    if (_isVideoLoaded) {{
      _controller.close();
    }}
    super.dispose();
  }}

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(
        title: Text('{title}'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {{
            Navigator.pop(context);
          }},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: _showDescriptionDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg4.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: !_isVideoLoaded
                      ? ElevatedButton(
                          onPressed: _loadVideo,
                          child: Text('Play Video'),
                        )
                      : YoutubePlayer(
                          controller: _controller,
                          aspectRatio: 16 / 9,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: null,
    );
  }}
}}
"""

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    return True


def main():
    lib_dir = "d:\\ROICONSI-main\\roi_app\\lib"
    modified_count = 0
    errors = []
    for root, _, files in os.walk(lib_dir):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    if 'video_player' in content or 'youtube_player_iframe' in content:
                        if rewrite_video_file(file_path):
                            modified_count += 1
                            print(f"Rewritten: {file_path}")
                except Exception as e:
                    errors.append(f"Error on {file_path}: {e}")
                    print(f"ERROR: {file_path}: {e}")

    print(f"\nTotal files rewritten: {modified_count}")
    if errors:
        print("Errors:")
        for e in errors:
            print(e)

if __name__ == "__main__":
    main()
