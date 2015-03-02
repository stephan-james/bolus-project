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

# -------------------------------------------------------------------------------------------------

GlucoseUnit =

  MMOL_L:
    id: "mmol/l"
    step: 0.25

  MG_DL:
    id: "mg/dl"
    step: 5

  to_mmol_l: (mg_dl) ->
    mg_dl * 0.0555

  to_mg_dl: (mmol_l) ->
    mmol_l * 18.0182

  switch: (glucoseUnit, glucose) ->
    if glucoseUnit == GlucoseUnit.MG_DL
      @to_mg_dl(glucose)
    else
      @to_mmol_l(glucose)

# -------------------------------------------------------------------------------------------------

CarbohydatesUnit =

  MG:
    id: "mg"
    factor: 1
    step: 5
    min: 0
    max: 15 * 12

  BE10:
    id: "BE (10mg)"
    factor: 10
    step: 0.25
    min: 0
    max: 15 * 12 / 10

  BE12:
    id: "BE (12mg)"
    factor: 12
    step: 0.25
    min: 0
    max: 15

# -------------------------------------------------------------------------------------------------

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

  switchGlucoseUnit: (glucoseUnit) ->
    @glucoseMinimal = GlucoseUnit.switch(glucoseUnit, @glucoseMinimal)
    @glucoseMaximal = GlucoseUnit.switch(glucoseUnit, @glucoseMaximal)
    @glucosePerInsulin = GlucoseUnit.switch(glucoseUnit, @glucosePerInsulin)
    @glucosePerCarbohydrates = GlucoseUnit.switch(glucoseUnit, @glucosePerCarbohydrates)

# -------------------------------------------------------------------------------------------------

DataLocalStorage =
  blob:
    creationTime: Datex.currentTime()
    updateTime: null
    glucoseUnit: GlucoseUnit.MG_DL
    glucoseUnitSelected: false
    carbohydatesUnit: CarbohydatesUnit.BE12
    carbohydatesUnitSelected: false
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
    @blob.glucoseUnit = GlucoseUnit.MG_DL if not @blob.glucoseUnit?
    @blob.glucoseUnitSelected = false if not @blob.glucoseUnitSelected?
    @blob.carbohydatesUnit = CarbohydatesUnit.BE12 if not @blob.carbohydatesUnit?
    @blob.carbohydatesUnitSelected = false if not @blob.carbohydatesUnitSelected?
    #@blob.glucoseUnit = GlucoseUnit.MG_DL # @todo:remove
    #@blob.glucoseUnitSelected = false # @todo:remove
    #@blob.carbohydatesUnitSelected = false # @todo:remove

  save: ->
    LocalStorage.save("DataLocalStorage", @blob)

  isNew: ->
    @blob.updateTime is null

  dataLine: (hour) ->
    @blob.dataLines[hour]

  currentDataLine: ->
    @dataLine(Datex.currentHour())

  isGlucoseUnitSelected: ->
    @blob.glucoseUnitSelected

  getGlucoseUnit: ->
    @blob.glucoseUnit

  setGlucoseUnit: (glucoseUnit) ->
    @blob.glucoseUnit = glucoseUnit

  switchGlucoseUnit: (glucoseUnit) ->
    @blob.glucoseUnitSelected = true
    return if glucoseUnit == @getGlucoseUnit()
    for dataLine in @blob.dataLines
      dataLine.switchGlucoseUnit(glucoseUnit)
    @setGlucoseUnit(glucoseUnit)

  isCarbohydatesUnitSelected: ->
    @blob.carbohydatesUnitSelected

  getCarbohydatesUnit: ->
    @blob.carbohydatesUnit

  switchCarbohydatesUnit: (carbohydatesUnit) ->
    @blob.carbohydatesUnitSelected = true
    return if carbohydatesUnit == @getCarbohydatesUnit()
    @blob.carbohydatesUnit = carbohydatesUnit

  export: ->
    JSON.stringify(@blob)

  import: (data) ->
    try
      newBlob = JSON.parse(data)
      @loadBlob(newBlob)
    catch exception
      alert(exception)

  asCurrentUnit: (glucoseInMgPerDL) ->
    if @getGlucoseUnit() == GlucoseUnit.MG_DL
      glucoseInMgPerDL
    else
      Log.info(@)
      Mathx.rounded(GlucoseUnit.to_mmol_l(glucoseInMgPerDL), @getGlucoseUnit().step)

DataLocalStorage.load()

# -------------------------------------------------------------------------------------------------

Polymerase.setup "bp-bolus",

  onReady: ->
    @pages = @$.pages
    @pageTitle = "bolus-project"

  onDomReady: ->
    @carbohydrates = 0
    @glucose = DataLocalStorage.asCurrentUnit(120)
    @editHour = Datex.currentHour()
    @compute()
    @$.chooseGlucoseUnitDialog.opened = not DataLocalStorage.isGlucoseUnitSelected()
    @$.chooseCarbohydatesUnitDialog.opened = not DataLocalStorage.isCarbohydatesUnitSelected()

  selectAction: (e, detail) ->
    if detail.isSelected
      selected = detail.item.attributes
      @pages.selected = selected.num.nodeValue
      @pageTitle = selected.label.nodeValue
      @$.drawer.togglePanel()

  chooseMmolPerL: -> @chooseGlucoseUnit(GlucoseUnit.MMOL_L)
  chooseMgPerDl: -> @chooseGlucoseUnit(GlucoseUnit.MG_DL)
  chooseGlucoseUnit: (glucoseUnit) ->
    DataLocalStorage.switchGlucoseUnit(glucoseUnit)
    DataLocalStorage.save()
    window.location.reload()

  chooseMg: -> @chooseCarbohydatesUnit(CarbohydatesUnit.MG)
  chooseBE10: -> @chooseCarbohydatesUnit(CarbohydatesUnit.BE10)
  chooseBE12: -> @chooseCarbohydatesUnit(CarbohydatesUnit.BE12)
  chooseCarbohydatesUnit: (glucoseUnit) ->
    DataLocalStorage.switchCarbohydatesUnit(glucoseUnit)
    DataLocalStorage.save()
    window.location.reload()

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
  proposalGlucose: DataLocalStorage.asCurrentUnit(120)
  proposalCarbohydrates: 0

  editHour: Datex.currentHour()
  editHourChanged: -> @compute()
  editHourStep: 1
  editHourMin: 0
  editHourMax: 23

  glucoseMinimal: DataLocalStorage.currentDataLine().glucoseMinimal
  glucoseMinimalChanged: -> @save()
  glucoseMinimalStep: DataLocalStorage.getGlucoseUnit().step
  glucoseMinimalMin: DataLocalStorage.asCurrentUnit(70)
  glucoseMinimalMax: DataLocalStorage.asCurrentUnit(200)

  glucoseMaximal: DataLocalStorage.currentDataLine().glucoseMaximal
  glucoseMaximalChanged: -> @save()

  insulinPerCarbohydrates: DataLocalStorage.currentDataLine().insulinPerCarbohydrates
  insulinPerCarbohydratesChanged: -> @save()
  insulinPerCarbohydratesStep: 0.1
  insulinPerCarbohydratesMin: 0.1
  insulinPerCarbohydratesMax: 5

  glucosePerInsulin: DataLocalStorage.currentDataLine().glucosePerInsulin
  glucosePerInsulinChanged: -> @save()
  glucosePerInsulinStep: DataLocalStorage.getGlucoseUnit().step
  glucosePerInsulinMin: DataLocalStorage.asCurrentUnit(1)
  glucosePerInsulinMax: DataLocalStorage.asCurrentUnit(250)

  glucosePerCarbohydrates: DataLocalStorage.currentDataLine().glucosePerCarbohydrates
  glucosePerCarbohydratesChanged: -> @save()
  glucosePerCarbohydratesStep: DataLocalStorage.getGlucoseUnit().step
  glucosePerCarbohydratesMin: DataLocalStorage.asCurrentUnit(1)
  glucosePerCarbohydratesMax: DataLocalStorage.asCurrentUnit(250)

  glucose: DataLocalStorage.asCurrentUnit(120)
  glucoseChanged: -> @compute()
  glucoseStep: DataLocalStorage.getGlucoseUnit().step
  glucoseMin: DataLocalStorage.asCurrentUnit(1)
  glucoseMax: DataLocalStorage.asCurrentUnit(350)

  carbohydrates: 0
  carbohydratesChanged: -> @compute()
  carbohydratesStep: DataLocalStorage.getCarbohydatesUnit().step
  carbohydratesMin: DataLocalStorage.getCarbohydatesUnit().min
  carbohydratesMax: DataLocalStorage.getCarbohydatesUnit().max

  labels:
    editHour: "Aggregated time range"
    glucoseMinimum: "Target glucose in a few hours"
    insulinPerCarbohydrates: "Insulin per carbohydrate unit"
    glucosePerInsulin: "Glucose reduction per insulin unit"
    glucosePerCarbohydrates: "Glucose increase per carbohydrate unit"
    carbohydrates: "Targeted carbohydrate units"
    glucose: "Current glucose"

  compute: ->
    return if not @isDomReady()
    dataLine = @editDataLine()
    @glucoseMinimal = dataLine.glucoseMinimal
    @glucoseMaximal = dataLine.glucoseMaximal
    @insulinPerCarbohydrates = dataLine.insulinPerCarbohydrates
    @glucosePerInsulin = dataLine.glucosePerInsulin
    @glucosePerCarbohydrates = dataLine.glucosePerCarbohydrates
    [minimal,maximal] = dataLine.calculate(@glucose, @carbohydrates)
    @proposalInsulin = dataLine.proposeInsulin(@glucose, @carbohydrates)
    @proposalGlucose = Mathx.rounded(dataLine.comeOut(@glucose, @carbohydrates, @proposalInsulin), DataLocalStorage.getGlucoseUnit().step)
    @proposalCarbohydrates = Mathx.rounded(dataLine.proposeCarbohydrates(@glucose), 0.25)
    if @proposalCarbohydrates > @carbohydrates
      @carbohydrates = @proposalCarbohydrates
      @compute()

  save: ->
    return if not @isDomReady()
    dataLine = @editDataLine()
    dataLine.glucoseMinimal = @glucoseMinimal
    dataLine.glucoseMaximal = @glucoseMaximal
    dataLine.insulinPerCarbohydrates = @insulinPerCarbohydrates
    dataLine.glucosePerInsulin = @glucosePerInsulin
    dataLine.glucosePerCarbohydrates = @glucosePerCarbohydrates
    DataLocalStorage.save()
    @compute()

# --- debug pane ----------------------------------------------------------------------

  importExport: "---"

  reset: ->
    LocalStorage.clear()
    window.location.reload()

  export: ->
    @$.importExportArea.value = DataLocalStorage.export()

  import: ->
    DataLocalStorage.import(@$.importExportArea.value)
    @compute()
