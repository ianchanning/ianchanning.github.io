port module Main exposing (Clock, clock, main, pad)

import Browser
import Html exposing (Html, a, audio, blockquote, button, code, div, em, fieldset, figcaption, form, h1, h3, input, li, p, source, span, text, ul)
import Html.Attributes exposing (class, classList, disabled, href, id, readonly, src, tabindex, title, type_, value)
import Html.Events exposing (onClick, preventDefaultOn)
import Json.Decode as Decode
import Random
import Task
import Time


{-| Temporary. js/main.js still owns what a reward *means* until Steps 4 and 6
split this into the quote fetch and the notify/alarm ports.
-}
port reward : { file : String, speaker : String } -> Cmd msg


{-| One-way, cosmetic (§7). The model is the truth; this only keeps the address
bar shareable. pingolin's `updateUrl` is the reference.
-}
port updateUrl : Int -> Cmd msg


pomodoro : Int
pomodoro =
    25 * 60


siteTitle : String
siteTitle =
    "Lock Stock Pomodoros : ianchanning"


type Timer
    = Idle
    | Running Time.Posix


type Speaker
    = Bacon
    | Eddie
    | Soap
    | Tom
    | Rory


type alias Flags =
    { says : Maybe String }


type alias Model =
    { timer : Timer
    , now : Time.Posix
    , speaker : Speaker
    }


type Msg
    = Start
    | Started Time.Posix
    | Stop
    | Tick Time.Posix
    | ChangeSpeaker Speaker
    | ChoseSpeaker Speaker


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        asked =
            flags.says |> Maybe.andThen String.toInt |> Maybe.andThen speakerAt
    in
    ( { timer = Idle
      , now = Time.millisToPosix 0
      , speaker = Maybe.withDefault Bacon asked
      }
      -- no ?says means "surprise me", and it stays that way on refresh
    , case asked of
        Just _ ->
            Cmd.none

        Nothing ->
            Random.generate ChoseSpeaker (Random.uniform Bacon [ Eddie, Soap, Tom, Rory ])
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start ->
            case model.timer of
                Idle ->
                    ( model, Task.perform Started Time.now )

                Running _ ->
                    ( model, Cmd.none )

        Started now ->
            ( { model | timer = Running now, now = now }, Cmd.none )

        Stop ->
            ( { model | timer = Idle }, Cmd.none )

        Tick now ->
            let
                ticked =
                    { model | now = now }
            in
            ( ticked
            , if banked ticked > banked model then
                reward
                    { file = quoteFile model.speaker
                    , speaker = saysName model.speaker
                    }

              else
                Cmd.none
            )

        ChangeSpeaker speaker ->
            ( { model | speaker = speaker }, updateUrl (saysIndex speaker) )

        ChoseSpeaker speaker ->
            ( { model | speaker = speaker }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.timer of
        Idle ->
            Sub.none

        Running _ ->
            Time.every 1000 Tick



-- THE TIMER (§1c)


{-| One number. Everything on screen is a view of it.
-}
elapsed : Model -> Int
elapsed model =
    case model.timer of
        Idle ->
            0

        Running startedAt ->
            (Time.posixToMillis model.now - Time.posixToMillis startedAt) // 1000


type alias Clock =
    { minutes : Int
    , seconds : Int
    , pomodoros : Int
    }


{-| The quotient and the remainder of one number, which is why they cannot fall
out of step. `//` and `modBy` are chuck's `_checkSum`, correct by construction.
-}
clock : Int -> Clock
clock secondsElapsed =
    let
        left =
            pomodoro - modBy pomodoro secondsElapsed
    in
    { minutes = left // 60
    , seconds = modBy 60 left
    , pomodoros = secondsElapsed // pomodoro
    }


banked : Model -> Int
banked model =
    (clock (elapsed model)).pomodoros


pad : Int -> String
pad n =
    String.padLeft 2 '0' (String.fromInt n)



-- THE CAST (§3)


speakers : List Speaker
speakers =
    [ Bacon, Eddie, Soap, Tom, Rory ]


speakerAt : Int -> Maybe Speaker
speakerAt index =
    if index < 0 then
        Nothing

    else
        List.head (List.drop index speakers)


{-| The URL contract. Old bookmarks still work.
-}
saysIndex : Speaker -> Int
saysIndex speaker =
    case speaker of
        Bacon ->
            0

        Eddie ->
            1

        Soap ->
            2

        Tom ->
            3

        Rory ->
            4


{-| What the tab says. Short enough for five of them across a phone.
-}
tabName : Speaker -> String
tabName speaker =
    case speaker of
        Bacon ->
            "Bacon"

        Eddie ->
            "Eddie"

        Soap ->
            "Soap"

        Tom ->
            "Tom"

        Rory ->
            "Rory"


{-| What the attribution says. Only Rory differs, and the whole point is that
the compiler will ask about the sixth speaker at every one of these.
-}
saysName : Speaker -> String
saysName speaker =
    case speaker of
        Bacon ->
            "Bacon"

        Eddie ->
            "Eddie"

        Soap ->
            "Soap"

        Tom ->
            "Tom"

        Rory ->
            "Rory Breaker"


quoteFile : Speaker -> String
quoteFile speaker =
    case speaker of
        Bacon ->
            "bacon.txt"

        Eddie ->
            "eddie.txt"

        Soap ->
            "soap.txt"

        Tom ->
            "tom.txt"

        Rory ->
            "rory_breaker.txt"



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        now =
            clock (elapsed model)
    in
    { title = documentTitle model now
    , body =
        [ h1 [] [ text "DO IT" ]
        , div
            [ id "chker"
            , classList [ ( "chker", True ), ( "ticking", model.timer /= Idle ) ]
            ]
            [ tabs model.speaker
            , timer now
            ]
        , reminder
        , div [ class "notifications" ] []
        , alarm
        ]
    }


documentTitle : Model -> Clock -> String
documentTitle model now =
    case model.timer of
        Idle ->
            siteTitle

        Running _ ->
            pad now.minutes ++ " : " ++ pad now.seconds ++ " " ++ pad now.pomodoros ++ " - " ++ siteTitle


tabs : Speaker -> Html Msg
tabs current =
    ul [ class "tabs" ] (List.map (tab current) speakers)


{-| The href stays real so right-click, middle-click and no-JS still work; the
click is intercepted so switching speaker no longer reloads the page.
-}
tab : Speaker -> Speaker -> Html Msg
tab current speaker =
    li []
        [ a
            [ href ("?says=" ++ String.fromInt (saysIndex speaker) ++ "&silent=0")
            , classList [ ( "active", speaker == current ) ]
            , preventDefaultOn "click" (Decode.succeed ( ChangeSpeaker speaker, True ))
            ]
            [ text (tabName speaker) ]
        ]


timer : Clock -> Html Msg
timer now =
    form []
        [ fieldset []
            [ div [ class "clock" ]
                [ div [ class "time" ]
                    [ input
                        [ id "min"
                        , class "min"
                        , type_ "text"
                        , value (pad now.minutes)
                        , title "25 minutes sitting on a wall, and if one of those minutes should accidentally fall"
                        ]
                        []
                    , span [ class "separator" ] [ text ":" ]
                    , input
                        [ id "sec"
                        , class "sec"
                        , type_ "text"
                        , value (pad now.seconds)
                        , disabled True
                        , readonly True
                        , title "tick... tick... tick..."
                        ]
                        []
                    , span [ class "separator" ] [ text "\u{00A0}" ]
                    , input
                        [ id "pomo"
                        , class "pomo"
                        , type_ "text"
                        , value (pad now.pomodoros)
                        , disabled True
                        , readonly True
                        , title "I swear I did, like, 5 pomodoros in a row once"
                        ]
                        []
                    ]
                ]
            ]
        , fieldset []
            [ div [ class "buttons" ]
                [ button
                    [ type_ "button"
                    , class "start button gray"
                    , title "RSI tip: Space bar works too"
                    , onClick Start
                    ]
                    [ text "Start" ]
                , button
                    [ type_ "button"
                    , class "stop button gray"
                    , title "Hammertime"
                    , onClick Stop
                    ]
                    [ text "Stop" ]

                -- elm/virtual-dom strips `javascript:` hrefs, so this is "#"; js/main.js preventDefaults it
                , code [] [ a [ href "#", id "reminder", tabindex -1 ] [ text "+" ] ]
                ]
            ]
        ]


reminder : Html Msg
reminder =
    blockquote [ class "reminder" ]
        [ p []
            [ text "“I know, lets build a pomodoro timer with quotes from Lock Stock.”"
            , figcaption [] [ text "— says No-one ever" ]
            ]
        , p []
            [ a [ href "http://pomodorotechnique.com/get-started/" ] [ text "Reminder" ]
            , text " to self:"
            ]
        , h3 [] [ text "1. “Choose a task you’d like to get done”" ]
        , p []
            [ text "“Pick the thing you’ve been avoiding since the Jurassic period. Doesn’t matter if it’s curing cancer or finally Googling ‘how to adult’—just pick "
            , em [] [ text "something" ]
            , text " before your existential dread picks for you. Pro tip: If your to-do list were a person, it’d be haunting your nightmares by now.”"
            ]
        , h3 [] [ text "2. “Set the pomodoro for 25 minutes”" ]
        , p []
            [ text "“Set a timer for 25 minutes. Yes, "
            , em [] [ text "that" ]
            , text " timer. The one you’ll stare at like a microwave countdown, bargaining with the universe for a meteor strike to save you from replying to emails. This isn’t a ‘small oath’—it’s a hostage negotiation with your own attention span. Spoiler: You’re both the kidnapper "
            , em [] [ text "and" ]
            , text " the negotiator.”"
            ]
        , h3 [] [ text "3. “Work on the task until the pomodoro rings”" ]
        , p []
            [ text "“Hyperfocus for 25 minutes. Or, more accurately: Spend 15 minutes working, 7 minutes wondering if you’re allergic to productivity, and 3 minutes writing down ‘urgent’ distractions like "
            , em [] [ text "‘Why do I own 3 staplers?’" ]
            , text " or "
            , em [] [ text "‘Is my plant judging me?’" ]
            , text " Pro move: Burn the distraction list afterward. Fire purifies all sins, including your impulse to reorganize the fridge "
            , em [] [ text "mid-task" ]
            , text ".”"
            ]
        ]


alarm : Html Msg
alarm =
    audio [ id "alarm" ]
        [ source [ src "audio/alarm-clock-01.mp3", type_ "audio/mpeg" ] []
        , source [ src "audio/alarm-clock-01.ogg", type_ "audio/ogg" ] []
        ]
