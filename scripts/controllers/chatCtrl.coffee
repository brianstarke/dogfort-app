app = angular.module 'dogfort'

class ChatCtrl extends BaseCtrl
  @register app
  @inject '$rootScope', '$scope', '$location', 'Channel', 'Message', 'User', 'toastr', '$window', '$document', '$sce'

  initialize: ->
    @$scope.channels          = {}
    @$scope.currentChannelId  = ''
    @$scope.maxHeight         = @$window.innerHeight

    @$scope.$on 'message', @_messageHandler

    do @_refreshChannels

  _messageHandler: (event, data) =>
    @_addMessage data

  # for highlighting channel tabs on the chat view
  isActive: (channelId) -> channelId is @$scope.currentChannelId

  showHtml: (text) ->
    @$sce.trustAsHtml(text)

  changeChannel: (channelId) ->
    @$scope.currentChannelId = channelId
    @$scope.channels[channelId].unread = 0

  leaveChannel: (channelId) ->
    @Channel.leave(channelId)
      .success =>
        @toastr.success 'Left channel', 'SUCCESS'
        do @_refreshChannels
      .error (data) =>
        @toastr.error data, 'ERROR'

  _cacheUser: (id) ->
    # add user to local map if they aren't there already
    if not @$rootScope.users[id]?
      @User.byId(id)
        .success (data) =>
          @$rootScope.users[id] = data
        .error (data) =>
          @toastr.error data, 'ERROR'

  sendMessage: ->
    @Message.send(@$scope.message, @$scope.currentChannelId)
      .error =>
        @toastr.error data, 'ERROR'
    @$scope.message = ''

  _refreshChannels: ->
    @Channel.byUser(@$rootScope.user.uid)
      .success (data) =>
        if data.channels.length < 1
          @$location.path '/channels'

        @$scope.currentChannelId  = data.channels[0].uid

        for channel in data.channels
          @$scope.channels[channel.uid] = channel
          @$scope.channels[channel.uid].unread = 0

          for user in channel.members
            @_cacheUser user

          @_populateMessages channel.uid
      .error (data) =>
        @toastr.error data, 'ERROR'

  _populateMessages: (channelId) ->
    @Message.byChannel(channelId, new Date().getTime(), 30)
      .success (data) =>
        messages = data.sort (a,b) -> a.timestamp > b.timestamp
        @$scope.channels[channelId].messages = data.sort (a,b) -> a.timestamp > b.timestamp

        for m in messages
          @$scope.channels[channelId].messages[m.uid] = m

        do @_scroll

      .error (data) =>
        @toastr.error data, 'ERROR'

  _addMessage: (message) ->
    @_cacheUser message.userId unless message.isAdminMsg

    @$scope.channels[message.channelId].messages.push message
    @$scope.$digest()
    @$document[0].getElementById('bloop').play()
    do @_scroll

    if message.channelId isnt @$scope.currentChannelId
      @$scope.channels[message.channelId].unread++
      @$scope.$digest()

  _scroll: ->
    c = angular.element('#chat')[0]

    setTimeout ->
      c.scrollTop = c.scrollHeight
    , 1000
