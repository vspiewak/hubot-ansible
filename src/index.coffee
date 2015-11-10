# Copyright 2015 Vincent Spiewak
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

Fs   = require 'fs'
Path = require 'path'

module.exports = (robot, callback) ->
  path = Path.resolve __dirname, 'scripts'
  Fs.exists path, (exists) ->
    if exists
      for file in Fs.readdirSync(path)
        if Fs.lstatSync(Path.resolve path, file).isFile()
          robot.loadFile path, file
    callback() if callback?
