# shifty — shift files from seedbox Plex to local Jellyfin/Emby

A collection of scripts to run the "perfect" media setup:

* A remote seedbox for requesting, downloading & sharing media
* A cloud drive to host an ever-growing library
* A local Jellyfin/Emby instance for guaranteed 4k streaming and transcoding

This gives you & your friends on-the-go access to the last few TB of media you've downloaded, but when you're at home you get access to your entire back catalogue on dedicated bandwidth & cpu resources.

## System Setup

* Read up about the overall [System Architecture](./docs/1_Architecture.md).
* Instructions for [setting up your Remote machine](./docs/2_Remote.md) on a seedbox provider.
* Instructions for [setting up the Local] box.
* A final [checklist] to check all settings are correct.

## Installation instructions

```sh
git clone https://github.com/hax-hax/shifty.git ~/.shifty
cd ~/.shifty
./prereqs remote  # for REMOTE server
./prereqs local   # for LOCAL server
```

Then, if everything checks out:

```sh
./scripts/install remote
# This will prompt you for the following, or you can
```
