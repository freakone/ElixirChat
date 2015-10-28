require("angular")
angular.module('chat').controller "ChatController", ($scope, ChatService) ->
    $scope.msg = "blah"
    $scope.messages = {}

    phoenix = require "deps/phoenix/web/static/js/phoenix"
    ChatService.current_user().then (e) ->    
        socket = new phoenix.Socket("/socket", {params: e.data} )
        socket.connect()

        channel = socket.channel("chat", {})
        join = channel.join()
        join.receive "ok", (resp) -> 
            console.log "connected", resp
        join.receive "error", (resp) -> 
            console.log "some error", resp

        channel.on "init", (usr) ->
            $scope.users = usr.users
            $scope.messages = usr.messages
            $scope.$apply()
            console.log usr

        $scope.keyPress = (event) ->
            if event.which is 13
                channel.push("msg",  {content: $scope.msg})
                $scope.msg = ""