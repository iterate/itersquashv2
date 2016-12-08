module Main exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES

import Html
import Html.Attributes exposing (placeholder, maxlength, type_, autofocus, id, class)
import Html exposing (Html, button, div, text, input, h1, p)
import Html.Events exposing (onClick, onInput, onSubmit)
import Json.Encode exposing (encode, object, list, string)
import Json.Decode
import Http
import Task


--LOCAL MODULES

import Models exposing (RoomModel, Entry)
import Messages exposing (..)
import Decoders exposing (roomDecoder)
import Views.ListItem exposing (listItems)


main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- For "safety" we create a type alias for application input from the page


type alias Flags =
    { room : String }



--Initialize model/application state


init : Flags -> ( RoomModel, Cmd Msg )
init flags =
    let
        { room } =
            flags
    in
        ( RoomModel [] room "This is a description" (Entry ""), getEntries room )



-- UPDATE
-- Updates application model/state


update : Msg -> RoomModel -> ( RoomModel, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Input name ->
            ( RoomModel model.entries model.title model.description (Entry name), Cmd.none )

        Store ->
            ( model, (postEntries ("/api/" ++ model.title ++ "/entry") ((\entry -> entry.name) model.currentEntry)) )

        FetchFail ->
            ( model, Cmd.none )

        FetchSuccess data ->
            ( { model | entries = data.entries, title = data.title, description = data.description }, Cmd.none )

        FetchWoop data ->
            ({ model | entries = data.entries, title = data.title, description = data.description }, getEntries data.title )


-- Fetch room data


getEntries : String -> Cmd Msg
getEntries title =
    Http.send
        (\result ->
            case result of
                Ok data ->
                    FetchSuccess data

                Err err ->
                    FetchFail
        )
        (Http.get ("/api/" ++ title) roomDecoder)



-- Encode an entry and send to server


postEntries : String -> String -> Cmd Msg
postEntries url currentEntry =
    let
        data =
            object [("name", string currentEntry)]
        request =
            Http.request
                { method = "PUT"
                , url = url
                , headers = []
                , body = Http.jsonBody data
                , expect = Http.expectJson roomDecoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send
            (\result ->
                case result of
                    Ok data ->
                        FetchSuccess data

                    Err err ->
                        FetchFail
            ) request


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
            [ div [ class "column" ]
                [ div [ class "row" ]
                    [ h1 [] [ text (model.title) ]
                    ]
                , div [ class "row" ]
                    [ p [] [ text (model.description) ]
                    ]
                , div [ class "row" ]
                    [ input [ type_ "text", maxlength 15, autofocus True, placeholder "Navn", onInput Input ] []
                    , button [ onClick Store ] [ text ("Meld meg på") ]
                    ]
                , div [ class "row" ]
                    [ div [ class "row" ]
                        [ div [ class "entries" ]
                            (listItems model.entries)
                        ]
                    ]
                ]
            ]
        ]
