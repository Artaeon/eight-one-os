#!/bin/bash
# build-iso-docker.sh
# Build the EIGHT.ONE OS ISO using Docker on any Linux system.

# Ensure we are in the project root
ROOT_DIR=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
cd "$ROOT_DIR"

# Parameters
WORKDIR="/tmp/archiso-work"
OUTDIR="$ROOT_DIR/holy-iso/out"
PROFILE_DIR="holy-iso"

# Ensure output directory exists (on host)
mkdir -p "$OUTDIR"

echo "--- Building EIGHT.ONE OS ISO via Docker ---"

# Run build in a privileged container
docker run --rm --privileged \
    -v "$ROOT_DIR:/workspace" \
    -v "/tmp:/tmp" \
    -w /workspace \
    archlinux:latest \
    /bin/bash -c "
        pacman -Syu --noconfirm && \
        pacman -S --noconfirm archiso git && \
        cd /workspace/$PROFILE_DIR && \
        mkarchiso -v -w $WORKDIR -o /workspace/$PROFILE_DIR/out .
    "

echo "--- Build Finished ---"
echo "ISO should be in $OUTDIR"
