React = require "react"
{ AppRegistry, Text, StyleSheet, View } = require "react-native"

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
})

class studio_mobile extends React.Component
  render: ->
    React.createElement(View, style: styles.container, [
      React.createElement(Text, {style: styles.welcome, key: "title"}, "Welcome to React Native!!!"),
      React.createElement(Text, {style: styles.instructions, key: "help"}, "To get started, edit index.ios.js"),
      React.createElement(Text, {style: styles.instructions, key: "instr"}, "Press Cmd+R to reload,\nCmd+D or shake for dev menu"),
    ])

AppRegistry.registerComponent('studio_mobile', (-> studio_mobile))

jf = require("jsfunky")
jQuery = {ajax: require("component-ajax")}
jQuery.extend = (some) --> jf.merge(jQuery, some)
global.jQuery = jQuery
require("bulletjs")
bullet = jQuery.bullet("wss://ls.cu.cc/admin/bullet")
bullet.onopen = -> console.log("соединение с сервером установлено")
bullet.ondisconnect = -> utils.error("соединение с сервером потеряно")
bullet.onclose = -> utils.warn("соединение с сервером закрыто")
bullet.onheartbeat = -> console.log("tick ...")
bullet.onmessage = (data) --> console.log(data)
