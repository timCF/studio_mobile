React = require "react"
RN = require "react-native"
const styles = require("./app/js/styles")() |> RN.StyleSheet.create(_)
Calendar = require("react-native-calendar").default

cal_opts = {
  key: "calendar"
  #scrollEnabled: true      # False disables swiping. Default: False
  showControls: true        # False hides prev/next buttons. Default: False
  showEventIndicators: true # False hides event indicators. Default:False
  titleFormat: 'MMMM YYYY'  # Format for displaying current month. Default: 'MMMM YYYY'
  dayHeadings: ['ВС', 'ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ']
  monthNames:  ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
  prevButtonText: 'назад'   # Text for previous button. Default: 'Prev'
  nextButtonText: 'вперёд'  # Text for next button. Default: 'Next'
  onDateSelect: (date) --> console.log("SELECTED", date)
  #onTouchPrev={this.onTouchPrev}    // Callback for prev touch event
  #onTouchNext={this.onTouchNext}    // Callback for next touch event
  #onSwipePrev={this.onSwipePrev}    // Callback for back swipe event
  #onSwipeNext={this.onSwipeNext}    // Callback for forward swipe event
  eventDates: ['2016-12-07', '2016-12-05', '2016-12-28', '2016-12-30']
  events: [{date: '2016-12-06', hasEventCircle: {backgroundColor: 'powderblue'}}]
  #today={'2016-16-05'}              // Defaults to today
  #startDate={'2015-08-01'}          // The first month that will display. Default: current month
  #selectedDate={'2015-08-15'}       // Day to be selected
  #customStyle={{day: {fontSize: 15, textAlign: 'center'}}} // Customize any pre-defined styles
  weekStart: 1              # Day on which week starts 0 - Sunday, 1 - Monday, 2 - Tuesday, etc, Default: 1
}

studio_mobile = React.createClass({
  getInitialState: -> require("./app/js/main")(this),
  render: -> React.createElement( RN.View, {style: styles.root}, [
    React.createElement( RN.StatusBar, {key: "status_bar", hidden: true}, [] ),
    React.createElement( RN.View, {key: "status_string"}, [
      React.createElement( RN.Text, {key: "status_string_state"}, this.state.app_status ),
    ]),
    React.createElement( RN.ScrollView, {key: "main", contentContainerStyle: styles.calendar}, [
      React.createElement( Calendar, cal_opts, []),
      #
      # TODO : dynamic width
      #
      #React.createElement( RN.Picker, {key: "pick", selectedValue: "foo", onValueChange: ((data) -> console.log("picked", data))}, [
      #  React.createElement( RN.Picker.Item, {key: "pick_1", label: "JAVA", value: "foo"}, []),
      #  React.createElement( RN.Picker.Item, {key: "pick_2", label: "ERLANG", value: "bar"}, []),
      #]),
    ]),
  ])
})

RN.AppRegistry.registerComponent('studio_mobile', (-> studio_mobile))
