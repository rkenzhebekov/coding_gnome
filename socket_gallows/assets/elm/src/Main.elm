module Main exposing (..)

import Html exposing (Html, text, div, h1, img, button, p)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Gallows
import Ports

import Json.Decode as Decode exposing (Decoder, field, Value, decodeValue)


type GameState
    = Initializing
    | AlreadyUsed
    | BadGuess
    | GoodGuess
    | Lost
    | Won

---- MODEL ----

type alias Model =
    { turns_left : Int
    , letters : List String
    , game_state: String
    , used_letters: List String
    }


initialModel : Model
initialModel =
    { turns_left = 7
    , letters = ["a", "_", "c"]
    , game_state = "initializing"
    , used_letters = []
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


---- DECODER ----


modelDecoder : Decoder Model
modelDecoder =
    Decode.map4 Model
       (field "turns_left" Decode.int)
       (field "letters" (Decode.list Decode.string))
       (field "game_state" Decode.string)
       (field "used_letters" (Decode.list Decode.string))

---- UPDATE ----


type Msg
    = NoOp
    | Guess String
    | UpdateTally Decode.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Guess letter ->
            model ! [ Ports.makeMove letter ]
        UpdateTally tally ->
            case decodeValue modelDecoder tally of
                Ok newModel ->
                  Debug.log (toString(newModel))
                  (newModel, Cmd.none)
                Err message ->
                  Debug.log message
                  (model, Cmd.none)

        NoOp ->
            (model, Cmd.none)



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ div [ class "alert alert-info"] [ text "Let's Play!" ]
        , div [ class "row" ]
              [ div [ class "col-md-4" ]
                    [ Gallows.viewGallows
                    , p [ class "turns-left" ] [ text ("Turns left: " ++ toString(model.turns_left))]
                    ]
              , div [ class "col-md-7 offset-md-1"]
                    [ p [ class "so-far" ] [ text (String.join " " model.letters) ]
                    , div [ class "guess-buttons"] viewKeyboard
                    ]
              ]
        ]

viewKeyboard : List (Html Msg)
viewKeyboard =
    "abcdefghijklmnopqrstuvwxyz"
        |> String.split ""
        |> List.map viewButton

viewButton : String -> Html Msg
viewButton letter =
    let
        correctClass = ""
    in
        button [ class correctClass
               , onClick (Guess letter)
               , disabled False
               ]
               [ text letter ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.updateTally UpdateTally
