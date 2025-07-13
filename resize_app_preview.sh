#!/bin/bash

# App Store Preview Video Resizer
# Resizes iPad simulator recordings to App Store requirements

echo "🎬 App Store Preview Video Resizer"
echo "=================================="

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input_video_file>"
    echo "Example: $0 ipad_recording.mov"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${INPUT_FILE%.*}_app_store_preview.mov"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "❌ Error: Input file '$INPUT_FILE' not found"
    exit 1
fi

# Check if ffmpeg is available
if ! command -v ffmpeg &> /dev/null; then
    echo "❌ Error: ffmpeg is not installed"
    echo "Install with: brew install ffmpeg"
    exit 1
fi

echo "📱 Input file: $INPUT_FILE"
echo "📱 Output file: $OUTPUT_FILE"
echo ""

# Get input video dimensions
echo "🔍 Analyzing input video..."
INPUT_INFO=$(ffmpeg -i "$INPUT_FILE" 2>&1 | grep "Video:")
echo "Input video info: $INPUT_INFO"

# Resize video to App Store preview dimensions
echo ""
echo "🎯 Resizing to App Store preview dimensions (1200x1600)..."
echo "This may take a moment..."

ffmpeg -i "$INPUT_FILE" \
    -vf "scale=1200:1600:force_original_aspect_ratio=decrease,pad=1200:1600:(ow-iw)/2:(oh-ih)/2:color=black,setsar=1" \
    -c:a copy \
    -y \
    "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Success! App Store preview video created:"
    echo "📁 $OUTPUT_FILE"
    echo ""
    echo "📏 Video dimensions: 1200 x 1600 pixels"
    echo "🎬 Ready for App Store Connect upload!"
else
    echo ""
    echo "❌ Error: Failed to resize video"
    exit 1
fi 