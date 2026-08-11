port module Main exposing (Clock, clock, clockTime, main, pad)

import Browser
import Html exposing (Html, a, audio, blockquote, button, cite, code, div, em, fieldset, figcaption, form, h1, h3, input, li, p, source, span, text, ul)
import Html.Attributes exposing (class, classList, disabled, href, id, readonly, src, tabindex, title, type_, value)
import Html.Events exposing (onClick, preventDefaultOn)
import Http
import Json.Decode as Decode
import Random
import Task
import Time


{-| Temporary. js/main.js still owns the alarm and the Notification API until
Step 6.
-}
port reward : { quote : String, speaker : String } -> Cmd msg


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


type alias Note =
    { quote : String
    , speaker : Speaker
    , at : Time.Posix
    }


type alias Model =
    { timer : Timer
    , now : Time.Posix
    , speaker : Speaker
    , quotes : List String
    , notes : List Note
    , zone : Time.Zone
    }


type Msg
    = Start
    | Started Time.Posix
    | Stop
    | Tick Time.Posix
    | ChangeSpeaker Speaker
    | ChoseSpeaker Speaker
    | GotQuotes (Result Http.Error String)
    | GotQuote String
    | GotZone Time.Zone


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
      , quotes = []
      , notes = []
      , zone = Time.utc
      }
    , Cmd.batch
        [ Task.perform GotZone Time.here
        , case asked of
            Just speaker ->
                fetchQuotes speaker

            -- no ?says means "surprise me", and it stays that way on refresh
            Nothing ->
                Random.generate ChoseSpeaker (Random.uniform Bacon [ Eddie, Soap, Tom, Rory ])
        ]
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
                pick model.quotes

              else
                Cmd.none
            )

        ChangeSpeaker speaker ->
            ( { model | speaker = speaker, quotes = [] }
            , Cmd.batch [ updateUrl (saysIndex speaker), fetchQuotes speaker ]
            )

        ChoseSpeaker speaker ->
            ( { model | speaker = speaker, quotes = [] }, fetchQuotes speaker )

        GotQuotes (Ok raw) ->
            ( { model | quotes = lines raw }, Cmd.none )

        -- No quotes means no reward. There is nothing honest to invent here,
        -- and the service worker is what stops it happening offline.
        GotQuotes (Err _) ->
            ( model, Cmd.none )

        GotQuote quote ->
            -- model.now is the tick that banked the pomodoro, so the Note is
            -- stamped at event time. A re-render cannot relabel it.
            ( { model | notes = Note quote model.speaker model.now :: model.notes }
            , reward { quote = quote, speaker = saysName model.speaker }
            )

        GotZone zone ->
            ( { model | zone = zone }, Cmd.none )


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



-- QUOTES (§4)


{-| Prefetched at init and on every speaker change, never at the moment of
reward. We have twenty-five minutes of warning.
-}
fetchQuotes : Speaker -> Cmd Msg
fetchQuotes speaker =
    Http.get
        { url = "quotes/" ++ quoteFile speaker
        , expect = Http.expectString GotQuotes
        }


{-| The whole parser. One quote per line is a format, and this is elm/core.
`quotes/*.txt` does not change by a byte, so paste-and-save still works with
no build step.

The apostrophe swap lives here rather than in `view` (§6 objected to doing it
"on every render forever") and rather than in the source files (§4 objected to
anything that makes a fresh paste second-class). This is the parse boundary,
which is the closest thing to §6's "generation time" that we have.
-}
lines : String -> List String
lines raw =
    raw
        |> String.lines
        |> List.map (String.trim >> String.replace "'" "\u{2019}")
        |> List.filter (not << String.isEmpty)


{-| `Random.uniform` wants a non-empty pair, so the cons match and the
generator agree exactly and no fallback quote has to be invented (§4).
-}
pick : List String -> Cmd Msg
pick quotes =
    case quotes of
        first :: rest ->
            Random.generate GotQuote (Random.uniform first rest)

        [] ->
            Cmd.none



-- THE LOG (§6)


{-| Text is text. The quotation marks are `content: open-quote` in CSS, which
is what CSS is for, and there is no HTML being built by hand anywhere.
-}
note : Time.Zone -> Note -> Html Msg
note zone entry =
    blockquote []
        [ span [ class "quote" ] [ text entry.quote ]
        , figcaption []
            [ text ("\u{2014} says " ++ saysName entry.speaker ++ " ")
            , cite [] [ text ("@ " ++ clockTime zone entry.at) ]
            ]
        ]


{-| What `toLocaleTimeString("en-US", { hour12: true })` was giving us: 5:00 PM.
-}
clockTime : Time.Zone -> Time.Posix -> String
clockTime zone at =
    let
        hour24 =
            Time.toHour zone at

        hour =
            modBy 12 hour24
    in
    String.fromInt
        (if hour == 0 then
            12

         else
            hour
        )
        ++ ":"
        ++ pad (Time.toMinute zone at)
        ++ (if hour24 < 12 then
                " AM"

            else
                " PM"
           )



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
        , div [ class "notifications" ] (List.map (note model.zone) model.notes)
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
