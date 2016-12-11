module.exports = (state, root_component) -->
  jf = require("jsfunky")
  moment = require("moment")
  verbose = {
    days_short: ['ВС', 'ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ'],
    days_long: [
      "Воскресенье",
      "Понедельник",
      "Вторник",
      "Среда",
      "Четверг",
      "Пятница",
      "Суббота",
    ],
    time_states: {
      free: "свободно",
      ordered: "занято",
    }
  }
  utils = {
    access_state: (path) --> jf.get_in(state, path)
    set_location: (data) -->
      if (state.current.location_id != data)
        state.current.location_id = data
        state.current.room_id = ""
        utils.render()
    get_latest_state: ->
      msg = utils.new_message()
      msg.cmd = 'CMD_get_state'
      utils.to_server(msg)
    render: -->
      console.log("RENDER", state)
      root_component.setState(state)
    mutate_state: (path, val) -->
      jf.put_in(state, path, val)
      utils.render()
    handle_message: (data) -->
      switch data.status
        when "RS_ok_void" then "ok"
        when "RS_error" then utils.mutate_state(["app_status"], data.message)
        when "RS_warn" then utils.mutate_state(["app_status"], data.message)
        when "RS_notice" then utils.mutate_state(["app_status"], data.message)
        when "RS_info" then utils.mutate_state(["app_status"], data.message)
        when "RS_refresh" then utils.get_latest_state()
        when "RS_ok_state"
          ["locations", "instruments", "bands", "admins", "rooms"].forEach((k) ->
            state.dicts[(k+"_full")] = jf.reduce(data.state[k], {}, (el, acc) -> jf.put_in(acc, [el.id.toString()], el)))
          state.dicts.rooms_of_locations = jf.reduce(data.state.rooms, {}, ({id: id, location_id: lid}, acc) -> jf.put_in(acc, [id.toString()], lid.toString()))
          state.response_state = data.state
          state.ready2render = true
          state.app_status = "данные обновлены"
          utils.render()
          #
          # TODO
          #
          console.log(state)
    date2moment: (date) ->
      moment(date.getTime())
    verbose_current_date: -> "#{state.current.moment.format('YYYY-MM-DD')} #{verbose.days_long[ state.current.moment.day() ]}"
    verbose_current_room: ->
      if (state.current.location_id == "")
        "база-? комната-?"
      else if (state.current.room_id == "")
        "#{jf.get_in(state, ["dicts","locations_full", state.current.location_id, "name"])} комната-?"
      else
        room_name = jf.get_in(state, ["dicts","rooms_full", state.current.room_id, "name"])
        location_name = jf.get_in(state, ["dicts","locations_full", state.dicts.rooms_of_locations[ state.current.room_id ], "name"])
        "#{location_name} #{room_name}"
    timeline_content: (sessions, React, RN, styles, rcolor, CELL_HEIGHT) ->
      #
      # TODO : use normal moment functions for comparison instead this shit
      #
      check_hour = (n) --> if sessions.some(({time_from: tf, time_to: tt}) --> (tf.hours() <= n) and ((if tt.hours() == 0 then 24 else tt.hours()) > n)) then "ordered" else "free"
      #
      #
      #
      init = {flex: 1, from: "09:00", to: "00:00", kind: check_hour(9)}
      [10,11,12,13,14,15,16,17,18,19,20,21,22,23]
      |> jf.reduce(_, [init], (n, [head, ...tail]) ->
        this_kind = check_hour(n)
        if head.kind == this_kind
          head.flex+=1
          [head] ++ tail
        else
          head.to = "#{n}:00"
          [{flex: 1, kind: this_kind, from: "#{n}:00", to: "00:00"}, head] ++ tail)
      |> [].reverse.call(_)
      |> [].map.call(_, ({kind: kind, flex: flex, from: from, to: to}, i) -->
        [React.createElement( RN.Text, {key: "timeline_#{i}", style: [styles.text, styles.flex1]}, "#{from}-#{to} #{verbose.time_states[kind]}")]
        |> React.createElement( RN.View, {key: "timeline_wrapper_#{i}", style: [styles.row, styles.cell, {flex: flex, height: (flex * CELL_HEIGHT)}] ++ (if kind == "free" then [] else rcolor)}, _))
  }
