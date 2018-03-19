import HangmanSocket from "./hangman_socket.js"
import Elm from "./elm"


window.onload = function() {

  const elmDiv = document.getElementById("elm-main")
  const elmApp = Elm.Main.embed(elmDiv)

  let hangman = new HangmanSocket(elmApp)

  hangman.connect_to_hangman()

  window.addEventListener('keydown', function (e) {
    if (event.keyCode >= 65 && event.keyCode <= 90) {
      hangman.make_move(event.key)
    }
  })
}


