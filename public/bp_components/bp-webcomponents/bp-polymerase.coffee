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

class Polymerase

  setup: (name, prototype) ->

    prototype.innerState =
      created: false
      ready: false
      attached: false
      domReady: false
      detached: false

    prototype.isCreated = ->
      @innerState.created

    prototype.isReady = ->
      @innerState.ready

    prototype.isAttached = ->
      @innerState.attached

    prototype.isDomReady = ->
      @innerState.domReady

    prototype.isDetached = ->
      @innerState.detached

    prototype.created = ->
      @innerState.created = true
      @onCreated()

    if not prototype.onCreated
      prototype.onCreated = ->

    prototype.ready = ->
      @innerState.ready = true
      @onReady()

    if not prototype.onReady
      prototype.onReady = ->

    prototype.attached = ->
      @innerState.attached = true
      @onAttached()

    if not prototype.onAttached
      prototype.onAttached = ->

    prototype.domReady = ->
      @innerState.domReady = true
      @onDomReady()

    if not prototype.onDomReady
      prototype.onDomReady = ->

    prototype.detached = ->
      @innerState.detached = true
      @onDetached()

    if not prototype.onDetached
      prototype.onDetached = ->

    prototype.log = (objects...) ->
      Log.log(name, objects)

    Polymer name, prototype

window.Polymerase = new Polymerase()
