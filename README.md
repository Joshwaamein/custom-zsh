# Cross-Distribution Shell & Terminal Configuration Script

This script automates the setup of zsh with Oh My Zsh, syntax highlighting, and a fun startup greeting. It also configures GNOME Terminal colors on supported systems. The script is designed to work across multiple Linux distributions.

---

## Features

- **Cross-Distribution Support**
  - Detects and supports Ubuntu/Debian, RHEL/Fedora/CentOS, and Arch Linux.
- **zsh Configuration**
  - Installs zsh and changes the default shell.
  - Installs Oh My Zsh and backs up existing `.zshrc`.
  - Configures a custom theme (default: `duellj`, can be changed via argument).
  - Adds zsh-syntax-highlighting for an improved command-line experience.
  - Includes a fun greeting with `fortune`, `cowsay`, and `lolcat`.
- **GNOME Terminal Customization**
  - Sets a custom color scheme for GNOME Terminal (if available).
  - Gracefully skips on non-GNOME environments.
- **Safety & Usability**
  - Prevents running as root.
  - Creates timestamped backups of existing `.zshrc`.
  - Provides clear, color-coded feedback.
  - Idempotent: safe to re-run.

---

## Requirements

- **Linux Distribution:** Ubuntu, Debian, RHEL, CentOS, Fedora, or Arch Linux.
- **User Permissions:** Must not be run as root. Standard user permissions required.
- **GNOME Desktop:** GNOME Terminal customization is optional and requires GNOME.

---

## Usage

Basic usage (default theme)
./configure-system.sh

Specify a different theme (e.g., agnoster)
./configure-system.sh agnoster

---

## Script Output

- **Color-coded status and error messages.**
- **Backup of existing `.zshrc` with timestamp.**
- **Instructions for logging out or running `exec zsh` to activate changes.**
- **Notification to open a new terminal window to see changes.**

---

## Security Note

This script does not require root privileges for most operations, except for package installation and changing the default shell. It will exit if run as root.

---

## Integration with Ansible

If you use **Ansible** for managing infrastructure and security[1], consider integrating this logic into your custom playbooks for user management and environment setup.

---

## Example Configuration

After running the script, your shell will:
- Use zsh with Oh My Zsh
- Have syntax highlighting
- Display a fun greeting on startup
- (Optional) Use custom GNOME Terminal colors

---

## License

This script is provided as-is. Use at your own risk.

---

## Feedback & Contributions

Feel free to fork, modify, or open issues for improvements or bug reports.
