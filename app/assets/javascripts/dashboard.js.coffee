filterStories = ->
  $('#sub-menu li').on 'click', ->
    $(this).addClass('selected').siblings().removeClass('selected')
    filterState(this)

filterState = (selector) ->
  switch $(selector).prop('id')
    when 'filter-unestimated'
      $('.story').not('.story-unestimated').hide()
      $('.story-unestimated').show()
    else $('.story').show()

selectCard = ->
  $('.card-revealed').on 'click', ->
    vote = $(this).parent().data('vote').split('-')

    $.ajax
      type:     'POST'
      url:      '/select-vote'
      data:     { story_id: vote[0], username: vote[1] }
      dataType: 'script'

window.filterState = filterState
window.selectCard  = selectCard

$(document).ready(filterStories)
$(document).ready(selectCard)