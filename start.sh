#!/bin/bash
# qModMaster Start Script for macOS and Linux
# This script detects the platform and sets up the environment accordingly

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Detect operating system
OS="$(uname -s)"
case "${OS}" in
    Linux*)     PLATFORM="linux";;
    Darwin*)    PLATFORM="macos";;
    *)          PLATFORM="unknown"
esac

echo "Detected platform: $PLATFORM"
echo "Starting qModMaster..."

# Set up Qt paths based on platform
if [ "$PLATFORM" = "macos" ]; then
    # macOS - Check for Homebrew Qt installation
    if [ -d "/opt/homebrew/opt/qt@5" ]; then
        export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
        export DYLD_LIBRARY_PATH="/opt/homebrew/opt/qt@5/lib:$DYLD_LIBRARY_PATH"
        export QT_PLUGIN_PATH="/opt/homebrew/opt/qt@5/plugins"
    elif [ -d "/usr/local/opt/qt@5" ]; then
        export PATH="/usr/local/opt/qt@5/bin:$PATH"
        export DYLD_LIBRARY_PATH="/usr/local/opt/qt@5/lib:$DYLD_LIBRARY_PATH"
        export QT_PLUGIN_PATH="/usr/local/opt/qt@5/plugins"
    elif [ -d "$HOME/Qt" ]; then
        # Try to find Qt in user's home directory
        QT_VERSION=$(ls "$HOME/Qt" | grep -E "^[0-9]" | head -1)
        if [ -n "$QT_VERSION" ]; then
            QT_DIR="$HOME/Qt/$QT_VERSION"
            if [ -d "$QT_DIR/clang_64" ]; then
                export PATH="$QT_DIR/clang_64/bin:$PATH"
                export DYLD_LIBRARY_PATH="$QT_DIR/clang_64/lib:$DYLD_LIBRARY_PATH"
                export QT_PLUGIN_PATH="$QT_DIR/clang_64/plugins"
            fi
        fi
    fi
    
    # Start macOS app bundle
    if [ -f "qModMaster.app/Contents/MacOS/qModMaster" ]; then
        open qModMaster.app
    elif [ -f "qModMaster" ]; then
        ./qModMaster
    else
        echo "Error: qModMaster executable not found!"
        echo "Please build the project first using: qmake && make"
        exit 1
    fi

elif [ "$PLATFORM" = "linux" ]; then
    # Linux - Check common Qt installation paths
    if [ -d "/usr/lib/qt5" ]; then
        export LD_LIBRARY_PATH="/usr/lib/qt5/lib:$LD_LIBRARY_PATH"
        export QT_PLUGIN_PATH="/usr/lib/qt5/plugins"
    elif [ -d "/usr/lib/x86_64-linux-gnu/qt5" ]; then
        export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/qt5/lib:$LD_LIBRARY_PATH"
        export QT_PLUGIN_PATH="/usr/lib/x86_64-linux-gnu/qt5/plugins"
    fi
    
    # Start Linux executable
    if [ -f "qModMaster" ]; then
        ./qModMaster
    else
        echo "Error: qModMaster executable not found!"
        echo "Please build the project first using: qmake && make"
        exit 1
    fi

else
    echo "Error: Unsupported platform: $OS"
    exit 1
fi

