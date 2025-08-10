#!/bin/bash

# Script to start Ollama for real iOS device testing
# This allows your iPhone to connect to Ollama running on your Mac

echo "🚀 Starting Ollama for real device testing..."

# Stop any existing Ollama process
echo "🛑 Stopping existing Ollama processes..."
pkill ollama

# Wait a moment
sleep 2

# Get Mac's IP address
MAC_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
echo "📱 Your Mac's IP address: $MAC_IP"

# Start Ollama listening on all interfaces
echo "🌐 Starting Ollama server (listening on all interfaces)..."
export OLLAMA_HOST=0.0.0.0:11434
ollama serve &

# Wait for startup
sleep 3

# Test connection
echo "🧪 Testing connection..."
if curl -s http://$MAC_IP:11434/api/tags > /dev/null; then
    echo "✅ Ollama is ready for iOS device testing!"
    echo "📍 Your iPhone can now connect to: http://$MAC_IP:11434"
    echo ""
    echo "🔧 Next steps:"
    echo "   1. Make sure your iPhone and Mac are on the same WiFi network"
    echo "   2. Update the app code to use: $MAC_IP:11434"
    echo "   3. Build and run the app on your iPhone"
    echo ""
    echo "💡 To stop: pkill ollama"
else
    echo "❌ Failed to start Ollama for device testing"
    echo "🔧 Try running manually: OLLAMA_HOST=0.0.0.0:11434 ollama serve"
fi

echo "🏃‍♂️ Ollama is running in the background..."