module Main exposing (..)

import Html
import Html.App
import Html.Attributes exposing (placeholder, maxlength,type', autofocus, id, class)
import Html exposing (Html, button, div, text, input, h1, p)
import Html.Events exposing (onClick, onInput, onSubmit)
import Json.Decode exposing (..)
import Json.Encode exposing (encode)
import Http
import Task

-- Just for debugging
-- import Debug exposing (log)

main =
    Html.App.programWithFlags
    { init = init,
    update = update,
    view = view,
    subscriptions = subscriptions
    }

-- MODEL
type alias Entry = { name: String }
type alias RoomModel = { entries : List Entry, title: String, description: String, currentEntry: Entry}

-- For "safety" we create a type alias for application input from the page
type alias Flags = { room: String }

--Initialize model/application state
init : Flags -> (RoomModel, Cmd Msg)
init flags =
    let
        { room } = flags
    in
        ( RoomModel [] room "This is a description" (Entry ""), getEntries room)

-- Define a few custom types for managing the state and data flows
type Msg =
    NoOp
    | Input String
    | Store
    | SendFail Http.Error
    | SendSuccess { entries: List Entry, title: String, description: String}

-- UPDATE
-- Updates application model/state
update : Msg -> RoomModel -> (RoomModel, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Input name ->
            ( RoomModel model.entries model.title model.description (Entry name), Cmd.none)

        Store ->
            ( model, (postEntries ("/api/" ++ model.title ++ "/entry") ((\entry -> entry.name) model.currentEntry)))

        SendFail error ->
            -- let
            --     -- _ = (log "Elm error" error)
            -- in
                ( model, Cmd.none )
        SendSuccess data ->
            ({model | entries = data.entries, title = data.title, description = data.description}, Cmd.none)


-- Fetch room data
getEntries: String -> Cmd Msg
getEntries title =
        Task.perform SendFail SendSuccess (Http.get roomDecoder ("/api/" ++ title))

-- Params for http PUT requests with json payload (updating entries)
requestParams : String -> Http.Body -> Http.Request
requestParams url encName =
    { verb = "PUT"
    , headers = [("content-type", "application/json; charset=utf-8")]
    , url = url
    , body = encName
    }

-- Encode an entry and send to server
postEntries: String -> String -> Cmd Msg
postEntries url currentEntry =
    let
        encodedCurrent = Http.string( encode 1 (Json.Encode.object [("name", Json.Encode.string currentEntry)]))
    in
        (Task.perform SendFail SendSuccess (Http.fromJson roomDecoder (Http.send Http.defaultSettings (requestParams url encodedCurrent))))

-- Decodes room JSON objects
roomDecoder: Json.Decode.Decoder {entries: List Entry, title: String, description: String}
roomDecoder =
    object3 (\entries -> \title -> \description -> {entries=entries, title=title, description=description})
        ("entries" := (list entryDecoder))
        ("title" := string)
        ("description" := string)

--Decodes entry JSON objects
entryDecoder: Json.Decode.Decoder { name: String }
entryDecoder =
    object1 (\name -> { name=name })
        ("name" := string)

-- SUBSCRIPTIONS
subscriptions : RoomModel -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW

--Writes out entries
listItem : {a | name: String} -> Html Msg
listItem entry =
    div [] [ text (entry.name) ]

--The main view
view : RoomModel -> Html Msg
view model =
    div [ id "wrapper" ]
        [ div [ id "main" ]
            [ div [ class "column"]
                 [ div [ class "row" ]
                    [
                        h1 [] [ text ( model.title ) ]
                    ]
                 , div [ class "row" ]
                   [
                       p [] [ text ( model.description ) ]
                   ]
                 , div [ class "row" ]
                    [ input [type' "text", maxlength 15, autofocus True, placeholder "Navn", onInput Input] []
                    , button [ onClick Store] [ text ("Meld meg på") ]
                    ]
                , div [ class "row" ]
                    [  div [ class "row" ]
                        [
                            div [class "entries"]
                            (List.map listItem model.entries)
                        ]
                    ]
                ]
            ]
        ]
