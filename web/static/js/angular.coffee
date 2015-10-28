require("angular")
require("angular-scroll")
chat = angular.module 'chat', ['duScroll']

chat.service 'ChatService', ($http) ->
  base = "/api"

  index: ->
    $http.get(base)

  current_user: ->
    $http.get("#{base}/current_user")

chat.controller "ChatController", ($scope, ChatService) ->
    $scope.msg = ""
    $scope.messages = {}
    $scope.users = {}

    phoenix = require "deps/phoenix/web/static/js/phoenix"
    ChatService.current_user().then (e) ->    
        socket = new phoenix.Socket("/socket", {params: e.data} )
        socket.connect()

        container = angular.element document.getElementById 'messages-container' 
        bottom = angular.element document.getElementById 'msg-bottom' 

        channel = socket.channel("chat", {})
        join = channel.join()
        join.receive "ok", (resp) -> 
            console.log "connected", resp
        join.receive "error", (resp) -> 
            console.log "some error", resp

        channel.on "users", (e) ->
            $scope.users = e.users
            $scope.$apply()

        channel.on "messages", (e) ->
            $scope.messages = e.messages
            $scope.$apply()
            container.scrollTo bottom, 0, 500

        channel.on "msg", (msg) ->
            $scope.messages.push msg
            $scope.$apply()
            container.scrollTo bottom, 0, 500

        $scope.keyPress = (event) ->
            if event.which is 13
                channel.push "msg",  {content: $scope.msg}
                $scope.msg = ""