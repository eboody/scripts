#!/bin/bash

# Function to cleanup and exit
cleanup() {
    echo "Stopping FFmpeg..."
    kill $FFMPEG_PID 2>/dev/null
    exit 0
}

# Function to copy the temporary image to the final image if it's valid
update_image() {
    if [ -f "temp_out.jpg" ]; then
        if file temp_out.jpg | grep -q "JPEG image data"; then
            mv temp_out.jpg out.jpg
            echo "Image updated: $(date)"
        else
            echo "Invalid image file, skipping update"
        fi
    fi
}

# Set up trap to catch SIGINT (Ctrl+C) and SIGTERM
trap cleanup SIGINT SIGTERM

# Delete existing out.jpg and temp_out.jpg if they exist
rm -f out.jpg temp_out.jpg

# Run FFmpeg command
echo "Starting FFmpeg..."
ffmpeg -rtsp_transport tcp -i rtsp://192.168.1.48/h264 -vf fps=1 -update 1 temp_out.jpg &

# Save the PID of the FFmpeg process
FFMPEG_PID=$!

# Main loop
while true; do
    # Wait for a short period
    sleep 1

    # Update the image
    update_image

    # Optional: Add your image processing code here
    # For example: process_image out.jpg
done

# Wait for FFmpeg to finish (this line will not be reached in normal operation)
wait $FFMPEG_PID
