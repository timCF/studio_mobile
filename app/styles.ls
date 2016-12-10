module.exports = ->
  RN = require("react-native")
  {height, width} = RN.Dimensions.get('window')
  BORDER_RADIUS = 5
  FONT_SIZE = 13
  PADDING = 8
  MARGIN = 2

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
    flex1: {
      flex: 1,
    },
    btn: {
      marginBottom: MARGIN,
      borderColor: '#ccc',
      borderWidth: 1,
      borderRadius: BORDER_RADIUS,
      padding: PADDING,
      margin: MARGIN,
    },
    margin3x: {
      marginBottom: MARGIN,
      marginLeft: MARGIN,
      marginRight: MARGIN,
    },
    margin2x: {
      marginBottom: MARGIN,
      marginRight: MARGIN,
    },
    poor_text: {
      textAlign: 'center',
      fontSize: FONT_SIZE,
    }
    text: {
      textAlign: 'center',
      alignSelf: 'center',
      fontSize: FONT_SIZE,
    },
    cell: {
      borderTopWidth: 1,
      borderRightWidth: 1,
      borderColor: '#ccc',
    }
  }
