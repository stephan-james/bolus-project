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

class UnitStorageData extends StorageData

  constructor: (name, unit) ->
    super name,
      selected: false
      unit: unit

  isSelected: ->
    @data.selected

  setUnit: (unit) ->
    @data.selected = true
    @data.unit = unit
    @save()

  getUnit: ->
    @data.unit

  getId: ->
    @getUnit().id

  getCurrentStep: ->
    @getUnit().step

  @asUnit = (id) ->
    id: id

# -------------------------------------------------------------------------------------------------

class LanguageUnit extends UnitStorageData

  @LANGUAGES =
    "en":
      "language-en": "English"
      "language-de": "Deutsch"
      "language-es": "Español"
      "hour": "hour"
      "editHour": "Aggregated time range"
      "glucoseMinimum": "Target glucose in a few hours"
      "insulinPerCarbohydrates": "Insulin per carbohydrate unit"
      "glucosePerInsulin": "Glucose reduction per insulin unit"
      "glucosePerCarbohydrates": "Glucose increase per carbohydrate unit"
      "glucose": "Current glucose"
      "carbohydrates": "Targeted carbohydrate units"
      "step": "Step"
      "stepOf": "of"
      "languageQuestion": "Prefered language"
      "languageExplanation": ""
      "disclaimerTitle": "Disclaimer"
      "disclaimer": """
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"""
      "chooseMoreInfo": "More info..."
      "chooseDecline": "Decline"
      "chooseAccept": "Accept"
      "glucoseUnitQuestion": "Which glucose measurement unit is the right for you?"
      "glucoseUnitExplanation": "Which glucose measurement unit is the right for you?"
      "carbohydratesUnitQuestion": "Which unit do you prefer for your carbohydrates?"
      "carbohydratesUnitExplanation": "Which unit do you prefer for your carbohydrates?"
    "de":
      "hour": "Stunde"
      "editHour": "Aggregierte Uhrzeit"
      "glucoseMinimum": "Zielglukosespiegel"
      "insulinPerCarbohydrates": "Insulin pro Broteinheit"
      "glucosePerInsulin": "Glukosereduktion pro I.E."
      "glucosePerCarbohydrates": "Glukoseanstieg pro B.E."
      "glucose": "Aktueller Glukosewert"
      "carbohydrates": "Gewünschte B.E."
      "step": "Schritt"
      "stepOf": "von"
      "disclaimerTitle": "Wichtiger Hinweis"
    #"disclaimer": "...@todo"
      "chooseMoreInfo": "Mehr Infos..."
      "chooseDecline": "Ablehnen"
      "chooseAccept": "Akzeptieren"
      "glucoseUnitQuestion": "Bevorzugte Glukoseeinheit"
      "glucoseUnitExplanation": "Die Glukoseeinheit wird in der Regel auf dem Display Ihres Messgerätes angegeben. In Deutschland ist die häufigst verwendete Glukoseeinheit mg/dL."
      "carbohydratesUnitQuestion": "Bevorzugte Kohlenhydrateinheit"
      "carbohydratesUnitExplanation": "In Deutschland ist die häufigst verwendete Kohlenhydrateinheit die Broteinheit mit 12 mg pro Portion."
    "es":
      "hour": "hora"
      "editHour": "Agregada hora del día"
      "glucoseMinimum": "Target valor de glucosa"
      "insulinPerCarbohydrates": "La insulina por unidad de pan"
      "glucosePerInsulin": "Reducción de glucosa por I.E."
      "glucosePerCarbohydrates": "Aumento de glucosa por B.E."
      "glucose": "Valor actual de glucosa"
      "carbohydrates": "Carbohidratos"
      "step": "Paso"
      "stepOf": "de los"
      "disclaimerTitle": "Nota importante"
    #"disclaimer": "...@todo"
      "chooseMoreInfo": "Más Infos..."
      "chooseDecline": "Rechazar"
      "chooseAccept": "Aceptar"
      "glucoseUnitQuestion": "Unidad de glucosa preferida"
      "glucoseUnitExplanation": ""
      "carbohydratesUnitQuestion": "Resto de carbohidrato preferidos"
      "carbohydratesUnitExplanation": ""

  getText: (code) ->
    text = LanguageUnit.LANGUAGES[@getId()][code]
    if text?
      text
    else
      text = LanguageUnit.LANGUAGES["en"][code]
      if text?
        text
      else
        Log.warn("LanguageUnit: '#{code}' not found")
        "(#{code} not found)"

  @getLanguageIds: ->
    Object.keys(LanguageUnit.LANGUAGES)

languageUnit = new LanguageUnit("LanguageUnit", UnitStorageData.asUnit("en"))

# -------------------------------------------------------------------------------------------------

disclaimerUnit = new UnitStorageData("DisclaimerUnit", {})

# -------------------------------------------------------------------------------------------------

class GlucoseUnit extends UnitStorageData

  @MMOL_L =
    id: "mmol/l"
    step: 0.25

  @MG_DL =
    id: "mg/dl"
    step: 5

  to_mmol_l: (mg_dl) ->
    Mathx.rounded(mg_dl * 0.0555, GlucoseUnit.MMOL_L.step)

  to_mg_dl: (mmol_l) ->
    Mathx.rounded(mmol_l * 18.0182, GlucoseUnit.MG_DL.step)

  switch: (glucoseUnit, glucose) ->
    if glucoseUnit == GlucoseUnit.MG_DL
      @to_mg_dl(glucose)
    else
      @to_mmol_l(glucose)

  mgdlToCurrent: (glucoseInMgPerDL) ->
    if @getId() == GlucoseUnit.MG_DL.id
      glucoseInMgPerDL
    else
      @to_mmol_l(glucoseInMgPerDL)

glucoseUnit = new GlucoseUnit("GlucoseUnit", GlucoseUnit.MG_DL)

# -------------------------------------------------------------------------------------------------

class CarbohydratesUnit extends UnitStorageData

  @MG_1 =
    id: "1 mg"
    factor: 1
    step: 5
    min: 0
    max: 15 * 12
    insulinPerCarbohydrates:
      default: 0.08
      step: 0.01
      min: 0.01
      max: 1.60

  @MG_10 =
    id: "10 mg"
    factor: 10
    step: 0.25
    min: 0
    max: 15 * 12 / 10
    insulinPerCarbohydrates:
      default: 0.85
      step: 0.05
      min: 0.05
      max: 18.0

  @MG_12 =
    id: "12 mg"
    factor: 12
    step: 0.25
    min: 0
    max: 15
    insulinPerCarbohydrates:
      default: 1.0
      step: 0.1
      min: 0.1
      max: 20.0

  getCurrentMin: ->
    @getUnit().min

  getCurrentMax: ->
    @getUnit().max

  getInsulinPerCarbohydratesDefault: ->
    @getUnit().insulinPerCarbohydrates.default

  getInsulinPerCarbohydratesStep: ->
    @getUnit().insulinPerCarbohydrates.step

  getInsulinPerCarbohydratesMin: ->
    @getUnit().insulinPerCarbohydrates.min

  getInsulinPerCarbohydratesMax: ->
    @getUnit().insulinPerCarbohydrates.max

carbohydratesUnit = new CarbohydratesUnit("CarbohydratesUnit", CarbohydratesUnit.MG_12)

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
    Math.round(g - Math.max(0, i - @bolus(c)) * @glucosePerInsulin + Math.max(0,
      @bolus(c) - i) / @insulinPerCarbohydrates * @glucosePerCarbohydrates)

  proposeInsulin: (g, c) ->
    if g < @glucoseMinimal and c > 0
      c = Math.max(0, c - ((@glucoseMinimal - g) / @glucosePerCarbohydrates))
    Math.floor(@correctionMinimum(g) + @bolus(c))

  proposeCarbohydrates: (g) ->
    Math.abs(Math.min(0.0, ( g - @glucoseMinimal ) / @glucosePerCarbohydrates))

  switchGlucoseUnit: (glucoseUnit) ->
    @glucoseMinimal = glucoseUnit.switch(glucoseUnit, @glucoseMinimal)
    @glucoseMaximal = glucoseUnit.switch(glucoseUnit, @glucoseMaximal)
    @glucosePerInsulin = glucoseUnit.switch(glucoseUnit, @glucosePerInsulin)
    @glucosePerCarbohydrates = glucoseUnit.switch(glucoseUnit, @glucosePerCarbohydrates)

  switchCarbohydratesUnit: (carbohydratesUnit) ->
    # todo
    @insulinPerCarbohydrates = 1.0

# -------------------------------------------------------------------------------------------------

class DataLinesStorage extends StorageData

  @HOURS = [0..23]

  constructor: ->
    super "DataLinesStorage",
      creationTime: Datex.currentTime()
      initialized: false
      dataLines: (new DataLine(80, 160, 1, 75, 85) for i in DataLinesStorage.HOURS)

  load: ->
    super
    @objectifyDataLines()

  objectifyDataLines: ->
    @data.dataLines = (new DataLine(i.glucoseMinimal, i.glucoseMaximal, i.insulinPerCarbohydrates, i.glucosePerInsulin,
      i.glucosePerCarbohydrates) for i in @data.dataLines)

  isInitialized: ->
    @data.initialized

  dataLine: (hour) ->
    @data.dataLines[hour]

  currentDataLine: ->
    @dataLine(Datex.currentHour())

  initialize: ->
    @data.initialized = true
    @data.dataLines = (@createDataLine() for i in DataLinesStorage.HOURS)
    @save()

  createDataLine: ->
    new DataLine(glucoseUnit.mgdlToCurrent(80), glucoseUnit.mgdlToCurrent(160), carbohydratesUnit.getInsulinPerCarbohydratesDefault(), glucoseUnit.mgdlToCurrent(75), glucoseUnit.mgdlToCurrent(85))

  export: ->
    JSON.stringify(@data)

  import: (data) ->
    try
      @data = JSON.parse(data)
      @objectifyDataLines()
    catch exception
      alert(exception)

DataLinesStorage = new DataLinesStorage()

# -------------------------------------------------------------------------------------------------

Polymerase.setup "bp-bolus",

  onDomReady: ->
    @nextStep()

  nextStep: ->
    if not languageUnit.isSelected()
      @$.chooseLanguageUnitDialog.opened = true
    else if not disclaimerUnit.isSelected()
      @$.disclaimerDialog.opened = true
    else if not glucoseUnit.isSelected()
      @$.chooseGlucoseUnitDialog.opened = true
    else if not carbohydratesUnit.isSelected()
      @$.chooseCarbohydratesUnitDialog.opened = true
    else if not DataLinesStorage.isInitialized()
      DataLinesStorage.initialize()
      window.location.reload()
    else
      @startUsage()

  startUsage: ->
      @carbohydrates = 0
      @glucose = glucoseUnit.mgdlToCurrent(120)
      @editHour = Datex.currentHour()
      @compute()

  selectAction: (event, detail, target) ->
    @$.pages.selected = event.target.getAttribute('num')

  chooseLanguage: (event, detail, target) ->
    languageId = event.target.getAttribute('language-id')
    languageUnit.setUnit(UnitStorageData.asUnit(languageId))
    window.location.reload()

  chooseMoreInfo: ->
    window.location.href = "http://stephan-james.github.io/bolus-project/application/#more-info"

  chooseDecline: ->
    window.location.href = "http://stephan-james.github.io/bolus-project/application/#declined"

  chooseAccept: ->
    disclaimerUnit.setUnit(null)
    @nextStep()

  chooseMmolPerL: ->
    @chooseGlucoseUnit(GlucoseUnit.MMOL_L)

  chooseMgPerDl: ->
    @chooseGlucoseUnit(GlucoseUnit.MG_DL)

  chooseGlucoseUnit: (unit) ->
    glucoseUnit.setUnit(unit)
    @nextStep()

  chooseMG1: ->
    @chooseCarbohydratesUnit(CarbohydratesUnit.MG_1)

  chooseMG10: ->
    @chooseCarbohydratesUnit(CarbohydratesUnit.MG_10)

  chooseMG12: ->
    @chooseCarbohydratesUnit(CarbohydratesUnit.MG_12)

  chooseCarbohydratesUnit: (unit) ->
    carbohydratesUnit.setUnit(unit)
    @nextStep()

  initByEditDataLine: ->
    dataLine = @editDataLine()
    @glucoseMinimal = dataLine.glucoseMinimal
    @glucoseMaximal = dataLine.glucoseMaximal
    @insulinPerCarbohydrates = dataLine.insulinPerCarbohydrates
    @glucosePerInsulin = dataLine.glucosePerInsulin
    @glucosePerCarbohydrates = dataLine.glucosePerCarbohydrates

  editDataLine: ->
    DataLinesStorage.dataLine(@editHour)

  proposalInsulin: 0
  proposalGlucose: glucoseUnit.mgdlToCurrent(120)
  proposalCarbohydrates: 0

  editHour: 0
  editHourChanged: -> @compute()
  editHourStep: 1
  editHourMin: 0
  editHourMax: 23

  glucoseMinimal: DataLinesStorage.currentDataLine().glucoseMinimal
  glucoseMinimalChanged: -> @save()
  glucoseMinimalStep: glucoseUnit.getCurrentStep()
  glucoseMinimalMin: glucoseUnit.mgdlToCurrent(70)
  glucoseMinimalMax: glucoseUnit.mgdlToCurrent(200)

  glucoseMaximal: DataLinesStorage.currentDataLine().glucoseMaximal
  glucoseMaximalChanged: -> @save()

  insulinPerCarbohydrates: DataLinesStorage.currentDataLine().insulinPerCarbohydrates
  insulinPerCarbohydratesChanged: -> @save()
  insulinPerCarbohydratesStep: carbohydratesUnit.getInsulinPerCarbohydratesStep()
  insulinPerCarbohydratesMin: carbohydratesUnit.getInsulinPerCarbohydratesMin()
  insulinPerCarbohydratesMax: carbohydratesUnit.getInsulinPerCarbohydratesMax()

  glucosePerInsulin: DataLinesStorage.currentDataLine().glucosePerInsulin
  glucosePerInsulinChanged: -> @save()
  glucosePerInsulinStep: glucoseUnit.getCurrentStep()
  glucosePerInsulinMin: glucoseUnit.mgdlToCurrent(5)
  glucosePerInsulinMax: glucoseUnit.mgdlToCurrent(250)

  glucosePerCarbohydrates: DataLinesStorage.currentDataLine().glucosePerCarbohydrates
  glucosePerCarbohydratesChanged: -> @save()
  glucosePerCarbohydratesStep: glucoseUnit.getCurrentStep()
  glucosePerCarbohydratesMin: glucoseUnit.mgdlToCurrent(5)
  glucosePerCarbohydratesMax: glucoseUnit.mgdlToCurrent(250)

  glucose: glucoseUnit.mgdlToCurrent(120)
  glucoseChanged: -> @compute()
  glucoseStep: glucoseUnit.getCurrentStep()
  glucoseMin: glucoseUnit.mgdlToCurrent(5)
  glucoseMax: glucoseUnit.mgdlToCurrent(350)

  carbohydrates: 0
  carbohydratesChanged: -> @compute()
  carbohydratesStep: carbohydratesUnit.getCurrentStep()
  carbohydratesMin: carbohydratesUnit.getCurrentMin()
  carbohydratesMax: carbohydratesUnit.getCurrentMax()

  labels:
    editHour: "#{languageUnit.getText('editHour')} [#{languageUnit.getText('hour')}]"
    glucoseMinimum: "#{languageUnit.getText('glucoseMinimum')} [#{glucoseUnit.getId()}]"
    insulinPerCarbohydrates: "#{languageUnit.getText('insulinPerCarbohydrates')} [ie]"
    glucosePerInsulin: "#{languageUnit.getText('glucosePerInsulin')} [#{glucoseUnit.getId()}]"
    glucosePerCarbohydrates: "#{languageUnit.getText('glucosePerCarbohydrates')} [#{glucoseUnit.getId()}]"
    glucose: "#{languageUnit.getText('glucose')} [#{glucoseUnit.getId()}]"
    carbohydrates: "#{languageUnit.getText('carbohydrates')} [#{carbohydratesUnit.getId()}]"

  text: (code) ->
    languageUnit.getText(code)

  languageIds: LanguageUnit.getLanguageIds()

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
    @proposalGlucose = Mathx.rounded(dataLine.comeOut(@glucose, @carbohydrates, @proposalInsulin), glucoseUnit.getCurrentStep())
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
    DataLinesStorage.save()
    @compute()

# --- debug pane ----------------------------------------------------------------------

  importExport: ""

  reset: ->
    if window.confirm("This will delete all local application data. Are you sure?")
      LocalStorage.clear()
      window.location.reload()

  export: ->
    @$.importExportArea.value = DataLinesStorage.export()

  import: ->
    DataLinesStorage.import(@$.importExportArea.value)
    @compute()
