#!/bin/bash

echo "🛠️ Starting Fedora Server Maintenance..."

# Remove unused dependencies and packages
echo "🗑️ Removing unused packages..."
sudo dnf autoremove -y

# Clean up DNF cache
echo "🧹 Cleaning up DNF cache..."
sudo dnf clean all

# Remove old log files (older than 30 days)
echo "📜 Cleaning old logs..."
sudo find /var/log -type f -name "*.log" -mtime +30 -delete

# Clean systemd journal logs, keeping only 100MB
echo "📝 Cleaning system logs..."
sudo journalctl --vacuum-size=100M

# Trim and optimize disk space (for SSDs)
echo "💾 Running TRIM for SSD optimization..."
sudo fstrim -av

echo "DNF Updates:"
sudo dnf check-update

# Update package lists and upgrade installed packages
echo "📦 Updating and upgrading packages..."
sudo dnf upgrade -y

# Install the latest kernel development packages (headers and devel)
echo "🔧 Installing latest kernel development packages..."
sudo dnf install -y kernel-devel kernel-headers

echo "✅ Fedora Maintenance Completed Successfully!"
