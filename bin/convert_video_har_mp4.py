#!/usr/bin/env python3

import json, base64

import argparse
from pathlib import Path

def existing_file(value: str) -> Path:
    path = Path(value)
    if not path.is_file():
        raise argparse.ArgumentTypeError(f"{value!r} is not an existing file")
    return path

def main() -> None:
    parser = argparse.ArgumentParser(description="Process a file.")
    parser.add_argument("filename", type=existing_file, help="path to an existing file")
    args = parser.parse_args()

    # args.filename is a validated Path object
    print(f"Reading {args.filename}")

    # har_file = 'video.har'
    # output_file = 'extracted_video.mp4'
    #
    har_file = args.filename
    output_file = f"{args.filename}.mp4"

    #
    with open(har_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    with open(output_file, 'wb') as out:
        for entry in data['log']['entries']:
            mime = entry['response']['content'].get('mimeType', '')
            # Filter for typical video media types
            if 'video' in mime or 'mp4' in mime or 'octet-stream' in mime:
                content = entry['response']['content']
                if 'text' in content:
                    text = content['text']
                    if content.get('encoding') == 'base64':
                        out.write(base64.b64decode(text))
                    else:
                        out.write(text.encode('utf-8'))

    print('Extraction complete! Output saved as:', output_file)

if __name__ == "__main__":
    main()

#-eof