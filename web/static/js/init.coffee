require("angular")
require("angular-scroll")
chat = angular.module 'chat', ['duScroll']

angular.module('chat').service 'ChatService', ($http) ->
  base = "/api"

  index: ->
    $http.get(base)

  current_user: ->
    $http.get("#{base}/current_user")
