module Main exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES
import Html
import Html.App
import Html.Attributes exposing (placeholder, maxlength,type', autofocus, id, class)
import Html exposing (Html, button, div, text, input, h1, p)
import Html.Events exposing (onClick, onInput, onSubmit)
import Json.Encode exposing (encode)
import Http
import Task

--LOCAL MODULES
import Models exposing (RoomModel, Entry)
import Messages exposing (..)
import Decoders as Dec exposing (..)
import Views.ListItem exposing (listItems)


main =
    Html.App.programWithFlags
    {   init = init,
        update = update,
        view = view,
        subscriptions = subscriptions
    }

-- For "safety" we create a type alias for application input from the page
type alias Flags = { room: String }

--Initialize model/application state
init : Flags -> (RoomModel, Cmd Msg)
init flags =
    let
        { room } = flags
    in
        ( RoomModel [] room "This is a description" (Entry ""), getEntries room)

-- UPDATE
-- Updates application model/state
update : Msg -> RoomModel -> (RoomModel, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Input name ->
            ( RoomModel model.entries model.title model.description (Entry name), Cmd.none )

        Store ->
            ( model, (postEntries ("/api/" ++ model.title ++ "/entry") ((\entry -> entry.name) model.currentEntry )))

        SendFail error ->
                ( model, Cmd.none )
        SendSuccess data ->
            ({ model | entries = data.entries, title = data.title, description = data.description}, Cmd.none )


-- Fetch room data
getEntries: String -> Cmd Msg
getEntries title =
        Task.perform SendFail SendSuccess ( Http.get Dec.roomDecoder ("/api/" ++ title ))


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
        (Task.perform SendFail SendSuccess (Http.fromJson Dec.roomDecoder (Http.send Http.defaultSettings (requestParams url encodedCurrent))))


-- SUBSCRIPTIONS
subscriptions : RoomModel -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW
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
                            (listItems model.entries)
                        ]
                    ]
                ]
            ]
        ]
