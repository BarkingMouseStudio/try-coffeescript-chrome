  $source = $('#source')
  $results = $('#results')
  source = CodeMirror.fromTextArea(document.getElementById('source'), {
    matchBrackets: true,
    smartIndent: false
  })
  results = CodeMirror.fromTextArea document.getElementById('results'), {
    matchBrackets: true,
    smartIndent: false
  }
  $error = $('#error')
  $try = $('#try')

  sourceCode = localStorage.getItem('source')
  source.setValue sourceCode if sourceCode
  resultsCode = localStorage.getItem('results')
  results.setValue resultsCode if resultsCode

  handle_error = (message) -> $error.text(message).show()

  run = (e) ->
    e.preventDefault()
    try eval(resultsCode)
    catch error then handle_error(error.message)

  compile = ->
    sourceCode = source.getValue()
    localStorage.setItem('source', sourceCode)

    try
      resultsCode = CoffeeScript.compile(sourceCode, bare: on)
      localStorage.setItem('results', resultsCode)
      results.setValue resultsCode
      $error.hide()
    catch error then handle_error(error.message)

  decompile = ->
    resultsCode = results.getValue()
    localStorage.setItem('results', resultsCode)

    try
      sourceCode = Js2coffee.build(resultsCode)
      localStorage.setItem('source', sourceCode);
      source.setValue sourceCode
      $error.hide()
    catch error
      handle_error(error.message)

  $('#source_con').bind('keyup', compile)
  $('#results_con').bind('keyup', decompile)
  $try.bind('click', run)
