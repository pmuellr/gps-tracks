# Licensed under the Apache License. See footer for details.

#-------------------------------------------------------------------------------
# use this file with jbuild: https://www.npmjs.org/package/jbuild
# install jbuild with:
#    linux/mac: sudo npm -g install jbuild
#    windows:        npm -g install jbuild
#-------------------------------------------------------------------------------

path = require "path"

#-------------------------------------------------------------------------------
tasks = defineTasks exports,
  watch: "watch for source file changes, then run build"
  build: "rebuild changed my-tracks artifacts, serve"
  clean: "rebuild all the my-tracks artifacts, serve"

myTracksServer = path.join __dirname, "..", "my-tracks-server"
flickrApiFile  = path.join __dirname, "flickr-api-key.txt"

WatchSpec = """
  tracks
  tracks/**/*
  my-tracks.json
  tmp/rebuild
""".split(/\s+/g)

mkdir "-p", "tmp"
"".to "tmp/rebuild"

#-------------------------------------------------------------------------------
tasks.clean = ->
  log "cleaning out my-tracks"
  rm "-rf", "my-tracks"

  tasks.buildServe()

#-------------------------------------------------------------------------------
tasks.build = -> tasks.buildServe

#-------------------------------------------------------------------------------
tasks.buildServe = ->
  log "running build/server"

  cwd = process.cwd()

  flickrApiKey = getFlickrApiKey flickrApiFile

  # log "flickr API key: #{flickrApiKey}"

  options = "--verbose --flickr #{flickrApiKey}"
  command = "#{myTracksServer}/bin/my-tracks-server.js #{options} #{__dirname}"

  log "command: #{command}"

  server.start "tmp/server.pid", "node", command.split " "

#-------------------------------------------------------------------------------
tasks.watch = ->
  watchIter()

  watch
    files: WatchSpec
    run:   watchIter

  watchFiles "jbuild.coffee" :->
    log "jbuild file changed; exiting"
    process.exit 0

#-------------------------------------------------------------------------------
watchIter = ->
  tasks.buildServe()

#-------------------------------------------------------------------------------
getFlickrApiKey = (iFile) ->
  return cat(iFile).split(/\n/g).shift()

#-------------------------------------------------------------------------------
cleanDir = (dir) ->
  mkdir "-p", dir
  rm "-rf", "#{dir}/*"

#-------------------------------------------------------------------------------
# Copyright Patrick Mueller 2014
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------
