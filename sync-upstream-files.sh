#!/bin/bash
echo "=> Syncing files to base nix"
cp Makefile ../nix-base/for_upstream_nix_config/Makefile

echo "=> Committing changes to base"
if ! output=$(git -C ../nix-base add for_upstream_nix_config/* 2>&1); then
  echo "$output"
fi

if ! output=$(git -C ../nix-base commit -m "sync: Update Makefile" 2>&1); then
  echo "$output"
fi

echo "=> Committing changes to source repo"
if ! output=$(git add Makefile 2>&1); then
  echo "$output"
fi

if ! output=$(git commit -m "sync: Update Makefile" 2>&1); then
  echo "$output"
fi

echo "=> Done"
