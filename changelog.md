# CHANGELOG

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

----
## [5.5.0] - 2022-03-12
### Changed
* Updated CommandBox Image to v3.4.5 ( CommandBox v5.4.2 )
* Added Multi-Arch Builds for Debian-based images
* Updated ContentBox to v5.0.3

## [5.0.0] - 2020-03-11

### Added
* Upgraded to latest CommandBox Image: v2.8.0, so we get all of that image goodness
* Refactored entire image creation which now gives us a whoopoing 400-600mb in size savings from the previous version
* We now include tags for not only the ContentBox version but also the image version: `:${CONTENTBOX_VERSION}_${IMAGE_VERSION}`
* Add `-x` to scripts to allow you to see the command that runs for info purposes
* Updated healthchecks to include `start-periods` and also better timeouts and intervals

### Removed
* Dropped ACF11 Images

### Changed
#### v4 Image Sizes

* `latest` : 901.43mb
* `alpine` : 920.88mb
* `lucee5-4.2.1` : 996.21mb
* `adobe2016-4.2.1` : 996.21mb
* `adobe2018-4.2.1` : 996.21mb

#### v5 Images using CommandBox v4.8.0

* `latest` : 492.73mb (408.7mb in savings)
* `alpine` : 486.59mb (434.29mb in savings)
* `lucee5-4.2.1` : 813.20mb (183.01mb in savings)
* `adobe2016-4.2.1` : 824.54mb (171.67mb in savings)
* `adobe2018-4.2.1` : 836.64mb (159.57mb in savings)

---

## [4.0.0] - 2018-05-15

### Changed
* Disabled directory browsing for security
* Added docker hostname to Application name in `Application.cfc`
* Added a rolling file appender for all app logs to go to > `/var/log/contentbox.log`
* Upgrade to latest CommandBox v4.5.0
* Updated healthchecks to permit load up times
* No flags where ever being used, revamped it to warmup the server correctly and leverage environment variables for execution
* Removed support for lucee 4.5
* `BE` env variable was never working

## [3.7.1] - 2017-11-07 

### Changed
* Adding healtcheck URIs back again
* Removed redundant calls to CommandBox layer
* Added warmup servers to main tags due to lucee orm bug.

## [3.1.2] - 2017-10

### Changed
* Don't warm up servers to reduce image size
* Add Adobe 11, 2018 images that where not running
* Tag versions of each of the warmed up engines, instead of just latest

## [3.1.1] - 2017-10

### Changed
* Remove some cleanup scripts to avoid issues

## [3.1.0] - 2017-10 

### Changed
* Added new environment variables to control heap size: `JVM_HEAPSIZE` which defaults to `512mb`
* Updated CommandBox main image to 4.2.0
* Upgrade to ContentBox v4.1.0
* Removed legacy media root directory and leverage new custom module location: `/app/modules_app/contentbox-custom`
* Added Adobe 2018 Tag
* Updated distributed example with Redis

## [3.0.0] - 2017-09

### Changed
* Optimize for size
* Remove static healthcheck and just rely on the CommandBox image healthcheck, which makes more sense
* Removed some debugging files
* Updated CommandBox to 4.0.0
* `ORM_DIALECT` was not being used in the right place.
* `EXPRESS` and `HEADLESS` was not evaluated to a boolean, just existence 
* Removed usage of lowercase `install`, `be`, and `express`, you must use uppercase env variables.
* Added `lucee5` to snapshot releases
* Renamed `HEADLESS` flag so we don't clash with the CommandBox image. New Setting is `REMOVE_CBADMIN`
* Added Alpine version for ContentBox

## [2.4.0] - 2017
### Changed
* Added Router to handle full rewrites, which it should by default
* Rewrites should be added by default if no server.json is defined

## [2.3.0] - 2017
### Changed
* Added ContentBox v4.0.0 support
* Added new `HEADLESS` environment setting so the admin does not get deployed if passed

## [2.2.0] - 2017
### Changed
* Updated config for conflicted distributed cache setting