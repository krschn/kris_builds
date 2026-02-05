#!/usr/bin/env python3
"""
setup_patrol.py - Initialize Patrol in a Flutter project

This script automates the setup of Patrol testing framework in a Flutter project.
"""

import sys
import subprocess
import os
import yaml
from pathlib import Path


def run_command(cmd, description):
    """Run a shell command and handle errors."""
    print(f"➡️  {description}...")
    try:
        result = subprocess.run(cmd, shell=True, check=True, capture_output=True, text=True)
        print(f"✅ {description} - Success")
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} - Failed")
        print(f"Error: {e.stderr}")
        return None


def check_flutter_project():
    """Check if current directory is a Flutter project."""
    if not os.path.exists('pubspec.yaml'):
        print("❌ Error: Not a Flutter project directory (pubspec.yaml not found)")
        return False
    
    with open('pubspec.yaml', 'r') as f:
        data = yaml.safe_load(f)
        if 'flutter' not in data:
            print("❌ Error: Not a Flutter project (no flutter section in pubspec.yaml)")
            return False
    
    print("✅ Flutter project detected")
    return True


def install_patrol_cli():
    """Install patrol CLI globally."""
    print("\n📦 Installing Patrol CLI...")
    result = run_command(
        "flutter pub global activate patrol_cli",
        "Install patrol_cli"
    )
    if result is None:
        return False
    
    print("\n⚠️  Make sure to add patrol to your PATH")
    print("Add this to your ~/.bashrc, ~/.zshrc, or equivalent:")
    print('export PATH="$PATH":"$HOME/.pub-cache/bin"')
    return True


def add_patrol_dependency():
    """Add patrol package to pubspec.yaml."""
    print("\n📦 Adding patrol dependency...")
    return run_command(
        "flutter pub add patrol --dev",
        "Add patrol to dev_dependencies"
    ) is not None


def get_package_info():
    """Get package name and bundle ID from user."""
    print("\n📝 Enter your app information:")
    
    app_name = input("App name (e.g., My App): ").strip()
    if not app_name:
        app_name = "My App"
    
    package_name = input("Android package name (e.g., com.example.myapp): ").strip()
    bundle_id = input("iOS bundle ID (e.g., com.example.MyApp): ").strip()
    
    return {
        'app_name': app_name,
        'android_package': package_name,
        'ios_bundle': bundle_id,
    }


def update_pubspec(info):
    """Add patrol configuration to pubspec.yaml."""
    print("\n📝 Updating pubspec.yaml with patrol configuration...")
    
    with open('pubspec.yaml', 'r') as f:
        data = yaml.safe_load(f)
    
    # Add patrol configuration
    data['patrol'] = {
        'app_name': info['app_name'],
        'android': {
            'package_name': info['android_package']
        },
        'ios': {
            'bundle_id': info['ios_bundle']
        }
    }
    
    # Check if macOS is supported
    if os.path.exists('macos'):
        macos_bundle = input("macOS bundle ID (press Enter to skip): ").strip()
        if macos_bundle:
            data['patrol']['macos'] = {'bundle_id': macos_bundle}
    
    with open('pubspec.yaml', 'w') as f:
        yaml.dump(data, f, default_flow_style=False, sort_keys=False)
    
    print("✅ pubspec.yaml updated")
    return True


def create_test_directory():
    """Create patrol_test directory."""
    print("\n📁 Creating test directory...")
    test_dir = Path('patrol_test')
    test_dir.mkdir(exist_ok=True)
    print(f"✅ Created {test_dir}")
    return test_dir


def create_example_test(test_dir):
    """Create an example test file."""
    print("\n📝 Creating example test...")
    
    example_test = test_dir / 'example_test.dart'
    
    test_content = """import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'example test - verify app loads',
    ($) async {
      // TODO: Replace with your app's main widget
      await $.pumpWidgetAndSettle(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Hello Patrol'),
            ),
          ),
        ),
      );

      expect($('Hello Patrol'), findsOneWidget);
    },
  );
}
"""
    
    with open(example_test, 'w') as f:
        f.write(test_content)
    
    print(f"✅ Created {example_test}")


def create_gitignore_entry():
    """Add test_bundle.dart to .gitignore."""
    print("\n📝 Updating .gitignore...")
    
    gitignore_entry = "patrol_test/test_bundle.dart\n"
    
    if os.path.exists('.gitignore'):
        with open('.gitignore', 'r') as f:
            content = f.read()
        
        if 'test_bundle.dart' not in content:
            with open('.gitignore', 'a') as f:
                f.write(f"\n# Patrol generated files\n{gitignore_entry}")
            print("✅ Added test_bundle.dart to .gitignore")
        else:
            print("ℹ️  test_bundle.dart already in .gitignore")
    else:
        with open('.gitignore', 'w') as f:
            f.write(gitignore_entry)
        print("✅ Created .gitignore with test_bundle.dart")


def verify_setup():
    """Verify Patrol setup."""
    print("\n🔍 Verifying Patrol setup...")
    result = run_command("patrol doctor", "Run patrol doctor")
    return result is not None


def main():
    """Main setup function."""
    print("🚀 Patrol Setup Script")
    print("=" * 50)
    
    # Check if in Flutter project
    if not check_flutter_project():
        sys.exit(1)
    
    # Install Patrol CLI
    if not install_patrol_cli():
        print("\n⚠️  Patrol CLI installation failed, but continuing...")
    
    # Add patrol dependency
    if not add_patrol_dependency():
        print("❌ Failed to add patrol dependency")
        sys.exit(1)
    
    # Get package information
    info = get_package_info()
    
    # Update pubspec.yaml
    if not update_pubspec(info):
        print("❌ Failed to update pubspec.yaml")
        sys.exit(1)
    
    # Create test directory
    test_dir = create_test_directory()
    
    # Create example test
    create_example_test(test_dir)
    
    # Update .gitignore
    create_gitignore_entry()
    
    # Verify setup
    print("\n" + "=" * 50)
    if verify_setup():
        print("\n✅ Patrol setup completed successfully!")
        print("\n📚 Next steps:")
        print("1. Complete native setup for your target platform(s)")
        print("   Android: https://patrol.leancode.co/documentation#android-setup")
        print("   iOS: https://patrol.leancode.co/documentation#ios-setup")
        print("2. Update the example test with your app's main widget")
        print("3. Run the test: patrol test -t patrol_test/example_test.dart")
    else:
        print("\n⚠️  Setup completed but verification failed")
        print("Please run 'patrol doctor' manually to check the setup")


if __name__ == '__main__':
    main()