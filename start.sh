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
    # macOS - Check for Homebrew Qt installation (prefer Qt 6, fallback to Qt 5)
    if [ -d "/opt/homebrew/opt/qt" ] || [ -d "/opt/homebrew/opt/qt6" ]; then
        # Qt 6 (preferred)
        if [ -d "/opt/homebrew/opt/qt" ]; then
            export PATH="/opt/homebrew/opt/qt/bin:$PATH"
            export DYLD_LIBRARY_PATH="/opt/homebrew/opt/qt/lib:$DYLD_LIBRARY_PATH"
            export QT_PLUGIN_PATH="/opt/homebrew/opt/qt/plugins"
            echo "Using Qt 6 from Homebrew"
        elif [ -d "/opt/homebrew/opt/qt6" ]; then
            export PATH="/opt/homebrew/opt/qt6/bin:$PATH"
            export DYLD_LIBRARY_PATH="/opt/homebrew/opt/qt6/lib:$DYLD_LIBRARY_PATH"
            export QT_PLUGIN_PATH="/opt/homebrew/opt/qt6/plugins"
            echo "Using Qt 6 from Homebrew"
        fi
    elif [ -d "/opt/homebrew/opt/qt@5" ]; then
        # Qt 5 fallback
        export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
        export DYLD_LIBRARY_PATH="/opt/homebrew/opt/qt@5/lib:$DYLD_LIBRARY_PATH"
        export QT_PLUGIN_PATH="/opt/homebrew/opt/qt@5/plugins"
        echo "Using Qt 5 from Homebrew"
    elif [ -d "/usr/local/opt/qt" ] || [ -d "/usr/local/opt/qt6" ]; then
        # Qt 6 (Intel Mac)
        if [ -d "/usr/local/opt/qt" ]; then
            export PATH="/usr/local/opt/qt/bin:$PATH"
            export DYLD_LIBRARY_PATH="/usr/local/opt/qt/lib:$DYLD_LIBRARY_PATH"
            export QT_PLUGIN_PATH="/usr/local/opt/qt/plugins"
            echo "Using Qt 6 from Homebrew (Intel)"
        elif [ -d "/usr/local/opt/qt6" ]; then
            export PATH="/usr/local/opt/qt6/bin:$PATH"
            export DYLD_LIBRARY_PATH="/usr/local/opt/qt6/lib:$DYLD_LIBRARY_PATH"
            export QT_PLUGIN_PATH="/usr/local/opt/qt6/plugins"
            echo "Using Qt 6 from Homebrew (Intel)"
        fi
    elif [ -d "/usr/local/opt/qt@5" ]; then
        # Qt 5 fallback (Intel Mac)
        export PATH="/usr/local/opt/qt@5/bin:$PATH"
        export DYLD_LIBRARY_PATH="/usr/local/opt/qt@5/lib:$DYLD_LIBRARY_PATH"
        export QT_PLUGIN_PATH="/usr/local/opt/qt@5/plugins"
        echo "Using Qt 5 from Homebrew (Intel)"
    elif [ -d "$HOME/Qt" ]; then
        # Try to find Qt in user's home directory (prefer Qt 6)
        QT_VERSIONS=$(ls "$HOME/Qt" | grep -E "^[0-9]" | sort -V -r)
        QT_FOUND=0
        for QT_VERSION in $QT_VERSIONS; do
            QT_DIR="$HOME/Qt/$QT_VERSION"
            if [ -d "$QT_DIR/clang_64" ]; then
                export PATH="$QT_DIR/clang_64/bin:$PATH"
                export DYLD_LIBRARY_PATH="$QT_DIR/clang_64/lib:$DYLD_LIBRARY_PATH"
                export QT_PLUGIN_PATH="$QT_DIR/clang_64/plugins"
                echo "Using Qt $QT_VERSION from $QT_DIR"
                QT_FOUND=1
                break
            fi
        done
        if [ "$QT_FOUND" -eq 0 ]; then
            echo "Warning: No Qt installation found in $HOME/Qt"
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
    # Linux - Check common Qt installation paths (prefer Qt 6, fallback to Qt 5)
    if [ -d "/usr/lib/qt6" ]; then
        export LD_LIBRARY_PATH="/usr/lib/qt6/lib:$LD_LIBRARY_PATH"
        export QT_PLUGIN_PATH="/usr/lib/qt6/plugins"
        echo "Using Qt 6 from system"
    elif [ -d "/usr/lib/x86_64-linux-gnu/qt6" ]; then
        export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/qt6/lib:$LD_LIBRARY_PATH"
        export QT_PLUGIN_PATH="/usr/lib/x86_64-linux-gnu/qt6/plugins"
        echo "Using Qt 6 from system (x86_64)"
    elif [ -d "/usr/lib/qt5" ]; then
        export LD_LIBRARY_PATH="/usr/lib/qt5/lib:$LD_LIBRARY_PATH"
        export QT_PLUGIN_PATH="/usr/lib/qt5/plugins"
        echo "Using Qt 5 from system"
    elif [ -d "/usr/lib/x86_64-linux-gnu/qt5" ]; then
        export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/qt5/lib:$LD_LIBRARY_PATH"
        export QT_PLUGIN_PATH="/usr/lib/x86_64-linux-gnu/qt5/plugins"
        echo "Using Qt 5 from system (x86_64)"
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

