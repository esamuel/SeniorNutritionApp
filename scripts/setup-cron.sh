#!/bin/bash

# Setup script for automated blog generation cron job

PROJECT_DIR="/Users/samueleskenasy/Documents/SeniorNutritionApp"
SCRIPT_PATH="$PROJECT_DIR/scripts/generate-blog.js"
LOG_DIR="$PROJECT_DIR/logs"

# Create logs directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Create the cron job entry
CRON_JOB="0 10 */3 * * cd $PROJECT_DIR && node $SCRIPT_PATH >> $LOG_DIR/blog-generation.log 2>&1"

echo "Setting up automated blog generation..."
echo "📁 Project Directory: $PROJECT_DIR"
echo "⏰ Schedule: Every 3 days at 10:00 AM"
echo "📝 Logs: $LOG_DIR/blog-generation.log"
echo ""

# Check if cron job already exists
if crontab -l 2>/dev/null | grep -q "$SCRIPT_PATH"; then
    echo "⚠️  Cron job already exists for this script."
    echo "Current cron jobs:"
    crontab -l | grep "$SCRIPT_PATH"
    echo ""
    read -p "Do you want to replace it? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Remove existing cron job for this script
        crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH" | crontab -
        echo "✅ Removed existing cron job"
    else
        echo "❌ Setup cancelled"
        exit 1
    fi
fi

# Add the new cron job
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

echo "✅ Cron job added successfully!"
echo ""
echo "📅 Your blog will auto-generate every 3 days at 10:00 AM"
echo "📂 New posts will be saved to: src/app/blog/posts/"
echo "📜 Logs will be saved to: $LOG_DIR/blog-generation.log"
echo ""
echo "🔧 Management commands:"
echo "  View cron jobs:    crontab -l"
echo "  Remove cron job:   crontab -e (then delete the line)"
echo "  View logs:         tail -f $LOG_DIR/blog-generation.log"
echo "  Test manually:     node $SCRIPT_PATH"
echo ""
echo "⚠️  Important: Make sure Ollama is running for the script to work:"
echo "  ollama serve"