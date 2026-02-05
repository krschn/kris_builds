#!/bin/bash

# run_patrol.sh - Run Patrol tests with common configurations
# Usage: ./scripts/run_patrol.sh [options]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
TEST_FILE=""
FLAVOR=""
DEVICE=""
TARGET="patrol_test"
VERBOSE=false
DEVELOP_MODE=false

# Print usage
usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -t, --test FILE       Run specific test file"
    echo "  -f, --flavor FLAVOR   Run with specific flavor (e.g., development, production)"
    echo "  -d, --device DEVICE   Run on specific device ID"
    echo "  -v, --verbose         Enable verbose output"
    echo "  -dev, --develop       Run in develop mode (hot restart enabled)"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Run all tests"
    echo "  $0 -t patrol_test/login_test.dart    # Run specific test"
    echo "  $0 -f development                     # Run with flavor"
    echo "  $0 -dev -t patrol_test/login_test.dart  # Develop mode"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--test)
            TEST_FILE="$2"
            shift 2
            ;;
        -f|--flavor)
            FLAVOR="$2"
            shift 2
            ;;
        -d|--device)
            DEVICE="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -dev|--develop)
            DEVELOP_MODE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            usage
            ;;
    esac
done

# Check if patrol CLI is installed
if ! command -v patrol &> /dev/null; then
    echo -e "${RED}Error: patrol CLI is not installed${NC}"
    echo "Install it with: flutter pub global activate patrol_cli"
    exit 1
fi

# Check patrol setup
echo -e "${YELLOW}Checking Patrol setup...${NC}"
patrol doctor

# Build command
CMD="patrol"

if [ "$DEVELOP_MODE" = true ]; then
    CMD="$CMD develop"
else
    CMD="$CMD test"
fi

# Add test file if specified
if [ -n "$TEST_FILE" ]; then
    CMD="$CMD -t $TEST_FILE"
fi

# Add flavor if specified
if [ -n "$FLAVOR" ]; then
    CMD="$CMD --flavor $FLAVOR"
fi

# Add device if specified
if [ -n "$DEVICE" ]; then
    CMD="$CMD -d $DEVICE"
fi

# Add verbose flag if specified
if [ "$VERBOSE" = true ]; then
    CMD="$CMD --verbose"
fi

# Run the tests
echo -e "${GREEN}Running command: $CMD${NC}"
echo ""

if eval $CMD; then
    echo ""
    echo -e "${GREEN}✅ Tests completed successfully!${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}❌ Tests failed!${NC}"
    exit 1
fi