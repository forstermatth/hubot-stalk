class List

  @template =
    name: null
    lastStatus: null
    lastAction: null
    lastUpdate: null
    following: false
    stati: []
    actions: []

  @robot = null
  @store = null
  @statusThreshold = 5 # number of status to keep in memory
  @actionThreshold = 10 # number of actions to keep in memory

  constructor: (@robot) ->
    store = robot.brain.data.stalkers_notes || {};

  @follow: (user) ->
    store[user].following = true

  @following: (user) ->
    store[user].following

  @saveStatus: (user, status) ->
    if store[user]
      user = store[user]
    else
      user = store[user] = @template

    user.stati.unshift status
    user.lastStatus = status
    user.lastUpdate = new Date()

    if user.stati.length > @statusThreshold
      user.stati.pop

  @saveAction: (user, command, args) ->
    user = store[user]
    if not user
      user = store[user] = @template

    action = {
      action: command
      args: args
    }

    user.actions.unshift action
    user.lastAction = action
    user.lastUpdate = new Date()

    if user.actions.length > @actionThreshold
      user.actions.pop

  @get: (user) =>
    if user
      store[user]
    else
      false
