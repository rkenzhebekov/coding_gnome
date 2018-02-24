import {Socket} from "phoenix"

export default class HangmanSocket {
  constructor(tally) {
    this.tally = tally
    this.socket = new Socket("/socket", {})
    this.socket.connect()
  }

  connect_to_hangman() {
    this.setup_channel()
    this.channel
        .join()
        .receive("ok", resp => {
          console.log("connected: " + resp)
          this.fetch_tally()
        })
        .receive("error", resp => {
          alert(resp)
          throw(resp)
        })
  }

  setup_channel() {
    this.channel = this.socket.channel("hangman:game", {})
    this.channel.on("tally", tally => {
      this.copy_tally(tally)
    })

    this.channel.on("seconds_left", time => {
      this.tally["seconds_left"] = time["seconds_left"]
    })
  }

  copy_tally(from) {
    for (let k in from) {
      this.tally[k] = from[k]
    }
  }

  fetch_tally() {
    this.channel.push("tally", {})
  }

  new_game() {
    this.channel.push("new_game", {})
  }

  make_move(guess) {
    this.channel.push("make_move", guess)
  }
}

