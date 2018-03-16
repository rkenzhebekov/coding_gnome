port module Ports exposing (..)

import Json.Encode exposing (Value)

port makeMove : String -> Cmd msg

port newGame : () -> Cmd msg

port updateTally : (Json.Encode.Value -> msg) -> Sub msg
