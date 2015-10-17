phoenix = require "deps/phoenix/web/static/js/phoenix"


socket = new phoenix.Socket("/socket", {params: {token: window.userToken}})
socket.connect()

channel = socket.channel("chat", {})
join = channel.join()
join.receive("ok", (resp) -> 
    console.log("yeap", resp))
join.receive("error", (resp) -> 
    console.log("nope", resp))
channel.on("msg", (msg) ->
    console.log(msg))