$error = $('#error')
$try = $('#try')

source = CodeMirror.fromTextArea(sourceEl = document.getElementById('source'), {
  mode: 'coffeescript',
  matchBrackets: true,
  smartIndent: false
})
results = CodeMirror.fromTextArea(resultsEl = document.getElementById('results'), {
  mode: 'javascript',
  matchBrackets: true,
  smartIndent: false
})

$source = $(sourceEl)
$results = $(resultsEl)

sourceCode = localStorage.getItem('source')
source.setValue sourceCode if sourceCode
resultsCode = localStorage.getItem('results')
results.setValue resultsCode if resultsCode

handle_error = (message) -> $error.text(message).show()

compile = ->
  console.log 'compile'
  sourceCode = source.getValue()
  localStorage.setItem('source', sourceCode)

  try
    resultsCode = CoffeeScript.compile(sourceCode, bare: on)
    localStorage.setItem('results', resultsCode)
    results.setValue resultsCode
    $error.hide()
  catch error then handle_error(error.message)

decompile = ->
  console.log 'decompile'
  resultsCode = results.getValue()
  localStorage.setItem('results', resultsCode)

  try
    sourceCode = Js2coffee.build(resultsCode)
    localStorage.setItem('source', sourceCode);
    source.setValue sourceCode
    $error.hide()
  catch error then handle_error(error.message)

$source.bind('keyup', compile)
$results.bind('keyup', decompile)

run = (e) ->
  e.preventDefault()
  try eval(resultsCode)
  catch error then handle_error(error.message)

$try.bind('click', run)
