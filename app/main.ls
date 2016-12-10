module.exports = (root_component) ->
  moment = require("moment")
  state = {
    login: '',
    password: '',
    app_status: "инициализация",
    dicts: {},
    ready2render: false,
    response_state: false,
    current: {
      location_id: "",
      room_id: "",
      moment: moment(),
    },
    blocks: {
      calendar: false,
    }
  }
  state.utils = require("../../app/js/utils")(state, root_component)
  state
  |> (require("../../app/js/proto")(_))
  |> (require("../../app/js/bullet")(_))
