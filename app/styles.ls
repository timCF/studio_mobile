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
    },
    btn: {
      borderWidth: 0,
      backgroundColor: '#66B9BF',
      marginBottom: 0,
      borderRadius: 0,
    },
  }
