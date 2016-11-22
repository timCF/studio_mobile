module.exports = (utils) -->
  jf = require("jsfunky")
  #
  # shitty workaround to make "bulletjs" library work
  #
  jQuery = {ajax: require("component-ajax")}
  jQuery.extend = (some) --> jf.merge(jQuery, some)
  global.jQuery = jQuery
  global.window.location = {host: ""}
  #
  #
  #
  require("bulletjs")
  bullet = jQuery.bullet("ws://127.0.0.1:7773/bullet")
  bullet.onopen = -> console.log("соединение с сервером установлено")
  bullet.ondisconnect = -> console.log("соединение с сервером потеряно")
  bullet.onclose = -> console.log("соединение с сервером закрыто")
  bullet.onheartbeat = -> console.log("tick ...")
  bullet.onmessage = (data) -->
    data
    |> utils.decode_proto(_)
    |> console.log(_)
  utils
