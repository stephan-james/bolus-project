# Copyright (c) 2015, http://stephan-james.github.io/bolus-project
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of bolus-project nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

window.Log =

  DEBUG:
    id: "DEBUG"
    prio: 0
  INFO:
    id: "INFO"
    prio: 1
  WARN:
    id: "WARN"
    prio: 2
  ERROR:
    id: "ERROR"
    prio: 3
  FATAL:
    id: "FATAL"
    prio: 4

  enter: (name) ->
    @info("#{name}() enter")

  exit: (name) ->
    @info("#{name}() exit")

  debug: (text) ->
    @log(Log.DEBUG, text)

  info: (text) ->
    @log(Log.INFO, text)

  warn: (text) ->
    @log(Log.WARN, text)

  error: (text) ->
    @log(Log.ERROR, text)

  fatal: (text) ->
    @log(Log.FATAL, text)

  log: (level, text) ->
    console.log "[#{level.id}]: #{text}" if level.prio >= @level.prio

Log.level = Log.WARN

Log.info "Logging initialized."