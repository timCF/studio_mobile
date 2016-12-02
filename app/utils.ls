module.exports = (state, root_component) -->
  {
    mutate_state: (key, val) -->
      state[key] = val
      root_component.setState(state)
    handle_message: (msg) -->
      console.log("TODO : impl handle_message")
  }
