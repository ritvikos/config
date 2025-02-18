#!/bin/bash

echo "🛠️ Starting Ubuntu Server Maintenance..."

# Remove unused dependencies and old kernels
echo "🗑️ Removing unused packages..."
sudo apt autoremove -y

# Clean up APT cache
echo "🧹 Cleaning up APT cache..."
sudo apt autoclean -y

# Remove old package lists
echo "🗄️ Removing old package lists..."
sudo rm -rf /var/lib/apt/lists/*

# Purge old config files of removed packages
echo "🚽 Checking for old config files to purge..."
OLD_CONFIGS=$(dpkg -l | awk '/^rc/ {print $2}')
if [[ -n "$OLD_CONFIGS" ]]; then
    echo "Purging: $OLD_CONFIGS"
    echo "$OLD_CONFIGS" | xargs sudo dpkg --purge
else
    echo "No old config files to purge."
fi

# Clean system logs older than 30 days
echo "📜 Cleaning old logs..."
sudo find /var/log -type f -name "*.log" -mtime +30 -delete

# Clean systemd journal logs, keeping only 100MB
echo "📝 Cleaning system logs..."
sudo journalctl --vacuum-size=100M

# Trim and optimize disk space (for SSDs)
echo "💾 Running TRIM for SSD optimization..."
sudo fstrim -av

echo "Apt-Get Updates"
sudo apt-get update

# Update package lists
echo "📦 Updating package lists..."
sudo apt update -y

# Upgrade installed packages
echo "⬆️ Upgrading installed packages..."
sudo apt upgrade -y

echo "(+) Full system upgrade..."
sudo apt full-upgrade -y

# Install latest linux headers.
sudo apt install linux-headers-$(uname -r)

echo "✅ Ubuntu Maintenance Completed Successfully!"
