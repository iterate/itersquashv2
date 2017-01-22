module Main exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES

import Html.Attributes exposing (attribute, placeholder, maxlength, action, rows, type_, autofocus, id, class, action, for, contenteditable, style, name, value)
import Html exposing (Html, Attribute, button, div, text, input, h1, p, form, label, i, ul, li, span, textarea)
import Html.Events exposing (onClick, onInput, onSubmit, onWithOptions, Options)
import Json.Encode exposing (encode, object, list, string)
import Json.Decode
import Http
import Task

--LOCAL MODULES

import Models exposing (RoomModel, Entry)
import Messages exposing (..)
import Decoders exposing (roomDecoder)
import Markdown exposing (..)

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
        ( RoomModel [] room "This is a description" False (Entry ""), getEntries room )



-- UPDATE
-- Updates application model/state


update : Msg -> RoomModel -> ( RoomModel, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Input name ->
            ( RoomModel model.entries model.title model.description model.editing (Entry name), Cmd.none )

        Store ->
            ( { model | currentEntry = (Entry "")}, (postEntries ("/api/" ++ model.title ++ "/entry") ((\entry -> entry.name) model.currentEntry)) )

        FetchFail ->
            ( model, Cmd.none )

        FetchSuccess data ->
            ( { model | entries = data.entries, title = data.title, description = data.description }, Markdown.parse data.description)

        FetchWoop data ->
            ( { model | entries = data.entries, title = data.title, description = data.description }, getEntries data.title )

        StoreDescription description ->
            ( { model | description = description}, Cmd.batch([Markdown.parse description, (updateDescription ("/api/" ++ model.title ++ "/description") description)])  )

        EditToggle ->
            ( { model | editing = (not model.editing) }, Cmd.none )

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

-- VIEWS

menuComp : Html Msg
menuComp =
    (
        div [ class "menu" ] [
            -- div [ class "buttonwrapper" ] [
            --     button [ id "menubutton", class "mdl-button mdl-js-button mdl-button--icon" ] [
            --         i [ class "material-icons" ] [ text "more_vert" ]
            --     ]
            --     , ul [ class "mdl-menu mdl-js-menu mdl-menu--bottom-right mdl-js-ripple-effect", mdlFor "menubutton"]
            --         [ li [ class "mdl-menu__item" ] [ text "Github" ] ]
            -- ]
        ]
    )

mdlFor: String -> Attribute msg
mdlFor value =
    attribute "for" value


peopleList : List Entry -> List (Html Msg)
peopleList entries =
    let
        listItem entry =
            (li [ class "entries__item mdl-list__item" ]
            [ span
                [ class "mdl-list__item-primary-content" ]
                    [ i [ class "material-icons mdl-list__item-icon" ]
                        [ text "person" ]
                    , text (entry.name) ]
            ]
        )
    in
        (List.map listItem entries)

hideShow: Bool -> List (String, String)
hideShow editmode =
    case editmode of
        True ->
            [("display", "block")]

        False ->
            [("display", "none")]

view : RoomModel -> Html Msg
view model =
    div [] [
        menuComp
        , div [ class "content" ]
            [ div [ class "wrapper" ]
                [ div [ class "column" ]
                    [ div [ class "row description" ]
                        [ div [ class "description__textbox mdl-textfield mdl-js-textfield"]
                            [ textarea [ id "markdownInput", class "description__text_input mdl-textfield__input", rows 10, name "markdownInput", style (hideShow model.editing), onInput StoreDescription ]
                                [ text model.description ]
                            , div [ class "description__text_output" , id "markdownOutput" ] [ ]
                            , i [ class "description__editbutton material-icons", onClick EditToggle ] [ text "mode_edit" ]
                            ]
                        ]
                    , div [ class "row entry" ]
                        [ form [ ]
                            [ div [ class "entry_textfield mdl-textfield mdl-js-textfield" ]
                                [ input [ class "mdl-textfield__input", type_ "text", id "entryField", maxlength 100, autofocus True, onInput Input, value ((\entry -> entry.name) model.currentEntry)] [ ]
                                  , label [ class "mdl-textfield__label", for "entryField" ] [ text "Navn" ]
                                ]
                            ]
                            , button [ class "entry_button mdl-button mdl-js-button mdl-button--fab mdl-button--mini-fab mdl-button--colored", onClick Store ]
                                [ i [ class "material-icons" ]
                                    [ text "add" ]
                                ]
                        ]
                    , div [ class "row entries" ]
                        [ ul [ class "entries__list mdl-list" ]
                            (peopleList model.entries)
                        ]
                    ]
                ]
            ]
    ]
