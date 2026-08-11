module Main exposing (main)

import Browser
import Html exposing (Html, a, audio, blockquote, button, code, div, em, fieldset, figcaption, form, h1, h3, input, li, p, source, span, text, ul)
import Html.Attributes exposing (class, disabled, href, id, readonly, src, tabindex, title, type_, value)


type alias Model =
    ()


type Msg
    = NoOp


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( (), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Browser.Document Msg
view _ =
    { title = "Lock Stock Pomodoros : ianchanning"
    , body =
        [ h1 [] [ text "DO IT" ]
        , div [ id "chker", class "chker" ]
            [ tabs
            , clock
            ]
        , reminder
        , div [ class "notifications" ] []
        , alarm
        ]
    }


tabs : Html Msg
tabs =
    ul [ class "tabs" ]
        (List.indexedMap tab [ "Bacon", "Eddie", "Soap", "Tom", "Rory" ])


tab : Int -> String -> Html Msg
tab index name =
    li [] [ a [ href ("?says=" ++ String.fromInt index ++ "&silent=0") ] [ text name ] ]


clock : Html Msg
clock =
    form []
        [ fieldset []
            [ div [ class "clock" ]
                [ div [ class "time" ]
                    [ input
                        [ id "min"
                        , class "min"
                        , type_ "text"
                        , value "25"
                        , title "25 minutes sitting on a wall, and if one of those minutes should accidentally fall"
                        ]
                        []
                    , span [ class "separator" ] [ text ":" ]
                    , input
                        [ id "sec"
                        , class "sec"
                        , type_ "text"
                        , value "00"
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
                        , value "00"
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
                    ]
                    [ text "Start" ]
                , button
                    [ type_ "button"
                    , class "stop button gray"
                    , title "Hammertime"
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
