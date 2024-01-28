<h1 align="center">Security-Patch-Manager 🚀</h1>
<br>

[![GitHub](https://img.shields.io/github/license/Armoghans-Organization/Security-Patch-Manager)](https://github.com/Armoghans-Organization/Security-Patch-Manager/blob/main/LICENSE)
![Code Size](https://img.shields.io/github/languages/code-size/Armoghans-Organization/Security-Patch-Manager)
[![Codacy Security Scan](https://github.com/Armoghans-Organization/Security-Patch-Manager/actions/workflows/codacy.yml/badge.svg)](https://github.com/Armoghans-Organization/Security-Patch-Manager/actions/workflows/codacy.yml)

## Table of Contents


- [Overview](#overview)
- [Flags](#flags)
- [Functions](#functions)
- [Contributing](#contributing)
- [License](#license)


## Overview

Security-Patch-Manager is a Bash script designed to streamline the process of managing system security updates on Linux-based environments. With a focus on simplicity and efficiency, this script automates the tasks of checking for available updates, displaying relevant information, and applying updates when desired.


## Flags

| Flag           | Description                              |
| -------------- | ---------------------------------------- |
| `-h, --help`   | Show help message.                       |
| `-r, --root`   | Run the script as root.                  |
| `-v, --version`| Display script version.                  |
| `-l, --list`   | List available security updates.         |
| `-a, --apply`  | Apply security updates.                  |
| `-c, --clean`  | Run 'apt autoclean'.                     |
| `-d, --remove` | Run 'apt autoremove'.                    |


## Functions

- **print_message:** Display colored messages.
- **exit_message:** Display exit message.
- **trap exit_message INT:** Trap Ctrl+C to display exit message.
- **show_version:** Display script version.
- **press_enter:** Wait for Enter key press to continue.
- **print_banner:** Print the contents of an ASCII banner from a file.
- **print_linux_util_banner:** Print the Linux-Util banner.



## Contributing

Feel free to contribute by submitting issues or pull requests.

## License

This project is licensed under the [MIT License](https://github.com/Armoghans-Organization/Security-Patch-Manager/blob/main/LICENSE).
