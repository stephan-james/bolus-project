# Copyright (c) 2015 Stephan James Dick. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above
#   copyright notice, this list of conditions and the following disclaimer
#   in the documentation and/or other materials provided with the
#   distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# -----------------------------------------------------------------------

class Mathx

  rounded: (number, rounder) ->
    Math.round(number / rounder) * rounder


window.Mathx = new Mathx()

# -----------------------------------------------------------------------

class Datex

  currentHour: ->
    time = new Date()
    hour = time.getHours()
    if time.getMinutes() > 30
      hour++
    if hour > 23
      hour = 0
    hour

  currentTime: ->
    date = new Date()
    "#{date.getHours()}:#{date.getMinutes()}:#{date.getSeconds()}"


window.Datex = new Datex()

# -----------------------------------------------------------------------

class LocalStorage

  load: (name, defaultValue) ->
    Log.enter("LocalStorage.load")
    value = localStorage?.getItem name
    if value is null or not value?
      if defaultValue?
        @save(name, defaultValue)
      defaultValue
    else
      JSON.parse(value)

  save: (name, value) ->
    Log.enter("LocalStorage.save")
    if localStorage?
      localStorage.setItem name, JSON.stringify(value)


window.LocalStorage = new LocalStorage()

# -----------------------------------------------------------------------

class Viewx

  visibleHeight: ->
    window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight || window.height || screen.height || 0

window.Viewx = new Viewx()

# -----------------------------------------------------------------------

Log.info("Utils initialized.")
