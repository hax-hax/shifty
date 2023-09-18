# Shifty — Remote setup

> See [Architecture](./1_Architecture.md) for an explanation of the design

The Remote box is an extension of your seedbox: it runs a few new services that watches a local directory (we'll assume `~/Media`) and uploads data to Cloud Storage as well as emitting events to the Local server.

## Remote server setup

While for the most part it doesn't matter how you set up your seedbox, we recommend using [Swizzin](https://swizzin.ltd/).

## Why not use rclone mount on the Remote?

Most cost-effective seedboxes don't permit you to install the FUSE drivers required to run an [rclone mount](https://rclone.org/commands/rclone_mount/), and for the purposes of _uploading_ files, mounting is less efficient than using [rclone copy](https://rclone.org/commands/rclone_copy/) anyway. As a result, Shifty assumes that you'll be running `rclone copy` on the Remote.

## What if you have a larger remote server, with sudo access and FUSE?

A single server using rclone mount is the design behind [Cloudbox](https://cloudbox.works/), and it works reasonably well for larger seedboxes. That uses [cloudplow](https://github.com/l3uddz/cloudplow) behind the scenes to do regular uploads to cloud storages. This has the advantage that nothing on your remote server is ever deleted, it's just moved to the cloud.

