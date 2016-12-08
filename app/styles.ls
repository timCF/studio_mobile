module.exports = ->
  RN = require("react-native")
  const DEVICE_WIDTH = RN.Dimensions.get('window').width

  {
    root: {
      flex: 1,
      flexDirection: 'column',
      justifyContent: 'flex-start',
      alignItems: 'center',
      width: DEVICE_WIDTH,
    },
    calendar: {
      flex: 1,
      flexDirection: 'column',
      justifyContent: 'center',
      alignItems: 'center',
    },
    row: {
      flex: 1,
      flexDirection: 'row',
      justifyContent: 'center',
      alignItems: 'center',
    },
    status_string: {
      textAlign: 'center',
      width: DEVICE_WIDTH,
    },
    fill: {
      width: DEVICE_WIDTH,
    },
    fill50: {
      width: (DEVICE_WIDTH / 2),
    },
  }
