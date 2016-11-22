module.exports = ->
  require("../../app/js/utils")()
  |> (require("../../app/js/proto")(_))
  |> (require("../../app/js/bullet")(_))
