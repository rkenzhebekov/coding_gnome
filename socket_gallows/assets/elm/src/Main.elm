module Main exposing (..)

import Html exposing (Html, text, div, h1, img, button)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

-- import Svg exposing (..)
-- import Svg.Attributes exposing (..)

---- MODEL ----


type alias Tally =
   { turns_left : Int
   , letters : List String
   , game_state: String
   , used_letters: List String
   }


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | Guess String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Guess letter ->
            Debug.log ("Pressed letter " ++ letter)
            (model, Cmd.none)
        NoOp ->
            (model, Cmd.none)



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [
        div [ class "guess-buttons"] viewKeyboard
        , img [ src "/images/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        ]

viewKeyboard : List (Html Msg)
viewKeyboard =
    "abcdefghijklmnopqrstuvwxyz"
        |> String.split ""
        |> List.map letterButton

letterButton : String -> Html Msg
letterButton letter =
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
        , subscriptions = always Sub.none
        }
