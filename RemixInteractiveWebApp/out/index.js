(function() {
  var getColor, ischrome, location, port, safeColor, socket;

  console.log('Hi');

  location = 0;

  port = '4444';

  socket = io.connect('54.186.206.127:' + port + '/ios', {
    'force new connection': true,
    timeout: 3000
  });

  socket.on('connect', function() {
    console.log('connect');
    return socket.on('message', function(strMessage) {
      var jawn;
      jawn = strMessage.substr(1);
      jawn = jawn.substring(0, jawn.length - 1);
      jawn = jawn.split('}{');
      return $('#content').css('background-color', getColor(jawn[location]));
    });
  });

  getColor = function(strColor) {
    console.log(strColor);
    strColor = strColor.split(',');
    strColor = 'rgba(' + safeColor(strColor[0] * 255) + ',' + safeColor(strColor[1] * 255) + ',' + safeColor(strColor[2] * 255) + ',' + strColor[3] + ')';
    console.log(strColor);
    return strColor;
  };

  safeColor = function(f) {
    f = Math.round(f);
    f = Math.max(0, f);
    return f = Math.min(f, 255);
  };

  $(document).ready(function() {
    if (ischrome()) {
      $('#fullscreen').show();
    }
    return $('#fullscreen').on('click', function() {
      if (document.webkitFullscreenEnabled) {
        document.getElementById('content').webkitRequestFullscreen();
      }
    });
  });

  $(document).on('webkitfullscreenchange', function() {
    if (document.webkitIsFullScreen) {
      return $('#fullscreen').hide();
    } else {
      return $('#fullscreen').show();
    }
  });

  $('#locateMeGraphic td').on('click', function(e) {
    location = $(this).html();
    $('#locateMeGraphic').hide();
  });

  ischrome = function() {
    return navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
  };

  socket.on('connecting', function() {
    return console.log('connecting');
  });

  socket.on('disconnect', function() {
    return console.log('disconnect');
  });

  socket.on('connect_failed', function() {
    return console.log('connect_failed');
  });

  socket.on('reconnect', function() {
    return console.log('reconnect');
  });

  socket.on('reconnecting', function() {
    return console.log('reconnecting');
  });

  socket.on('reconnect_failed', function() {
    return console.log('reconnect_failed');
  });

}).call(this);
