module.exports = (root_component) ->
  state = {
    login: '',
    password: '',
    app_status: "инициализация",
  }
  state.utils = require("../../app/js/utils")(state, root_component)
  state
  |> (require("../../app/js/proto")(_))
  |> (require("../../app/js/bullet")(_))
