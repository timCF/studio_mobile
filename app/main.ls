module.exports = (root_component) ->
  {
    app_status: "инициализация",
    utils: require("../../app/js/utils")()
  }
  |> (require("../../app/js/proto")(_))
  |> (require("../../app/js/bullet")(_, root_component))
