require("angular")
chat = angular.module 'chat', []

angular.module('chat').service 'ChatService', ($http) ->
  base = "/api"

  index: ->
    $http.get(base)

  current_user: ->
    $http.get("#{base}/current_user")
