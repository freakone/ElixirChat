require("angular")
angular.module('chat').controller "ChatController", ($scope, ChatService) ->
    $scope.msg = "blah"

    phoenix = require "deps/phoenix/web/static/js/phoenix"
    ChatService.current_user().then (e) ->    
        socket = new phoenix.Socket("/socket", {params: e.data} )
        socket.connect()

        channel = socket.channel("chat", {})
        join = channel.join()
        join.receive("ok", (resp) -> 
            console.log("yeap", resp))
        join.receive("error", (resp) -> 
            console.log("nope", resp))
        channel.on("msg", (msg) ->
            console.log(msg))