# ChiliVideos Plugin - A "private Youtube" for ChiliProject (or Redmine) installations

* http://chiliproject.org

## DESCRIPTION:

ChiliProject/Redmine plugin which integrates with Transload.it to offer
a private "YouTube-like" setup to your project site.

Noteable items to consider before installing:

1. This plugin is distributed as a gem, but does
   ship with migrations and asset files (stylesheets, etc). Therefore,
   the installation procedure is not the standard process.
1. The processing of "Assemblies" from the Transload.it service is
   handled in the background (via `delayed_job`), so there is an
   additional daemon process which you will have to monitor and/or
   manage with your installation.

## FEATURES:

1. Makes it dead simple to upload and store videos to your own
   ChiliProject/Redmine (CP/RM) installation.
   1. Note: Videos are hosted wherever you have Transload.it send them,
       S3 being a popular option.
1. Allows you to link videos to specific "versions" in the CP/RM
   project
1. Adds a "video" wiki macro which can be used to embed any video in
   wiki's, news items, et cetera. (taken from the `redmine_video_embed`
   plugin)

## PROBLEMS:

1. Does not support authenticated requests
1. If users click the "submit" button multiple times on the upload
   form, they may get duplicate video transcriptions
1. There is not currently support for a default "still" thumbnail image
   to be displayed when the video has not been started yet. All videos
   are just a "black box" until you click "play" at this point.

## SYNOPSIS:

1. Install the plugin
1. Fire up the delayed\_job daemon
1. Add your Transload.it account credentials & template ID on the
   'ChiliVideos' plugin settings page.
1. Enable the "Videos" module in a project

A "Videos" tab will show up in your project. Click the "Add Video" link
in the contextual menu and use the form to send a video through the
Transload.it workflow you specified in your plugin settings. The
delayed\_job daemon will grab the information about your video when
it is done being processed an the video will show up on the "Videos" tab.

## REQUIREMENTS:

* A Transload.it API key and workflow template ID
* Gems:
  - httparty (v0.7.4)
  - daemon-spawn (v0.4.2)
  - delayed\_job (v2.0.4)
  - friendly\_id (v3.2.1.1)
  - hashie (v1.0.0)

## INSTALL:

```
    gem install chili_videos
```

**Manual steps after installing the gem:**

1. In your 'config/environment.rb', add:

``` ruby
      config.gem 'chili_videos'
```

2. In your 'Rakefile', add:

``` ruby
      require 'chili_videos'
      require 'tasks/chili_videos_tasks'
      ChiliVideosTasks.new"
```

3. Run the installation rake task (runs migrations & installs assets)

``` ruby
      RAILS_ENV=production rake chili_videos:install
```

4. Cycle your application server (mongrel, unicorn, etc)

5. Start the delayed\_job daemon

```
      RAILS_ENV=production rake chili_videos:delayed_job ACTION=start
```

## UNINSTALL:

1. Stop the delayed\_job daemon

```
      RAILS_ENV=production rake chili_videos:delayed_job ACTION=stop
```

2. Run the uninstall rake task (reverts migrations & uninstalls assets)

```
      RAILS_ENV=production rake chili_videos:uninstall
```

3. In your 'Rakefile', remove:

``` ruby
      require 'chili_videos'
      require 'tasks/chili_videos_tasks'
      ChiliVideosTasks.new"
```

4. In your 'config/environment.rb', remove:

``` ruby
      config.gem 'chili_videos'
```

5. Cycle your application server (mongrel, unicorn, whatevs)

6. Uninstall the gem

```
    gem uninstall chili_videos
```

## CONTRIBUTING AND/OR SUPPORT:

### Found a bug? Have a feature request?

Please file a ticket on the 'Issues' page of the Github project site

### Want to contribute?

(Better instructions coming soon)
1. Fork the project
1. Create a feature branch and implement your idea (preferably with
   tests)
1. Update the History.txt file in the 'Next Release' section (at the top)
1. Send a pull request

## LICENSE:

    Refer to the LICENSE file

## Contributors (sorted alphabetically)

