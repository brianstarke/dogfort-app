app = angular.module 'dogfort'

class LoginCtrl extends BaseCtrl
  @register app
  @inject '$rootScope', '$scope', '$cookies', '$location', 'User', 'Auth', 'toastr'

  initialize: ->
    @registerModal = new $.UIkit.modal.Modal('#register')

  login: ->
    @Auth.authenticate(@$scope.user)
      .success (data) =>
        @$cookies.dogfort_token = data.token
        @$location.path '/channels'
        @toastr.success 'Authenticated', 'success'
        @$scope.$parent.checkUserAuth()
      .error (data) =>
        @toastr.error data, 'ERROR'

  register: ->
    @User.create(@$scope.newuser)
      .success =>
        @$location.path '/login'
        @registerModal._hide()
        @toastr.success 'User created successfully, login', 'success'
      .error =>
        @toastr.error data, 'ERROR'
