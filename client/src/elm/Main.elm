module Main exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES

import Html
import Html.Attributes exposing (placeholder, maxlength, type_, autofocus, id, class, action, for)
import Html exposing (Html, button, div, text, input, h1, p, form, label, i, ul)
import Html.Events exposing (onClick, onInput, onSubmit, onWithOptions, Options)
import Json.Encode exposing (encode, object, list, string)
import Json.Decode
import Http
import Task


--LOCAL MODULES

import Models exposing (RoomModel, Entry)
import Messages exposing (..)
import Decoders exposing (roomDecoder)
import Views.ListItem exposing (listComp)
import Views.Menu exposing (menuComp)
import Views.Description exposing (descriptionComp)


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
            ( { model | entries = data.entries, title = data.title, description = data.description }, getEntries data.title )

        StoreDescription ->
            ( model, (updateDescription ("/api/" ++ model.title ++ "/description") model.description) )

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


-- Update entries

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


-- Update description

updateDescription : String -> String -> Cmd Msg
updateDescription url descriptionText =
    let
        data =
            object [("description", string descriptionText)]
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
    div [] [
        menuComp
        , div [ class "content" ]
            [ div [ class "wrapper" ]
                [ div [ class "column" ]
                    [ div [ class "row title" ]
                        [ div [ class "mdl-typography--display-3" ]
                            [ text (model.title) ] ]
                    , div [ class "row description" ]
                        [ descriptionComp model.description ]
                    , div [ class "row entry" ]
                        [ form [ onWithOptions "submit" (Options True True)  (Json.Decode.succeed Store) ]
                            [ div [ class "mdl-textfield mdl-js-textfield" ]
                                [ input [ class "mdl-textfield__input", type_ "text", id "sample1", maxlength 15, autofocus True, onInput Input, onSubmit Store ] []
                                  , label [ class "mdl-textfield__label", for "sample1" ] [ text "Navn" ]
                                ]
                            ]
                            , button [ class "mdl-button mdl-js-button mdl-button--fab mdl-button--mini-fab mdl-button--colored", onClick Store ]
                                [ i [ class "material-icons" ]
                                    [ text "add" ]
                                ]
                        ]
                    , div [ class "row" ]
                        [ ul [ class "demo-list-item mdl-list" ]
                            (listComp model.entries)
                        ]
                    ]
                ]
            ]
    ]
