React = require "react"
RN = require "react-native"
const styles = require("./app/js/styles")() |> RN.StyleSheet.create(_)
Calendar = require("react-native-calendar").default
jf = require("jsfunky")
moment = require("moment")
Button = require("apsl-react-native-button")
ModalPicker = require("react-native-modal-picker").default

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
  onDateSelect: (date) --> @.utils.mutate_state(["current","moment"], moment(date))
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
    React.createElement( ModalPicker, {
      key: "options_location",
      style: [styles.flex1],
      initValue: "выберите базу",
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
          style: [styles.flex1],
          initValue: (if state.current.room_id == "" then "выберите комнату" else state.dicts.rooms_full[state.current.room_id].name),
          cancelText: "отмена",
          onChange: ({key: key}) --> state.utils.mutate_state(["current","room_id"], key),
          data: state.response_state.rooms
                |> [].filter.call(_, ({location_id: lid}) --> lid.toString() == state.current.location_id)
                |> [].map.call(_, (el) --> {label: el.name, key: el.id.toString()})})
      ]
  )
  |> React.createElement( RN.View, {key: "options", style: [styles.row]}, _)

render_timeline = (state) -->
  mf = 'YYYY-MM-DD'
  mh = 'HH:mm'
  this_day = state.current.moment.format(mf)
  React.createElement( RN.View, {key: "timeline", style: [styles.row]}, [
    React.createElement( RN.View, {key: "timeline_scale", style: [styles.col, styles.flex1]}),
    React.createElement( RN.View, {key: "timeline_content", style: [styles.col, styles.flex1]},
      state.response_state.sessions
      |> [].filter.call(_, (el) --> (el.room_id.toString() == state.current.room_id) and (moment(el.time_from.toString() * 1000).format(mf) == this_day))
      |> [].map.call(_, (el, i) -->
        [React.createElement( RN.Text, {key: "timeline_#{i}", style: [styles.ceterText, styles.flex1, maybe_room_color(state)]}, "#{moment(el.time_from.toString() * 1000).format(mh)} - #{moment(el.time_to.toString() * 1000).format(mh)}" )]
        |> React.createElement( RN.View, {key: "timeline_wrapper_#{i}", style: [styles.row]}, _))
    ),
  ])

render_navbar = (state) ->
  [React.createElement( Button, {key: "navbar_calendar", style: [styles.flex1, styles.btn], onPress: ->}, state.utils.verbose_current_date())]
  |> concat(_,
    if (state.current.room_id == "")
      []
    else
      React.createElement( Button, {key: "navbar_room", style: [styles.flex1, styles.btn, maybe_room_color(state)], onPress: ->}, state.utils.verbose_current_room()))
  |> React.createElement( RN.View, {key: "navbar", style: [styles.row]}, _)

studio_mobile = React.createClass({
  getInitialState: -> require("./app/js/main")(this),
  render: -> React.createElement( RN.View, {style: [styles.col, styles.flex1]}, [
    React.createElement( RN.StatusBar, {key: "status_bar", hidden: true}),
    React.createElement( RN.ScrollView, {key: "main", contentContainerStyle: [styles.col]},
      if this.state.ready2render
        [
          [React.createElement(Calendar, jf.put_in(cal_opts, ["utils"], this.state.utils))]
          |> React.createElement( RN.View, {key: "calendar_wrapper", style: [{flexDirection: 'row', justifyContent: 'center', alignItems: 'center'}]}, _),
          render_options(this.state),
        ]
        |> concat(_, (if (this.state.current.room_id != "") then [render_timeline(this.state)] else []))
      else
        []
    ),
    render_navbar(this.state),
  ])
})

RN.AppRegistry.registerComponent('studio_mobile', (-> studio_mobile))
