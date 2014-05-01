app = angular.module 'dogfort'

class ChatCtrl extends BaseCtrl
  @register app
  @inject '$rootScope', '$scope', '$location', 'Channel', 'Message', 'User', 'toastr', '$anchorScroll', '$window'

  initialize: ->
    @$scope.channels          = {}
    @$scope.messages          = []
    @$scope.currentChannelId  = ''
    @$scope.maxHeight         = @$window.innerHeight

    @$scope.$on 'message', @_messageHandler

    do @_refreshChannels

  _messageHandler: (event, data) =>
    d = JSON.parse(data)
    channelId = Object.keys(d)[0]

    @_addMessage channelId, d[channelId]

  # for highlighting channel tabs on the chat view
  isActive: (channelId) -> channelId is @$scope.currentChannelId

  changeChannel: (channelId) ->
    @$scope.currentChannelId = channelId
    @$scope.channels[channelId].unread = 0

    do @_refreshMessages

  sendMessage: ->
    @Message.send(@$scope.message, @$scope.currentChannelId)
      .success =>
        @$scope.message = ''
      .error =>
        @toastr.error data, 'ERROR'

  _refreshChannels: ->
    @Channel.byUser(@$rootScope.user.uid)
      .success (data) =>
        @$scope.currentChannelId  = data.channels[0].uid

        for channel in data.channels
          @$scope.channels[channel.uid] = channel
          @$scope.channels[channel.uid].unread = 0

        do @_refreshMessages
      .error (data) =>
        @toastr.error data, 'ERROR'

  _refreshMessages: ->
    @Message.byChannel(@$scope.currentChannelId)
      .success (data) =>
        @$scope.messages = []
        for message in data
          @_addMessage @$scope.currentChannelId, message
      .error (data) =>
        @toastr.error data, 'ERROR'

  _addMessage: (channelId, message) ->
    if channelId is @$scope.currentChannelId
      @User.byId(message.userId)
        .success (data) =>
          message.user = data
          @$scope.messages.push message
        .error (data) =>
          @toastr.error data, 'ERROR'
    else
      @$scope.channels[channelId].unread++
      @$scope.$digest()


