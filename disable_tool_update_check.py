#!/usr/bin/env python3
"""
Quick script to disable the tool's update check to prevent the infinite update loop.
"""

import os
import sys
from pathlib import Path

def disable_update_check():
    """Disable the update check by modifying the main.py temporarily"""
    main_py_path = Path(__file__).parent / "main.py"
    
    if not main_py_path.exists():
        print("❌ main.py not found!")
        return False
    
    try:
        # Read the current main.py content
        with open(main_py_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find the update check line and comment it out
        old_line = "            check_latest_version(translator)"
        new_line = "            # check_latest_version(translator)  # Temporarily disabled to fix update loop"
        
        if old_line in content:
            new_content = content.replace(old_line, new_line)
            
            # Write the modified content back
            with open(main_py_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            
            print("✅ Update check has been disabled!")
            print("ℹ️  The application will no longer check for updates automatically.")
            print("ℹ️  You can re-enable it by running: enable_tool_update_check.py")
            return True
        else:
            print("❌ Could not find the update check line in main.py")
            return False
            
    except Exception as e:
        print(f"❌ Error modifying main.py: {e}")
        return False

if __name__ == "__main__":
    disable_update_check()