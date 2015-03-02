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

Polymerase.setup "bp-bolus-entry",

  icon: ""
  label: ""
  min: 0
  max: 100
  step: 1
  value: 0
  immediateValue: 0

  valueChanged: ->
    if @isDomReady()
      @immediateValue = @value

  immediateValueChanged: ->
    @value = @immediateValue

  onDomReady: ->
    @updateHeight()

  updateHeight: ->
    entryHeight = "#{@deriveHeight()}px"
    each.style.height = entryHeight for each in @shadowRoot.querySelector('style').sheet.rules when each.selectorText == '.entry'

  deriveHeight: ->
    # somewhat ugly here
    Math.floor((Viewx.visibleHeight() - 300) / 7)

  onDetached: ->
    @immediateValue = @value
