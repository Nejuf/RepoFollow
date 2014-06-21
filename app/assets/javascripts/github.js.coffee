# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ()->
  followRepo = (evt)->
    evt.preventDefault()
    $target = $(evt.currentTarget)
    repoId = $target.data('repo-id')

    $.ajax
      type: 'POST'
      url: "/repo/#{repoId}/follow"
      data: { }
      beforeSend: (jqXHR, settings)->
        $target.find('.js-container').html('loading...') # TODO replace with spinner

      success: (data)->
        $target.find('.js-container').html('unfollow')

      error: (jqXHR, textStatus, errorThrown)->
        $target.find('.js-container').html('follow')


  $('body').on('click', '.js-follow-repo', followRepo)


