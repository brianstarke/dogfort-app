app = angular.module 'dogfort'

class ChatCtrl extends BaseCtrl
  @register app
  @inject '$rootScope', '$scope', '$location', 'Channel', 'Message', 'User', 'toastr', '$anchorScroll', '$window'

  initialize: ->
    @$scope.channels          = {}
    @$scope.messages          = []
    @$scope.currentChannelId  = ''
    @$scope.maxHeight         = @$window.innerHeight

    do @_refreshChannels

  # for highlighting channel tabs on the chat view
  isActive: (channelId) -> channelId is @$scope.currentChannelId

  changeChannel: (channelId) ->
    @$scope.currentChannelId = channelId

    do @_refreshMessages

  sendMessage: ->
    @Message.send(@$scope.message, @$scope.currentChannelId)
      .success =>
        @$scope.message = ''
        do @_refreshMessages
      .error =>
        @toastr.error data, 'ERROR'

  _refreshChannels: ->
    @Channel.byUser(@$rootScope.user.uid)
      .success (data) =>
        @$scope.currentChannelId  = data.channels[0].uid
        @$scope.channels          = data.channels

        do @_refreshMessages
      .error (data) =>
        @toastr.error data, 'ERROR'

  _refreshMessages: ->
    @Message.byChannel(@$scope.currentChannelId)
      .success (data) =>
        @$scope.messages = []
        for message in data
          @_addMessage message
      .error (data) =>
        @toastr.error data, 'ERROR'

  _addMessage: (message) ->
    @User.byId(message.userId)
      .success (data) =>
        message.user = data
        @$scope.messages.push message

        # just in case, make sure messages are in order
        @$scope.messages = @$scope.messages.sort (a,b) -> a.timestamp > b.timestamp
      .error (data) =>
        @toastr.error data, 'ERROR'
