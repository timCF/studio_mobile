React = require "react"
RN = require "react-native"
const styles = require("./app/js/styles")() |> RN.StyleSheet.create(_)
Calendar = require("react-native-calendar").default

studio_mobile = React.createClass({
  getInitialState: -> require("./app/js/main")(this),
  render: -> React.createElement( RN.View, {style: styles.root}, [
    React.createElement( RN.StatusBar, {key: "status_bar", hidden: true}, [] ),
    React.createElement( RN.View, {key: "status_string"}, [
      React.createElement( RN.Text, {key: "status_string_state"}, this.state.app_status ),
    ]),
    React.createElement( RN.ScrollView, {key: "main", contentContainerStyle: styles.calendar}, [
      React.createElement( Calendar, {key: "calendar"}, []),
    ]),
  ])
})

RN.AppRegistry.registerComponent('studio_mobile', (-> studio_mobile))
