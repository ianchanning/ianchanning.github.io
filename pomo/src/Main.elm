port module Main exposing (Clock, clock, clockTime, main, pad)

import Browser
import Browser.Events
import Html exposing (Html, a, audio, blockquote, button, cite, details, div, em, fieldset, figcaption, h1, h3, input, li, output, p, source, span, summary, text, ul)
import Html.Attributes exposing (attribute, class, classList, href, id, src, title, type_, value)
import Html.Events exposing (onClick, onInput, preventDefaultOn)
import Http
import Json.Decode as Decode
import Random
import Task
import Time


{-| §7's three edges. Elm cannot do any of these, and there is nothing else it
cannot do.

`notify` — the Notification API. Permission is asked for once at load in
`app.js`, because it is a page-load concern and has nothing to do with the model.

`play` — `<audio>.play()`. A port rather than rendering the element only when
firing: autoplay-on-render fights browser policy and makes `view` a liar.

`updateUrl` — one-way and cosmetic. The model is the truth; this only keeps the
address bar shareable.
-}
port notify : { title : String, body : String } -> Cmd msg


port play : () -> Cmd msg


port updateUrl : Int -> Cmd msg


{-| The dial's starting position, not a law. The Pomodoro Technique says 25;
the box says whatever you last typed into it (Q4).
-}
pomodoro : Int
pomodoro =
    25 * 60


siteTitle : String
siteTitle =
    "Lock Stock Pomodoros : ianchanning"


{-| `Paused` carries the seconds already served, which is the whole of what
Stop has to remember. §2 said not to invent it until something needed it;
Stop needing to mean *stop* rather than *reset* is that something.
-}
type Timer
    = Idle
    | Running Time.Posix
    | Paused Int


type Speaker
    = Bacon
    | Eddie
    | Soap
    | Tom
    | Rory


type alias Flags =
    { says : Maybe String
    , silent : Maybe String
    }


type alias Note =
    { quote : String
    , speaker : Speaker
    , at : Time.Posix
    }


{-| `period` and `pomodoros` are both here for the same reason: once the dial
is user-adjustable, `elapsed // period` stops being the count of pomodoros you
did and becomes a function of where the dial happens to be pointing now. Work
already banked is a fact about your afternoon, not a rendering of the current
cycle, so it is stored rather than derived (§1c's one subtraction still runs
the clock; it just no longer runs the scoreboard).
-}
type alias Model =
    { timer : Timer
    , period : Int
    , pomodoros : Int
    , now : Time.Posix
    , speaker : Speaker
    , quotes : List String
    , notes : List Note
    , zone : Time.Zone
    , silent : Bool
    }


type Msg
    = Start
    | Started Time.Posix
    | Stop
    | Toggle
    | SetMinutes String
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
      , period = pomodoro
      , pomodoros = 0
      , now = Time.millisToPosix 0
      , speaker = Maybe.withDefault Bacon asked
      , quotes = []
      , notes = []
      , zone = Time.utc
      , silent = silentFlag flags.silent
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
                Running _ ->
                    ( model, Cmd.none )

                -- Idle is Paused 0 with better manners, so both resume the
                -- same way: `Started` subtracts whatever has already been
                -- served back off the clock.
                _ ->
                    ( model, Task.perform Started Time.now )

        Started now ->
            ( { model
                | timer = Running (shift now (negate (elapsed model)))
                , now = now
              }
            , Cmd.none
            )

        Stop ->
            case model.timer of
                Running _ ->
                    ( { model | timer = Paused (elapsed model) }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        -- The space bar asks a question the model can already answer, so it
        -- routes back into the two branches the buttons use rather than
        -- growing a third copy of them (§8).
        Toggle ->
            case model.timer of
                Running _ ->
                    update Stop model

                _ ->
                    update Start model

        -- Turning the dial restarts the cycle it is measuring, exactly like
        -- turning one on a physical timer. It cannot retroactively re-grade
        -- pomodoros you have already banked, because it no longer computes
        -- them. Typing the number the box already shows is not turning it —
        -- that guard is what makes a stray keystroke harmless — and an
        -- unparseable box (mid-edit, or empty) changes nothing at all.
        SetMinutes typed ->
            case String.toInt (String.trim typed) of
                Just minutes ->
                    let
                        wanted =
                            clamp 1 99 minutes
                    in
                    if wanted == (clock model.period (elapsed model)).minutes then
                        ( model, Cmd.none )

                    else
                        ( { model
                            | period = wanted * 60
                            , timer =
                                case model.timer of
                                    Running _ ->
                                        Running model.now

                                    Paused _ ->
                                        Paused 0

                                    Idle ->
                                        Idle
                          }
                        , Cmd.none
                        )

                Nothing ->
                    ( model, Cmd.none )

        Tick now ->
            let
                ticked =
                    { model | now = now }

                -- Plural on purpose: a backgrounded PWA comes back owing
                -- several, and the arithmetic pays all of them.
                cycles =
                    elapsed ticked // model.period
            in
            if cycles > 0 then
                ( { ticked
                    | pomodoros = model.pomodoros + cycles
                    , timer =
                        case ticked.timer of
                            Running startedAt ->
                                Running (shift startedAt (cycles * model.period))

                            other ->
                                other
                  }
                  -- The pomodoro is what earns the noise. The quote is a
                  -- separate errand and may not arrive, but the alarm still
                  -- should.
                , Cmd.batch
                    [ if model.silent then
                        Cmd.none

                      else
                        play ()
                    , pick model.quotes
                    ]
                )

            else
                ( ticked, Cmd.none )

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
            , notify
                { title = saysName model.speaker ++ " says"
                , body = quote
                }
            )

        GotZone zone ->
            ( { model | zone = zone }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ case model.timer of
            Running _ ->
                Time.every 1000 Tick

            _ ->
                Sub.none
        , Browser.Events.onKeyDown spaceBar
        ]


{-| A decoder that fails is a key we did not want, and `Browser.Events` sends
nothing when it fails. No `NoOp`, no keycode table, and nothing anywhere asks
the DOM what state the timer is in (§8).

The one thing it does ask the DOM is what you were typing into, because a
space bar inside the minutes box is a space bar and not a verb.

The matching `preventDefault` lives in `app.js`: `Browser.Events` registers its
listeners `{ passive: true }` (elm/browser `Elm/Kernel/Browser.js:228`), so Elm
is not allowed to cancel the scroll from here. What the key *means* is still
decided in exactly one place, which is this function.

-}
spaceBar : Decode.Decoder Msg
spaceBar =
    Decode.map2 Tuple.pair
        (Decode.field "key" Decode.string)
        (Decode.at [ "target", "tagName" ] Decode.string)
        |> Decode.andThen
            (\( key, tag ) ->
                if key == " " && tag /= "INPUT" then
                    Decode.succeed Toggle

                else
                    Decode.fail "not the space bar"
            )



-- THE TIMER (§1c)


{-| One number. Everything on the clock is a view of it.
-}
elapsed : Model -> Int
elapsed model =
    case model.timer of
        Idle ->
            0

        Running startedAt ->
            (Time.posixToMillis model.now - Time.posixToMillis startedAt) // 1000

        Paused secondsServed ->
            secondsServed


{-| Move a fixed point in the past by some seconds. Starting is a shift
backwards by what you have already served; banking is a shift forwards by what
you just earned.
-}
shift : Time.Posix -> Int -> Time.Posix
shift at seconds =
    Time.millisToPosix (Time.posixToMillis at + seconds * 1000)


type alias Clock =
    { minutes : Int
    , seconds : Int
    }


{-| The quotient and the remainder of one number, which is why they cannot fall
out of step. `//` and `modBy` are chuck's `_checkSum`, correct by construction.
`period` is guarded to at least a minute at the point of typing, so `modBy`
cannot be handed a zero.
-}
clock : Int -> Int -> Clock
clock period secondsElapsed =
    let
        left =
            period - modBy period secondsElapsed
    in
    { minutes = left // 60
    , seconds = modBy 60 left
    }


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


{-| Present means silent unless you explicitly say otherwise, which reads
forwards. The old `!["true","1",""].includes(..)` did not, which is why every
tab link had to carry `silent=0`.
-}
silentFlag : Maybe String -> Bool
silentFlag raw =
    case raw of
        Nothing ->
            False

        Just value ->
            not (List.member (String.toLower value) [ "0", "false", "no" ])


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
            clock model.period (elapsed model)
    in
    { title = documentTitle model now
    , body =
        [ h1 [] [ text "DO IT" ]
        , div [ id "chker", class "chker" ]
            [ tabs model.speaker
            , timer now model.pomodoros
            ]
        , div
            [ class "notifications"
            , attribute "aria-live" "polite"
            ]
            (List.map (note model.zone) model.notes)
        , alarm
        ]
    }


documentTitle : Model -> Clock -> String
documentTitle model now =
    case model.timer of
        Idle ->
            siteTitle

        _ ->
            pad now.minutes ++ " : " ++ pad now.seconds ++ " " ++ pad model.pomodoros ++ " - " ++ siteTitle


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
            [ href ("?says=" ++ String.fromInt (saysIndex speaker))
            , classList [ ( "active", speaker == current ) ]
            , preventDefaultOn "click" (Decode.succeed ( ChangeSpeaker speaker, True ))
            ]
            [ text (tabName speaker) ]
        ]


timer : Clock -> Int -> Html Msg
timer now pomodoros =
    div []
        [ fieldset []
            [ div [ class "clock" ]
                [ div [ class "time" ]
                    [ dial now.minutes
                    , span [ class "separator" ] [ text ":" ]
                    , digits "sec" "tick... tick... tick..." now.seconds
                    , span [ class "separator" ] [ text "\u{00A0}" ]
                    , digits "pomo" "I swear I did, like, 5 pomodoros in a row once" pomodoros
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
                , reminder
                ]
            ]
        ]


{-| The one box you can argue with. It reads as the minutes remaining and
writes as the minutes you want, which is the same contract a kitchen timer
offers and the same one the old `#min` input had — chuck read this element back
every tick, which is the entire reason pomo forked chuck (§1b-ii). It is an
`<input>` because it is genuinely input.
-}
dial : Int -> Html Msg
dial minutes =
    input
        [ id "min"
        , class "min"
        , type_ "text"
        , title "25 minutes sitting on a wall, and if one of those minutes should accidentally fall"
        , value (pad minutes)
        , onInput SetMinutes
        ]
        []


{-| `<output>` is "the result of a calculation", which is what these two are —
neither was ever typeable, so neither pretends to be. It carries an implicit
polite live region, silenced one box at a time because a screen reader counting
every second down is torture (§10). The box itself is a CSS border now.
-}
digits : String -> String -> Int -> Html Msg
digits name hint number =
    output
        [ id name
        , class name
        , title hint
        , attribute "aria-live" "off"
        ]
        [ text (pad number) ]


{-| The browser already owns "show and hide a bit of the page", down to the
keyboard and the accessible name. The `+` / `×` swap is a CSS rule on the
marker; nothing here is state, so nothing here is in the model (§9).
-}
reminder : Html Msg
reminder =
    details [ class "reminder" ]
        [ summary [ attribute "aria-label" "Pomodoro reminder" ] []
        , blockquote []
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
        ]


alarm : Html Msg
alarm =
    audio [ id "alarm" ]
        [ source [ src "audio/alarm-clock-01.mp3", type_ "audio/mpeg" ] []
        , source [ src "audio/alarm-clock-01.ogg", type_ "audio/ogg" ] []
        ]
