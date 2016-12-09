module.exports = ->
  RN = require("react-native")
  const DEVICE_WIDTH = RN.Dimensions.get('window').width

  {
    col: {
      flexDirection: 'column',
      justifyContent: 'space-between',
      alignItems: 'stretch',
    },
    row: {
      flexDirection: 'row',
      justifyContent: 'space-between',
      alignItems: 'stretch',
    },
    ceterText: {
      textAlign: 'center',
    },
    flex1: {
      flex: 1,
    }
  }
