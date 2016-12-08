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

concat = (l1, l2) --> (l1 ++ l2)

maybe_room_color = (state) ->
  this_room = state.current.room_id
  if (this_room != "")
    {backgroundColor: state.dicts.rooms_full[this_room].color}
  else
    {}

render_options = (state) -->
  [
    [React.createElement( RN.Picker.Item, {key: "options_location_empty", label: "выберите базу", value: ""})]
    |> concat(_,  state.response_state.locations.map((el) --> React.createElement( RN.Picker.Item, {key: "options_location_#{el.id.toString()}", label: el.name, value: el.id.toString()})))
    |> React.createElement( RN.Picker, {key: "options_location", style: styles.fill50, selectedValue: state.current.location_id, onValueChange: state.utils.set_location}, _)
  ]
  |> concat(_,
    if (state.current.location_id == "")
      []
    else
      [
        [React.createElement( RN.Picker.Item, {key: "options_room_empty", label: "выберите комнату", value: ""})]
        |> concat(_,
          state.response_state.rooms
          |> [].filter.call(_, ({location_id: lid}) --> lid.toString() == state.current.location_id)
          |> [].map.call(_, (el) --> React.createElement( RN.Picker.Item, {key: "options_room_#{el.id.toString()}", color: el.color, label: el.name, value: el.id.toString()}))
        )
        |> React.createElement( RN.Picker, {key: "options_room", style: styles.fill50, selectedValue: state.current.room_id, onValueChange: state.utils.mutate_state(["current","room_id"], _)}, _)
      ]
  )
  |> React.createElement( RN.View, {key: "options", style: [styles.row, styles.fill]}, _)

studio_mobile = React.createClass({
  getInitialState: -> require("./app/js/main")(this),
  render: -> React.createElement( RN.View, {style: styles.root}, [
    React.createElement( RN.StatusBar, {key: "status_bar", hidden: true}),
    React.createElement( RN.View, {key: "status_string"}, [
      React.createElement( RN.Text, {key: "status_string_state", style: [styles.status_string, maybe_room_color(this.state)]}, this.state.app_status ),
    ]),
    React.createElement( RN.ScrollView, {key: "main", contentContainerStyle: styles.calendar},
      if this.state.ready2render
        [
          render_options(this.state),
          React.createElement(Calendar, cal_opts),
        ]
      else
        []
    ),
  ])
})

RN.AppRegistry.registerComponent('studio_mobile', (-> studio_mobile))
