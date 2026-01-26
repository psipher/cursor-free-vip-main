#!/usr/bin/env python3
"""
Script to re-enable the tool's update check.
"""

import os
import sys
from pathlib import Path

def enable_update_check():
    """Re-enable the update check by modifying the main.py"""
    main_py_path = Path(__file__).parent / "main.py"
    
    if not main_py_path.exists():
        print("❌ main.py not found!")
        return False
    
    try:
        # Read the current main.py content
        with open(main_py_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find the commented update check line and uncomment it
        old_line = "            # check_latest_version(translator)  # Temporarily disabled to fix update loop"
        new_line = "            check_latest_version(translator)"
        
        if old_line in content:
            new_content = content.replace(old_line, new_line)
            
            # Write the modified content back
            with open(main_py_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            
            print("✅ Update check has been re-enabled!")
            print("ℹ️  The application will now check for updates automatically again.")
            return True
        else:
            print("❌ Could not find the disabled update check line in main.py")
            return False
            
    except Exception as e:
        print(f"❌ Error modifying main.py: {e}")
        return False

if __name__ == "__main__":
    enable_update_check()