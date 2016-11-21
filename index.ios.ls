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



proto2base64 = require('base64-arraybuffer')
builder = require("protobufjs").loadProto(require("./app/sproto"), {file: "studio.proto", root: "a"})
proto = builder.build().lemooor.studio



stringifyEnums = (message) -->
  if (message and message.$type and message.$type.children)
    message.$type.children.forEach((child) ->
      field = child.name
      if (message[field] and child.element.resolvedType)
        switch child.element.resolvedType.className
          when 'Enum'
            dict = child.element.resolvedType.children.reduce(((acc, {id: id, name: name}) -> acc[id] = name ; acc), {})
            if child.repeated
              message[field] = message[field].map((el) -> if dict[el] then dict[el] else el)
            else
              if dict[message[field]] then message[field] = dict[message[field]]
          when 'Message'
            if child.repeated
              message[field] = message[field].map((el) -> stringifyEnums(el))
            else
              message[field] = stringifyEnums(message[field]))
  message
decode_proto = (data) -->
  try
    stringifyEnums( proto.Response.decode64( data.data ) )
  catch error
    "protobuf decode error "+error+" raw data : "+data
encode_proto = (data) -->
  proto2base64.encode( proto.Request.encode(data).toArrayBuffer() )



jf = require("jsfunky")
jQuery = {ajax: require("component-ajax")}
jQuery.extend = (some) --> jf.merge(jQuery, some)
global.jQuery = jQuery
require("bulletjs")
bullet = jQuery.bullet("ws://127.0.0.1:7773/bullet")
bullet.onopen = -> console.log("соединение с сервером установлено")
bullet.ondisconnect = -> console.log("соединение с сервером потеряно")
bullet.onclose = -> console.log("соединение с сервером закрыто")
bullet.onheartbeat = -> console.log("tick ...")
bullet.onmessage = (data) -->
  data
  |> decode_proto(_)
  |> console.log(_)
