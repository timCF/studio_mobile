module.exports = (state) -->
  {utils: utils} = state
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
  bullet = jQuery.bullet("ws://193.70.100.32:7773/bullet")
  bullet.onopen = ->
    utils.mutate_state(["app_status"], "соединение с сервером установлено")
    console.log(state.app_status)
    utils.get_latest_state()
  bullet.ondisconnect = ->
    utils.mutate_state(["app_status"], "соединение с сервером потеряно")
    console.log(state.app_status)
  bullet.onclose = ->
    utils.mutate_state(["app_status"], "соединение с сервером закрыто")
    console.log(state.app_status)
  bullet.onheartbeat = ->
    console.log("ping ...")
    msg = utils.new_message()
    msg.cmd = 'CMD_ping'
    utils.to_server(msg)
  bullet.onmessage = (data) -->
    message = utils.decode_proto(data)
    console.log("incoming message from server", message)
    utils.handle_message(message)
  utils.to_server = (message) -->
    console.log("sending message to server", message)
    message
    |> utils.encode_proto(_)
    |> bullet.send(_)
  state
