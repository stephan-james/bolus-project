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

class DataLine

  constructor: (@glucoseMinimal, @glucoseMaximal, @insulinPerCarbohydrates, @glucosePerInsulin, @glucosePerCarbohydrates) ->

  correctionMinimum: (g) ->
    if g < @glucoseMinimal then 0.0 else (g - @glucoseMinimal ) / @glucosePerInsulin

  correctionMaximum: (g) ->
    if g < @glucoseMaximal then 0.0 else (g - @glucoseMaximal ) / @glucosePerInsulin

  bolus: (c) ->
    c * @insulinPerCarbohydrates

  calculate: (g, c) ->
    [@correctionMinimum(g) + @bolus(c), @correctionMaximum(g) + @bolus(c)]

  comeOut: (g, c, i) ->
    Math.round(g - Math.max(0, i - @bolus(c)) * @glucosePerInsulin + Math.max(0, @bolus(c) - i) / @insulinPerCarbohydrates * @glucosePerCarbohydrates)

  proposeInsulin: (g, c) ->
    if g < @glucoseMinimal and c > 0
      c = Math.max(0, c - ((@glucoseMinimal - g) / @glucosePerCarbohydrates))
    Math.floor(@correctionMinimum(g) + @bolus(c))

  proposeCarbohydrates: (g) ->
    Math.abs(Math.min(0.0, ( g - @glucoseMinimal ) / @glucosePerCarbohydrates))

# -------------------------------------------------------------------------------------------------

DataLocalStorage =
  blob:
    creationTime: Datex.currentTime()
    updateTime: null
    dataLines: [
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85),
      new DataLine(80, 160, 1.1, 75, 85)]

  load: ->
    @loadBlob(LocalStorage.load("DataLocalStorage", @blob))

  loadBlob: (newBlob) ->
    @blob = newBlob
    @blob.dataLines = (new DataLine(i.glucoseMinimal, i.glucoseMaximal, i.insulinPerCarbohydrates, i.glucosePerInsulin, i.glucosePerCarbohydrates) for i in @blob.dataLines)

  reset: ->
    index = 0
    for dataLine in @blob.dataLines
      dataLine.glucoseMinimal = 70 + index * 5
      dataLine.glucoseMaximal = dataLine.glucoseMinimal + 10
      dataLine.insulinPerCarbohydrates = 1 + index * 0.1
      dataLine.glucosePerInsulin = 10 + index * 5
      dataLine.glucosePerCarbohydrates = 20 + index * 5
      index++

  save: ->
    LocalStorage.save("DataLocalStorage", @blob)

  isNew: ->
    @blob.updateTime is null

  dataLine: (hour) ->
    @blob.dataLines[hour]

  currentDataLine: ->
    @dataLine(Datex.currentHour())

  export: ->
    JSON.stringify(@blob)

  import: (data) ->
    @loadBlob(JSON.parse(data))

DataLocalStorage.load()

# -------------------------------------------------------------------------------------------------

Polymerase.setup "bp-bolus",

  importExport: "---"

  reset: ->
    DataLocalStorage.reset()
    @save()

  export: ->
    @importExport = DataLocalStorage.export()

  import: ->
    DataLocalStorage.import(@importExport)
    @compute()

  onReady: ->
    Log.enter("ready")
    @pages = @$.pages
    @pageTitle = "bolus-project"
    Log.exit("ready")

  onDomReady: ->
    Log.enter("domReady")
    @carbohydrates = 0
    @glucose = 120
    @editHour = Datex.currentHour()
    @compute()
    Log.exit("domReady")

#OutOfOrder =

  selectAction: (e, detail) ->
    if detail.isSelected
      selected = detail.item.attributes
      @pages.selected = selected.num.nodeValue
      @pageTitle = selected.label.nodeValue
      @$.drawer.togglePanel()

  initByEditDataLine: ->
    dataLine = @editDataLine()
    @glucoseMinimal = dataLine.glucoseMinimal
    @glucoseMaximal = dataLine.glucoseMaximal
    @insulinPerCarbohydrates = dataLine.insulinPerCarbohydrates
    @glucosePerInsulin = dataLine.glucosePerInsulin
    @glucosePerCarbohydrates = dataLine.glucosePerCarbohydrates

  editDataLine: ->
    DataLocalStorage.dataLine(@editHour)

  proposalInsulin: 0
  proposalGlucose: 120
  proposalCarbohydrates: 0
  carbohydrates: 0
  carbohydratesChanged: -> @compute()
  glucose: 120
  glucoseChanged: -> @compute()
  editHour: Datex.currentHour()
  editHourChanged: -> @compute()
  glucoseMinimal: DataLocalStorage.currentDataLine().glucoseMinimal
  glucoseMinimalChanged: -> @save()
  glucoseMaximal: DataLocalStorage.currentDataLine().glucoseMaximal
  glucoseMaximalChanged: -> @save()
  insulinPerCarbohydrates: DataLocalStorage.currentDataLine().insulinPerCarbohydrates
  insulinPerCarbohydratesChanged: -> @save()
  glucosePerInsulin: DataLocalStorage.currentDataLine().glucosePerInsulin
  glucosePerInsulinChanged: -> @save()
  glucosePerCarbohydrates: DataLocalStorage.currentDataLine().glucosePerCarbohydrates
  glucosePerCarbohydratesChanged: -> @save()

  labels:
    editHour: "Aggregated time range [hour]"
    glucoseMinimum: "Target glucose in up to 3 hours [mg/dL]"
    insulinPerCarbohydrates: "Insulin per carbohydrates [ie]"
    glucosePerInsulin: "Glucose reduction per insulin unit [mg/dL]"
    glucosePerCarbohydrates: "Glucose increase per carbohydrate unit [mg/dL]"
    carbohydrates: "Targeted carbohydrate units [12mg]"
    glucose: "Current glucose [mg/dL]"

  compute: ->
    if not @isDomReady()
      return
    dataLine = @editDataLine()
    @glucoseMinimal = dataLine.glucoseMinimal
    @glucoseMaximal = dataLine.glucoseMaximal
    @insulinPerCarbohydrates = dataLine.insulinPerCarbohydrates
    @glucosePerInsulin = dataLine.glucosePerInsulin
    @glucosePerCarbohydrates = dataLine.glucosePerCarbohydrates
    [minimal,maximal] = dataLine.calculate(@glucose, @carbohydrates)
    @proposalInsulin = dataLine.proposeInsulin(@glucose, @carbohydrates)
    @proposalGlucose = Mathx.rounded(dataLine.comeOut(@glucose, @carbohydrates, @proposalInsulin), 5)
    @proposalCarbohydrates = Mathx.rounded(dataLine.proposeCarbohydrates(@glucose), 0.25)
    if @proposalCarbohydrates > @carbohydrates
      @carbohydrates = @proposalCarbohydrates
      @compute()

  save: ->
    if not @isDomReady()
      return
    dataLine = @editDataLine()
    dataLine.glucoseMinimal = @glucoseMinimal
    dataLine.glucoseMaximal = @glucoseMaximal
    dataLine.insulinPerCarbohydrates = @insulinPerCarbohydrates
    dataLine.glucosePerInsulin = @glucosePerInsulin
    dataLine.glucosePerCarbohydrates = @glucosePerCarbohydrates
    DataLocalStorage.save()
    @compute()
