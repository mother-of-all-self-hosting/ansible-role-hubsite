<!--
SPDX-FileCopyrightText: 2020 - 2024 MDAD project contributors
SPDX-FileCopyrightText: 2020 - 2024 Slavi Pantaleev
SPDX-FileCopyrightText: 2020 Aaron Raimist
SPDX-FileCopyrightText: 2020 Chris van Dijk
SPDX-FileCopyrightText: 2020 Dominik Zajac
SPDX-FileCopyrightText: 2020 Mickaël Cornière
SPDX-FileCopyrightText: 2022 François Darveau
SPDX-FileCopyrightText: 2022 Julian Foad
SPDX-FileCopyrightText: 2022 Warren Bailey
SPDX-FileCopyrightText: 2023 - 2024 Julian-Samuel Gebühr
SPDX-FileCopyrightText: 2023 Antonis Christofides
SPDX-FileCopyrightText: 2023 Felix Stupp
SPDX-FileCopyrightText: 2023 Pierre 'McFly' Marty
SPDX-FileCopyrightText: 2024 - 2025 Suguru Hirahara
SPDX-FileCopyrightText: 2024 Kuchenmampfer
SPDX-FileCopyrightText: 2024 Tammes Burghard

SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Setting up Hubsite

This is an [Ansible](https://www.ansible.com/) role which installs Hubsite to run as a [Docker](https://www.docker.com/) container wrapped in a systemd service.

Hubsite is an ansible role to run a simple, static site that shows an overview of available services. It makes use of the official nginx docker image.

[<img src="assets/hubsite_desktop.png" width="600" alt="The UI with services like Miniflux and Nextcloud. The site and service logos are expressed in grey an white tones">](assets/hubsite_desktop.png)

## Adjusting the playbook configuration

To enable Hubsite with this role, add the following configuration to your `vars.yml` file.

**Note**: the path should be something like `inventory/host_vars/mash.example.com/vars.yml` if you use the [MASH Ansible playbook](https://github.com/mother-of-all-self-hosting/mash-playbook).

```yaml
########################################################################
#                                                                      #
# hubsite                                                              #
#                                                                      #
########################################################################

hubsite_enabled: true

########################################################################
#                                                                      #
# /hubsite                                                             #
#                                                                      #
########################################################################
```

### Set the hostname

To enable Hubsite you need to set the hostname as well. To do so, add the following configuration to your `vars.yml` file. Make sure to replace `example.com` with your own value.

```yaml
hubsite_hostname: "example.com"
```

After adjusting the hostname, make sure to adjust your DNS records to point the domain to your server.

**Note**: hosting Hubsite under a subpath (by configuring the `hubsite_path_prefix` variable) does not seem to be possible due to Hubsite's technical limitations.

### Specify headers on the UI

You also need to specify headers on the UI by adding the following configuration to your `vars.yml` file:

```yaml
hubsite_title: "My services"
hubsite_subtitle: "Just click on a service to use it"
```

### Define services to display

You can use the following variables to configure which services to display like below:

```yaml
# Nextcloud
hubsite_service_nextcloud_enabled: "{{ nextcloud_enabled }}"
hubsite_service_nextcloud_name: Nextcloud
hubsite_service_nextcloud_url: "'https://{{ nextcloud_hostname }}{{ nextcloud_path_prefix }}"
hubsite_service_nextcloud_logo_location: "{{ role_path }}/assets/nextcloud.png"
hubsite_service_nextcloud_description: "Sync your files & much more"
hubsite_service_nextcloud_priority: 1000

# Peertube
hubsite_service_peertube_enabled: "{{ peertube_enabled }}"
hubsite_service_peertube_name: Peertube
hubsite_service_peertube_url: "'https://{{ peertube_hostname }}{{ peertube_path_prefix }}"
hubsite_service_peertube_logo_location: "{{ role_path }}/assets/peertube.png"
hubsite_service_peertube_description: "Watch and upload videos"
hubsite_service_peertube_priority: 1000
```

>[!NOTE]
> If you don't have a fitting logo for your service, you can set an empty value to `hubsite_service_*_logo_location`.

### Add services to a playbook

You can add services to `hubsite_service_list_auto` on an Ansible playbook as below:

```yaml
hubsite_service_list_auto: |
  {{
    ([{'name': hubsite_service_nextcloud_name, 'url': hubsite_service_nextcloud_url, 'logo_location': hubsite_service_nextcloud_logo_location, 'description': hubsite_service_nextcloud_description, 'priority': hubsite_service_nextcloud_priority}] if hubsite_service_nextcloud_enabled else [])
    +
    ([{'name': hubsite_service_peertube_name, 'url': hubsite_service_peertube_url, 'logo_location': hubsite_service_peertube_logo_location, 'description': hubsite_service_peertube_description, 'priority': hubsite_service_peertube_priority}] if hubsite_service_peertube_enabled else [])
  }}
```

Users of the playbook can add custom services to `hubsite_service_list_additional`.

### Add custom CSS rules (optional)

You can override the [default CSS rules](https://github.com/mother-of-all-self-hosting/ansible-role-hubsite/blob/main/templates/html/styles.css.j2) by adding them to the `hubsite_extra_css` variable as below:

```yaml
hubsite_extra_css: |
  html {
    background-color: #001a28;
    color: white;
  }

  .flexblock a {
      border: 5px solid #906000;
      padding: 20px;
      border-radius: 30px;
      margin: 15px;
      text-align: center;
      background-color: #046;
      width: 25%;
  }

  .logo {
      background-color: #046;
  }
```

## Installing

After configuring the playbook, run the installation command of your playbook as below:

```sh
ansible-playbook -i inventory/hosts setup.yml --tags=setup-all,start
```

If you use the MASH playbook, the shortcut commands with the [`just` program](https://github.com/mother-of-all-self-hosting/mash-playbook/blob/main/docs/just.md) are also available: `just install-all` or `just setup-all`

## Usage

After running the command for installation, the Headscale instance becomes available at the URL specified with `hubsite_hostname`. With the configuration above, the service is hosted at `https://example.com`.

You can alternatively output the page manually by running the command below:

```sh
python cli.py render -i services_example.yml
```

## Logos

There are some logos provided, so you can get started with a nice look immediately.

| Service/Purpose   | Licence                                                                                                        | Author                               | Changes made | Use it with                               |
|-------------------|----------------------------------------------------------------------------------------------------------------|--------------------------------------|--------------|-------------------------------------------|
| Generic Docs Icon | CCO                                                                                                            | moanos                               | ❌            | `{{ role_path }}/assets/docs.png`         |
| Generic Shield    | CC0                                                                                                            | moanos                               | ❌            | `{{ role_path }}/assets/shield.png`       |
| Generic Mail Icon | CCO                                                                                                            | moanos                               | ❌            | `{{ role_path }}/assets/mail.png`         |
| Appsmith          | [Apache License](https://github.com/appsmithorg/appsmith/blob/release/LICENSE)                                 | Appsmith contributors                | ✅            | `{{ role_path }}/assets/appsmith.png`     |
| Authentik         | [CC-BY-SA 4.0](https://github.com/goauthentik/authentik/blob/main/LICENSE)                                     | Jens Langhammer                      | ✅            | `{{ role_path }}/assets/authentik.png`    |
| Bookstack         | [MIT](https://github.com/BookStackApp/BookStack/blob/development/LICENSE)                                      | Dan Brown                            | ✅            | `{{ role_path }}/assets/bookstack.png`    |
| Docker            | [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)                                                      | dotCloud, Inc.                       | ✅            | `{{ role_path }}/assets/docker.png`       |
| Firezone          | [Apache License](https://github.com/firezone/firezone/blob/master/LICENSE)                                     | Firezone contributors                | ✅            | `{{ role_path }}/assets/firezone.png`     |
| Focalboard        | [AGPL v.3.0](https://github.com/mattermost/focalboard/blob/main/LICENSE.txt)                                   | Mattermost, Inc.                     | ✅            | `{{ role_path }}/assets/focalboard.png`   |
| FreshRSS          | [AGPL v.3.0](https://github.com/FreshRSS/FreshRSS/blob/edge/LICENSE.txt)                                       | FreshRSS contributors                | ✅            | `{{ role_path }}/assets/freshrss.png`     |
| Funkwhale         | [CC BY-SA 3.0](https://dev.funkwhale.audio/funkwhale/funkwhale/-/blob/stable/front/src/assets/logo/License.md) | Francis Gading                       | ✅            | `{{ role_path }}/assets/funkwhale.png`    |
| Gitea             | [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)                                                | Lauris BH                            | ✅            | `{{ role_path }}/assets/gitea.png`        |
| GoToSocial        | [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)                                                | Anna Abramek                         | ✅            | `{{ role_path }}/assets/gotosocial.png`   |
| Grafana           | [AGPL v3.0](https://github.com/grafana/grafana/blob/main/LICENSE)                                              | Grafana Labs                         | ✅            | `{{ role_path }}/assets/grafana.png`      |
| Healthchecks      | [BSD 3-Clause](https://github.com/healthchecks/healthchecks/blob/master/LICENSE)                               | Pēteris Caune and other contributors | ✅            | `{{ role_path }}/assets/healthchecks.png` |
| Jitsi             | [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)                                              | Jitsi contributors                   | ✅            | `{{ role_path }}/assets/jitsi.png`        |
| Keycloak          | [Apache License 2.0](https://github.com/keycloak/keycloak/blob/main/LICENSE.txt)                               | Keycloak contributors                | ✅            | `{{ role_path }}/assets/keycloak.png`     |
| Lago              | [AGPL v3.0](https://github.com/getlago/lago/blob/main/LICENSE)                                                 | Lago contributors                    | ✅            | `{{ role_path }}/assets/lago.png`         |
| Linkding          | [MIT](https://github.com/sissbruecker/linkding/blob/master/LICENSE.txt)                                        | Linkding                             | ✅            | `{{ role_path }}/assets/linkding.png`     |
| Miniflux          | [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/)                                                      | Frédéric Guillot                     | ✅            | `{{ role_path }}/assets/miniflux.png`     |
| Mobilizon         | [AGPL v.3.0](https://framagit.org/framasoft/mobilizon/-/blob/main/LICENSE)                                     | Mobilizon contributors               | ✅            | `{{ role_path }}/assets/mobilizon.png`    |
| Navidrome         | [GPL 3.0](https://github.com/navidrome/navidrome/blob/master/LICENSE)                                          | Navidrome contributors               | ✅            | `{{ role_path }}/assets/navidrome.png`    |
| Nextcloud         | Public Domain                                                                                                  | Nextcloud                            | ✅            | `{{ role_path }}/assets/nextcloud.png`    |
| Owncast           | [MIT](https://github.com/owncast/owncast/blob/develop/LICENSE)                                                 | Owncast contributors                 | ✅            | `{{ role_path }}/assets/owncast.png`      |
| Peertube          | Public Domain                                                                                                  | PeerTube contributors                | ✅            | `{{ role_path }}/assets/peertube.png`     |
| Prometheus        | [Apache 2.0](https://github.com/prometheus/prometheus/blob/main/LICENSE)                                       | -                                    | ✅            | `{{ role_path }}/assets/prometheus.png`   |
| Radicale          | [GPL 3.0](https://github.com/Kozea/Radicale/blob/master/COPYING.md)                                            | Unrud                                | ✅            | `{{ role_path }}/assets/radicale.png`     |
| Readeck           | [AGPL v3.0](https://codeberg.org/readeck/readeck/src/branch/main/LICENSE)                                      | Olivier Meunier                      | ✅            | `{{ role_path }}/assets/readeck.png`      |
| Redmine           | [CC-BY-SA 2.5](http://creativecommons.org/licenses/by-sa/2.5/)                                                 | Martin Herr                          | ✅            | `{{ role_path }}/assets/redmine.png`      |
| Semaphore         | [MIT](https://github.com/ansible-semaphore/semaphore)                                                          | Castaway Consulting LLC              | ✅            | `{{ role_path }}/assets/semaphore.png`    |
| Stirling PDF      | [MIT](https://github.com/Stirling-Tools/Stirling-PDF/blob/main/LICENSE)                                        | Stirling Tools                       | ✅            | `{{ role_path }}/assets/stirling-pdf.png` |
| Syncthing         | [MPLv2](https://github.com/syncthing/syncthing/blob/main/LICENSE)                                              | Syncthing contributors               | ✅            | `{{ role_path }}/assets/syncthing.png`    |
| Tandoor           | [AGPL v3.0](https://github.com/TandoorRecipes/recipes/blob/develop/LICENSE.md)                                 | vabene1111                           | ✅            | `{{ role_path }}/assets/tandoor.png`      |
| Uptime Kuma       | [MIT](https://github.com/louislam/uptime-kuma/blob/master/LICENSE)                                             | Louis Lam                            | ✅            | `{{ role_path }}/assets/uptime-kuma.png`  |
| Vaultwarden       | [AGPL v3.0](https://github.com/dani-garcia/vaultwarden/blob/main/LICENSE.txt)                                  | Mathijs van Veluw                    | ✅            | `{{ role_path }}/assets/vaultwarden.png`  |
| WG Easy           | [custom](https://github.com/wg-easy/wg-easy/blob/master/LICENSE)                                            | Emile Nijssen                        | ✅            | `{{ role_path }}/assets/wireguard_easy.png`      |
| Woodpecker CI     | [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)                                                      | Woodpecker contributors              | ✅            | `{{ role_path }}/assets/woodpecker.png`   |
| Writefreely       | [AGPL v3.0](https://github.com/writefreely/writefreely/blob/develop/LICENSE)                                   | Matt Baer                            | ✅            | `{{ role_path }}/assets/writefreely.png`  |

## Troubleshooting

### Check the service's logs

You can find the logs in [systemd-journald](https://www.freedesktop.org/software/systemd/man/systemd-journald.service.html) by logging in to the server with SSH and running `journalctl -fu hubsite` (or how you/your playbook named the service, e.g. `mash-hubsite`).
