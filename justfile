# SPDX-FileCopyrightText: 2023 Julian-Samuel Gebühr
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# Shows help
default:
    @{{ just_executable() }} --list --justfile "{{ justfile() }}"

# Runs ansible-lint against the role
lint:
    ansible-lint

# Renders the services_example.yml to public/
render:
    python cli.py render -i services_example.yml
