request = require 'request'

array = []
show = (req,res)->
  whenDone = (array)->
    res.render 'tld', {tlds: array}
  getTldList req,res, whenDone

generate = (req, res, whenDone)->
  if array.length == 0
    getTldList req,res
  phrase = req.body.phrase
  console.log req.body
  phrase = phrase.replace(/\s+/g, '');
  console.log phrase

  if phrase
    result = []
    if array.length > 0
      for tld in array
        idx = 0 
        while idx >= 0
          idx = phrase.indexOf(tld, idx)
          if idx >= 0
            str = phrase.substring(0,idx) + ".#{tld}/" + phrase.substring(idx+ tld.length)
            result.push str
            idx += 1
    else
      getTldList req,res
    whenDone result

ajax = (req, res)->
  whenDone = (result) ->
    res.writeHead 200, {'Content-Type' : 'text/plain'}
    res.end JSON.stringify(result)

  generate req,res,whenDone


post = (req, res)->
    result = generate req,res
    #render response
    res.render 'tld', {results: result, tlds: array}


getTldList = (req, res, whenDone)->
  request 'http://data.iana.org/TLD/tlds-alpha-by-domain.txt', (err, response, body)->
    console.log 'fetching tld from iana.org'
    array = body.split "\n"
    #remove title of page
    array.shift()
    array.forEach (tld, idx)->
      array[idx] = tld.toLowerCase()
      #remove empty lines
      if tld == ""
        array.splice(idx,1)
    console.log 'done fetching from iana.org'

    whenDone(array)

exports.post = post
exports.show = show
exports.ajax = ajax