React = require "react"
RN = require "react-native"
{ Text, StyleSheet, View, ScrollView } = RN
const styles = require("./app/js/styles")() |> StyleSheet.create(_)

studio_mobile = React.createClass({
  getInitialState: -> require("./app/js/main")(this),
  render: -> React.createElement(View, {style: styles.container}, [
    React.createElement( RN.StatusBar, {key: "statusbar", hidden: true}, [] ),
    React.createElement( View, {key: "status_string"}, [
      React.createElement( Text, {key: "status_string_state"}, this.state.app_status ),
    ]),
    React.createElement( ScrollView, {key: "main"}, [
      React.createElement( Text, {key: "maintxt"}, "Welcome to React Native!!!" ),
    ]),
    #
    # TODO
    #
  ])
})

RN.AppRegistry.registerComponent('studio_mobile', (-> studio_mobile))
