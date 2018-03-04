window.Vue = require("vue/dist/vue.js")

import "phoenix_html"

import "./hangman_app"

import Elm from "./elm"

const elmDiv = document.getElementById("elm-main")

Elm.Main.embed(elmDiv)
