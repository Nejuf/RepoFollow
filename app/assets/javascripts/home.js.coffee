# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
Handlebars.registerHelper 'timeFromDate', (dateString)->
  date = new Date(dateString)
  options =
    hour: 'numeric'
    minute: 'numeric'
  date.toLocaleTimeString("en-us", options)

$(document).ready ()->
  $('.js-feed-date').each (i, el)->
    date = $(el).data('date')
    $(el).html('Loading...') # TODO loading spinner
    $.getJSON '/', {'start': date, 'end': date},(data)->
      $feedDateContainer = $(".js-feed-date[data-date='#{date}']")
      $feedDateContainer.html('')
      data.forEach (date_info)->
        date_info['commits'].reverse().forEach (commit)->
          message = HandlebarsTemplates.feed_message(commit)
          $feedDateContainer.append(message)

