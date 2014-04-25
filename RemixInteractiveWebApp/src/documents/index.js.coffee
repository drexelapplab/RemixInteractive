console.log('Hi')
location = 0
port = '4444'
socket = io.connect('54.186.206.127:'+port+'/ios', {'force new connection':true, timeout: 3000})
socket.on 'connect', () -> 
  console.log('connect')
  socket.on 'message', (strMessage) ->
    # console.log strMessage
    jawn = strMessage.substr(1);
    jawn = jawn.substring(0, jawn.length - 1)
    jawn = jawn.split('}{')
    # console.log getColor(jawn[location])
    $('#content').css('background-color', getColor(jawn[location]))
getColor = (strColor) ->
  console.log strColor
  strColor = strColor.split(',')
  strColor = 'rgba(' + safeColor(strColor[0]*255) + ',' + safeColor(strColor[1]*255) + ',' + safeColor(strColor[2]*255) + ',' + strColor[3] + ')'
  console.log strColor
  return strColor

safeColor = (f) ->
  f = Math.round(f)
  f = Math.max(0,f)
  f = Math.min(f,255)

$(document).ready () ->
  if ischrome()
    $('#fullscreen').show()
  $('#fullscreen').on 'click', () ->
    if (document.webkitFullscreenEnabled)
      document.getElementById('content').webkitRequestFullscreen()
      return

$(document).on 'webkitfullscreenchange', () ->
  if (document.webkitIsFullScreen) 
    $('#fullscreen').hide()
   else 
    $('#fullscreen').show()

$('#locateMeGraphic td').on 'click', (e) ->
  # console.log $(this).html()
  location = $(this).html()
  $('#locateMeGraphic').hide()
  return

ischrome = () ->
  navigator.userAgent.toLowerCase().indexOf('chrome') > -1

# Debugging
socket.on 'connecting', () -> console.log('connecting')
socket.on 'disconnect', () -> console.log('disconnect')
socket.on 'connect_failed', () -> console.log('connect_failed')
socket.on 'reconnect', () -> console.log('reconnect')
socket.on 'reconnecting', () -> console.log('reconnecting')
socket.on 'reconnect_failed', () -> console.log('reconnect_failed')