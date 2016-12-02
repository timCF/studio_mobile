React = require "react"
RN = require "react-native"
const styles = require("./app/js/styles")() |> RN.StyleSheet.create(_)

studio_mobile = React.createClass({
  getInitialState: -> require("./app/js/main")(this),
  render: -> React.createElement( RN.View, {style: styles.container}, [
    React.createElement( RN.StatusBar, {key: "statusbar", hidden: true}, [] ),
    React.createElement( RN.View, {key: "status_string"}, [
      React.createElement( RN.Text, {key: "status_string_state"}, this.state.app_status ),
    ]),
    React.createElement( RN.ScrollView, {key: "main"}, [
      React.createElement( RN.Text, {key: "maintxt"}, "Welcome to React Native!!!" ),
    ]),
    #
    # TODO
    #
  ])
})

RN.AppRegistry.registerComponent('studio_mobile', (-> studio_mobile))
