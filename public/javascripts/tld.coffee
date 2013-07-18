
$ ->
  $('form input.submit').on 'click', (event)->
    event.preventDefault()
    data =  $('form input.textInput').val()
    $.ajax '/tld.json',{
      type: 'POST'
      data: {phrase: data}
      success: (data, status)->
        data = JSON.parse data
        console.log data

        if data.length >0
          $('ul.domainList').empty()
          for tld in data
            $('ul.domainList').append("<li class=\"domainListItem\">#{tld}</li>")
        else
          $('ul.domainList').append(
            "<p id=\"noResult\">
                Your phrase does not contain any TLD :( it seems to have to use those lame .com
            </p>"
            )
      error: (jqXHR, textStatus, errorThrown)->
        alert "Error: #{textStatus} #{errorThrown}"
    }

