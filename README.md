<!--
SPDX-FileCopyrightText: 2023 - 2024 Julian-Samuel Gebühr
SPDX-FileCopyrightText: 2024 Kuchenmampfer
SPDX-FileCopyrightText: 2024 Tammes Burghard

SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Hubsite

💡 See this [document](docs/configuring-hubsite.md) for details about setting up the service with this role.

[![status-badge](https://woodpecker.hyteck.de/api/badges/102/status.svg)](https://woodpecker.hyteck.de/repos/102)

Hubsite is an ansible role to run a simple, static site that shows an overview of available services.

It is powered by the official nginx docker image.



## How does it look?

![A screenshot of Hubsite hosting different services like Miniflux and Nextcloud. The site and service logos are expressed in grey an white tones](assets/hubsite_desktop.png)

It uses `prefers-color-scheme` to automatically set the color scheme to light or dark. Check out  [this **live preview**](https://hubsite.hyteck.de) to see an example with all pre-configured services.

## Configuration



## Development

You can optionally install [pre-commit](https://pre-commit.com/) so that simple mistakes are checked and noticed before changes are pushed to a remote branch. See [`.pre-commit-config.yaml`](./.pre-commit-config.yaml) for which hooks are to be executed.

See [this section](https://pre-commit.com/#usage) on the official documentation for usage.
