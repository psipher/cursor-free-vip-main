"""
Version management utility for Cursor Free VIP
Automatically detects version from git tags, with fallbacks
"""
import os
import subprocess
import logging

logger = logging.getLogger(__name__)

def get_version():
    """
    Get version automatically in this priority order:
    1. Git tag (most reliable for releases)
    2. Environment variable (for CI/CD)
    3. .env fallback (for build scripts)
    4. Hardcoded fallback (last resort)
    """
    # Try git tag first (best practice)
    try:
        result = subprocess.run(
            ['git', 'describe', '--tags', '--exact-match'],
            capture_output=True,
            text=True,
            cwd=os.path.dirname(__file__),
            timeout=5
        )
        if result.returncode == 0 and result.stdout.strip():
            git_version = result.stdout.strip()
            if git_version.startswith('v'):
                git_version = git_version[1:]
            return git_version
    except (subprocess.TimeoutExpired, subprocess.SubprocessError, FileNotFoundError):
        pass
    
    # Try environment variable
    env_version = os.getenv('VERSION')
    if env_version:
        return env_version
    
    # Try .env fallback
    try:
        env_file = os.path.join(os.path.dirname(__file__), '.env')
        if os.path.exists(env_file):
            with open(env_file, 'r', encoding='utf-8') as f:
                for line in f:
                    line = line.strip()
                    if line.startswith('VERSION_FALLBACK='):
                        return line.split('=', 1)[1].strip()
    except Exception:
        pass
    
    # Final fallback
    return "1.11.05"

# Export version
version = get_version()