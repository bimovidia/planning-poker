flashMsg = ->
  if $('.flash').length
    $('.flash').last().fadeIn('slow').siblings().remove()

    setTimeout(
      ->
        $('.flash').fadeOut('slow')
      3000
    )

flashNow = (flag, msg) ->
  $('#flash-container').append(
    "<div class= \"flash flash-" + flag + "\" data-dismiss=\"alert\">" + 
    "<div class=\"flash-message\">" + msg + "</div></div>"
  )

  flashMsg()

displayOverlay = ->
  $('#overlay').fadeIn()

hideOverlay = ->
  $('#overlay').fadeOut()

menuClick = ->
  $('#menu a, #menu-compact-list a').on 'click', () -> displayOverlay()

activeVote = ->
  $('.btn-votes a').on 'click', () -> 
    $(this).not('.action-vote').addClass('active')
    $(this).siblings().removeClass('active')

fayeSetup = ->
  publisher = new Faye.Client('//' + window.publisher + '/faye')

  publisher.addExtension outgoing: (message, callback) ->
    message.ext = token: window.pubtoken if message.channel is '/meta/subscribe'
    callback message

  publisher

fayeSubscribers = ->
  unless window.environment is 'test'
    if $('#authenticated').length
      fayeSetup().subscribe '/planning-poker/story/add-vote', (data) -> eval(data)
      fayeSetup().subscribe '/planning-poker/story/reset-vote', (data) -> eval(data)
      fayeSetup().subscribe '/planning-poker/story/select-vote', (data) -> eval(data)
      fayeSetup().subscribe '/planning-poker/story/reveal-votes', (data) -> eval(data)
      fayeSetup().subscribe '/planning-poker/story/update-story', (data) -> eval(data)
      fayeSetup().subscribe '/planning-poker/story/toggle-voters', (data) -> eval(data)
      fayeSetup().subscribe '/planning-poker/story/discussion-timer', (data) -> eval(data)

window.hideOverlay = hideOverlay
window.activeVote  = activeVote
window.flashNow    = flashNow

$(document).ready(flashMsg)
$(document).ready(menuClick)
$(document).ready(activeVote)
$(document).ready(fayeSubscribers)

$(document).on('page:load', flashMsg)
$(document).on('page:load', menuClick)
$(document).on('page:load', fayeSubscribers)

document.addEventListener('page:fetch', displayOverlay)
document.addEventListener('page:receive', hideOverlay)
document.addEventListener('page:change', hideOverlay)