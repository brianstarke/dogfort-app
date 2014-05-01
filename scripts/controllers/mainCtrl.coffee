app = angular.module 'dogfort'

class MainCtrl extends BaseCtrl
  @register app
  @inject '$rootScope', '$scope', '$cookies', '$location', 'User', 'Auth'

  initialize: ->
    do @checkUserAuth

  logout: ->
    delete @$cookies['dogfort_token']
    delete @$rootScope['user']

    @$location.path '/login'

  # for highlighting the correct tab on the navbar
  isActive = (viewLocation) -> viewLocation is @$location.path()

  checkUserAuth: ->
    # checks the cookies for a token, and set the current
    # user based on that, or fails and require login
    @Auth.userByAuth()
      .success (data) =>
        # save user data on the root scope so everything can use it
        @$rootScope.user = data.user

        # redirect to chat after auth for now
        @$location.path '/chat'

        do @_connectToSocket
      .error () =>
        @$rootScope.user = null

        # redirect to login
        @$location.path '/login'

  _connectToSocket: ->
    if window['WebSocket']
      url = "ws://#{@$location.$$host}:3000/ws/connect"
      conn = new WebSocket url

      conn.onclose = (event) ->
        console.log 'socket connection closed'

      conn.onmessage = (event) =>
        @$rootScope.$broadcast 'message', event.data

    else
      alert 'This browser does not support WebSockets, use something newer.  http://caniuse.com/websockets'
