import os
import re

def fix_imports(dir_path):
    modified = 0
    for root, _, files in os.walk(dir_path):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()

                    # Nucleus Lite files import their own internal files using: package:nucleus_ui_app/...
                    # Our app's pubspec name is `login_signup`. Let's fix the imports.
                    new_content = content.replace(
                        "package:nucleus_ui_app/config/",
                        "package:login_signup/nucleus_config/"
                    ).replace(
                        "package:nucleus_ui_app/helper/",
                        "package:login_signup/nucleus_helper/"
                    ).replace(
                        "package:nucleus_ui_app/ui_features/components/",
                        "package:login_signup/nucleus_components/"
                    )

                    if content != new_content:
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        modified += 1
                        print(f"Patched: {file_path}")
                except Exception as e:
                    print(f"Error reading {file_path}: {e}")

    print(f"Total files patched: {modified}")

if __name__ == "__main__":
    targets = [
        "d:\\ROICONSI-main\\roi_app\\lib\\nucleus_config",
        "d:\\ROICONSI-main\\roi_app\\lib\\nucleus_helper",
        "d:\\ROICONSI-main\\roi_app\\lib\\nucleus_components"
    ]
    for t in targets:
        fix_imports(t)
