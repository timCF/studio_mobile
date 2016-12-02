module.exports = (state, root_component) -->
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
    #
    # TODO : do it normal way
    #
    state.app_status = "соединение с сервером установлено"
    root_component.setState(state)
    console.log("соединение с сервером установлено")
  bullet.ondisconnect = -> console.log("соединение с сервером потеряно")
  bullet.onclose = -> console.log("соединение с сервером закрыто")
  bullet.onheartbeat = -> console.log("tick ...")
  bullet.onmessage = (data) -->
    data
    |> utils.decode_proto(_)
    |> console.log(_)
  state
