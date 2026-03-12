#!/usr/bin/env bash
set -euo pipefail

: "${CONFIG_DIR:?CONFIG_DIR is not set}"

echo "--- Pulling latest changes from GitHub ---"
cd "$CONFIG_DIR" && git pull --recurse-submodules && git submodule update --remote --merge

echo "--- Updating Nix channels ---"
sudo nix-channel --update

echo "--- Running NixOS Rebuild (with package upgrades) ---"
sudo nixos-rebuild switch --upgrade -I nixos-config="$CONFIG_DIR/config/configuration.nix"

if command -v docker >/dev/null 2>&1; then
	echo "--- Updating Docker Compose containers ---"
	docker_dir="$CONFIG_DIR/docker"

	if [ ! -d "$docker_dir" ]; then
		echo "Docker directory not found at $docker_dir, skipping container updates."
	else
		mapfile -d '' compose_files < <(find "$docker_dir" -type f -name "docker-compose.yml" -print0)

		if [ "${#compose_files[@]}" -eq 0 ]; then
			echo "No docker-compose.yml files found in $docker_dir"
		else
			for compose_file in "${compose_files[@]}"; do
				project_dir="$(dirname "$compose_file")"
				project_name="$(basename "$project_dir")"

				echo "--- Updating Docker stack: $project_name ---"
				docker compose -f "$compose_file" pull
				docker compose -f "$compose_file" up -d
			done
		fi
	fi
else
	echo "Docker is not installed, skipping container updates."
fi

echo "--- Current System Status ---"
fastfetch
