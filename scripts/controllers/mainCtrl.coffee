app = angular.module 'dogfort'

class MainCtrl extends BaseCtrl
  @register app
  @inject '$rootScope', '$scope', '$cookies', '$location', 'User', 'Auth', '$document', '$window'

  initialize: ->
    @$rootScope.users = {}
    console.log @$window.document.referrer

    do @checkUserAuth

    @$scope.$on 'user_join', @_userJoinHandler
    @$scope.$on 'user_leave', @_userLeaveHandler

  logout: ->
    delete @$cookies['dogfort_token']
    delete @$rootScope['user']

    @$location.path '/login'

  _userJoinHandler: (event, data) =>
    @$rootScope.users[data].online = true if @$rootScope.users[data]?
    @$rootScope.$digest()

  _userLeaveHandler: (event, data) =>
    @$rootScope.users[data].online = false if @$rootScope.users[data]?
    @$rootScope.$digest()

  # for highlighting the correct tab on the navbar
  isActive: (viewLocation) -> viewLocation is @$location.path()

  checkUserAuth: ->
    # checks the cookies for a token, and set the current
    # user based on that, or fails and require login
    @Auth.userByAuth()
      .success (data) =>
        # save user data on the root scope so everything can use it
        @$rootScope.user = data.user

        setTimeout =>
          @User.online().success (users) =>
            for u in users
              @$rootScope.users[u].online = true if @$rootScope.users[u]?
        , 2000

        # redirect to chat after auth for now
        @$location.path '/chat'

        do @_connectToSocket
      .error () =>
        @$rootScope.user = null

        # redirect to login
        @$location.path '/login'

  _connectToSocket: ->
    if window['WebSocket']
      url = "ws://#{@$location.$$host}:#{@$location.$$port}/ws/connect"
      conn = new WebSocket url

      conn.onclose = (event) ->
        console.log 'socket connection closed'

      conn.onmessage = (event) =>
        e = JSON.parse event.data
        topic = Object.keys(e)[0]

        @$rootScope.$broadcast topic, e[topic]

    else
      alert 'This browser does not support WebSockets, use something newer.  http://caniuse.com/websockets'
