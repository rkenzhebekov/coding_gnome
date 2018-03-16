module Main exposing (..)

import Html exposing (Html, text, div, h1, img, button, p)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Gallows
import Ports

import Json.Decode as Decode exposing (Decoder, field, Value, decodeValue, succeed, andThen)


type GameState
    = Initializing
    | AlreadyUsed
    | BadGuess
    | GoodGuess
    | Lost
    | Won
    | Unknown

---- MODEL ----

type alias Model =
    { turns_left : Int
    , letters : List String
    , game_state: GameState
    , used_letters: List String
    }


initialModel : Model
initialModel =
    { turns_left = 7
    , letters = ["a", "_", "c"]
    , game_state = Unknown
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
       (field "game_state" (Decode.string |> andThen decodeGameState))
       (field "used_letters" (Decode.list Decode.string))

decodeGameState : String -> Decoder GameState
decodeGameState state = succeed (gameState state)


gameState : String -> GameState
gameState state =
    case state of
        "already_used" -> AlreadyUsed
        "bad_guess"    -> BadGuess
        "good_guess"   -> GoodGuess
        "lost"         -> Lost
        "won"          -> Won
        "initializing" -> Initializing
        _              -> Unknown


---- UPDATE ----


type Msg
    = NoOp
    | NewGame
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

        NewGame ->
            model ! [ Ports.newGame () ]

        NoOp ->
            (model, Cmd.none)



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ alertMessage model
        , div [ class "row" ]
              [ div [ class "col-md-4" ]
                    [ Gallows.viewGallows model.turns_left
                    , p [ class "turns-left" ] [ text ("Turns left: " ++ toString(model.turns_left))]
                    ]
              , div [ class "col-md-7 offset-md-1"]
                    [ p [ class "so-far" ] [ text (String.join " " model.letters) ]
                    , viewGameControls model
                    ]
              ]
        ]

viewGameControls : Model -> Html Msg
viewGameControls model =
  case model.game_state of
      Lost ->
          div [ class "new-game-button-container" ] 
              [ button [ class "new-game-button"
                       , onClick NewGame ]
                       [ text "New Game" ]
              ]
      _    ->
          div [ class "guess-buttons" ] (viewKeyboard model)


alertMessage : Model -> Html Msg
alertMessage model =
    let
        (className, message) =
            case model.game_state of
                Won          -> ("success", "You Won!")
                Lost         -> ("danger", "You Lost!")
                GoodGuess    -> ("success", "Good guess!")
                BadGuess     -> ("warning", "Bad guess!")
                AlreadyUsed  -> ("info", "You already guessed that")
                Initializing -> ("info", "Let's Play!")
                _            -> ("info", "Something went wrong")
    in
        div [ class ("alert alert-" ++ className) ]
            [ text message ]


viewKeyboard : Model -> List (Html Msg)
viewKeyboard model =
    "abcdefghijklmnopqrstuvwxyz"
        |> String.split ""
        |> List.map (viewButton model)


viewButton : Model -> String -> Html Msg
viewButton model letter =
    let
        alreadyGuessed = List.member letter model.used_letters
        correctGuess = alreadyGuessed && (List.member letter model.letters)
    in
        button [ classList [("correct", correctGuess)]
               , onClick (Guess letter)
               , disabled alreadyGuessed
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
