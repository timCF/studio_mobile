module.exports = (state, root_component) -->
  jf = require("jsfunky")
  utils = {
    set_location: (data) -->
      if (state.current.location_id != data)
        state.current.location_id = data
        state.current.room_id = ""
        utils.render()
    get_latest_state: ->
      msg = utils.new_message()
      msg.cmd = 'CMD_get_state'
      utils.to_server(msg)
    render: --> root_component.setState(state)
    mutate_state: (path, val) --> root_component.setState( jf.put_in(state, path, val) )
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
          utils.render()
          #
          # TODO
          #
          console.log(state)
  }
