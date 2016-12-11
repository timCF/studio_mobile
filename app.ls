React = require "react"
RN = require "react-native"
const styles = require("./app/js/styles")() |> RN.StyleSheet.create(_)
Calendar = require("react-native-calendar").default
jf = require("jsfunky")
moment = require("moment")
Button = require("apsl-react-native-button")
ModalPicker = require("react-native-modal-picker").default
InvertableScroll = require("react-native-invertible-scroll-view")
CELL_HEIGHT = 30
MF = 'YYYY-MM-DD'

cal_opts = (utils) --> {
  key: "calendar"
  #scrollEnabled: true      # False disables swiping. Default: False
  showControls: true        # False hides prev/next buttons. Default: False
  showEventIndicators: true # False hides event indicators. Default:False
  titleFormat: 'MMMM YYYY'  # Format for displaying current month. Default: 'MMMM YYYY'
  dayHeadings: ['ВС', 'ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ']
  monthNames:  ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
  prevButtonText: 'назад'   # Text for previous button. Default: 'Prev'
  nextButtonText: 'вперёд'  # Text for next button. Default: 'Next'
  onDateSelect: (date) --> utils.mutate_state(["current","moment"], moment(date))
  #onTouchPrev={this.onTouchPrev}    // Callback for prev touch event
  #onTouchNext={this.onTouchNext}    // Callback for next touch event
  #onSwipePrev={this.onSwipePrev}    // Callback for back swipe event
  #onSwipeNext={this.onSwipeNext}    // Callback for forward swipe event
  eventDates: ['2016-12-07', '2016-12-05', '2016-12-28', '2016-12-30']
  events: [{date: '2016-12-06', hasEventCircle: {backgroundColor: 'powderblue'}}]
  today: utils.access_state(["current","moment"]).format(MF)
  startDate: utils.access_state(["current","moment"]).format(MF)
  selectedDate: utils.access_state(["current","moment"]).format(MF)
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
    React.createElement( ModalPicker, {
      key: "options_location",
      style: [styles.flex1, styles.margin3x],
      initValue: (if state.current.location_id == "" then "выберите базу" else state.dicts.locations_full[state.current.location_id].name),
      cancelText: "отмена",
      onChange: ({key: key}) --> state.utils.set_location(key),
      data: state.response_state.locations.map((el) --> {label: el.name, key: el.id.toString()})})
  ]
  |> concat(_,
    if (state.current.location_id == "")
      []
    else
      [
        React.createElement( ModalPicker, {
          key: "options_room",
          style: [styles.flex1, styles.margin2x],
          initValue: (if state.current.room_id == "" then "выберите комнату" else state.dicts.rooms_full[state.current.room_id].name),
          cancelText: "отмена",
          onChange: ({key: key}) --> state.utils.mutate_state(["current","room_id"], key),
          data: state.response_state.rooms
                |> [].filter.call(_, ({location_id: lid}) --> lid.toString() == state.current.location_id)
                |> [].map.call(_, (el) --> {label: el.name, key: el.id.toString()})})
      ]
  )
  |> React.createElement( RN.View, {key: "options", style: [styles.row]}, _)

render_timeline_axis = (state) -->
  ["09",10,11,12,13,14,15,16,17,18,19,20,21,22,23].map((n) -->
    [React.createElement( RN.Text, {key: "timeline_axis_#{n}", style: [styles.poor_text, styles.flex1]}, "#{n}:00")]
    |> React.createElement( RN.View, {key: "timeline_axis_wrapper_#{n}", style: [styles.row, styles.flex1, styles.cell, {height: CELL_HEIGHT}]}, _))
  |> React.createElement( RN.View, {key: "timeline_axis", style: [styles.col, styles.flex1]}, _)

render_timeline = (state) -->
  mf = 'YYYY-MM-DD'
  this_day = state.current.moment.format(mf)
  React.createElement( RN.View, {key: "timeline", style: [styles.row, styles.underlined]}, [
    render_timeline_axis(state),
    React.createElement( RN.View, {key: "timeline_content", style: [styles.col, {flex: 3}]},
      state.response_state.sessions
      |> [].filter.call(_, (el) --> (el.room_id.toString() == state.current.room_id) and (moment(el.time_from.toString() * 1000).format(mf) == this_day))
      |> [].map.call(_, ({time_from: tf, time_to: tt}) --> {time_from: moment(tf.toString() * 1000), time_to: moment(tt.toString() * 1000)})
      |> state.utils.timeline_content(_, React, RN, styles, maybe_room_color(state), CELL_HEIGHT)
    ),
  ])

render_calendar = (state) -->
  (
    if state.blocks.calendar
      [
        [React.createElement(Calendar, cal_opts(state.utils))]
        |> React.createElement( RN.View, {key: "calendar_wrapper", style: [{flexDirection: 'row', justifyContent: 'center', alignItems: 'center'}, styles.underlined]}, _)
      ]
    else
      []
  )
  |> concat(_, [React.createElement( Button, {key: "calendar_btn", textStyle: [styles.text], style: [styles.flex1, styles.btn], onPress: -> state.utils.mutate_state(["blocks","calendar"], not(state.blocks.calendar))},
    if state.blocks.calendar
      "свернуть календарь"
    else
      state.utils.verbose_current_date())])

studio_mobile = React.createClass({
  getInitialState: -> require("./app/js/main")(this),
  render: -> React.createElement( RN.View, {style: [styles.col, styles.flex1]}, [
    React.createElement( RN.StatusBar, {key: "status_bar", hidden: true}),
    React.createElement( InvertableScroll, {key: "main", inverted: true, contentContainerStyle: [styles.col]},
      if this.state.ready2render
        (if (this.state.current.room_id != "") then [render_timeline(this.state)] else [])
        |> concat(_, render_calendar(this.state))
        |> concat(_, [render_options(this.state)])
        |> [].reverse.call(_)
      else
        []
    ),
  ])
})

RN.AppRegistry.registerComponent('studio_mobile', (-> studio_mobile))
