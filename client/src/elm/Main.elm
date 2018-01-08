module Main exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES

import Html.Attributes exposing (attribute, placeholder, maxlength, tabindex, action, rows, type_, autofocus, readonly, id, class, action, for, contenteditable, style, name, value)
import Html exposing (Html, Attribute, button, div, text, img, a, input, h1, p, form, label, i, ul, li, span, textarea)
import Html.Events exposing (onClick, onInput, onBlur, on, onWithOptions, onSubmit, defaultOptions, keyCode, targetValue)
import Json.Encode exposing (object, list, string)
import Json.Decode exposing (succeed, fail, andThen)
import Http

--LOCAL MODULES

import Models exposing (EventModel, Participant)
import Messages exposing (..)
import Decoders exposing (entryDecoder, descriptionDecoder)
import Markdown
import Ports exposing (..)

main : Program Flags EventModel Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

-- For "safety" we create a type alias for application input from the page

type alias Flags =
    { title : String, id : Int }

--Initialize model/application state


init : Flags -> ( EventModel, Cmd Msg )
init flags =
        { participants = Just []
        , title = flags.title
        , description = ""
        , parsedDescription = ""
        , editing = False
        , id = flags.id
        , newParticipant = (Participant False -1 "" "" "") } ! [getDescription flags.id, getParticipants flags.id]



-- UPDATE
-- Updates application model/state


update : Msg -> EventModel -> ( EventModel, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        NewParticipant name ->
            { model | newParticipant = Participant False -1 name "" ""} ! []

        PutParticipant ->
            { model | newParticipant = Participant False -1 "" "" ""} ! [ putParticipant model.id model.newParticipant ]

        UpdateParticipant participant ->
            ( model, updateParticipant model.id participant.id participant.name)

        FetchFail ->
            ( model, Cmd.none )

        PutParticipantSuccess participants ->
            ( { model | participants = Just participants }, Ports.parseTime participants)

        GetParticipantSuccess participants ->
            ( { model | participants = Just participants }, Ports.parseTime participants)
                    
        GetDescriptionSuccess description ->
            { model | description = description } ! []

        PutDescription ->
            { model | editing = False } ! [ putDescription model.id model.description ]
        
        EditDescription description ->
            ({ model | description = description }, Cmd.none)

        EditDescriptionToggle ->
            { model | editing = (not model.editing) } ! []
            
        EditParticipantToggle participant -> 
            let
                participants = model.participants
            in   
                (case participants of
                    Nothing ->
                        (model, Cmd.none)

                    Just participants ->
                        { model | participants = Just(toggleEditParticipant participant participants) } ! [])
        
        EditParticipant participant name ->
            let
                participants = model.participants
            in   
                (case participants of
                    Nothing ->
                        (model, Cmd.none)

                    Just participants ->
                        { model | participants = Just(editParticipant participant name participants) } ! [])
        
        ParsedTime participants ->
            { model | participants = Just(participants) } ! []

        DeleteParticipant participant ->
            ( model, deleteParticipant model.id participant.id )
                        

-- Edit a participant

editParticipant : Participant -> String -> List Participant -> List Participant
editParticipant participant name participants =
    (List.map (\e -> if(e==participant) then ({ e | name = name }) else (e)) participants)

-- Toggle a participant for editing

toggleEditParticipant : Participant -> List Participant -> List Participant
toggleEditParticipant participant participants =
    (List.map (\e -> if(e==participant) then (if (e.edit == True) then ({ e | edit = False }) else ({ e | edit = True })) else ({ e | edit = False })) participants)

-- Set time since createdAt

-- setTimeSince : Participant -> List Participant -> String -> List Participant
-- setTimeSince participant participants time =
--     (List.map (\e -> if (e==participant) then ({ participant | createdAtTimeSince = time }) else participant) participants)


-- Fetch description data

getDescription : Int -> Cmd Msg
getDescription id =
    Http.send
        (\result ->
            case result of
                Ok data ->
                    GetDescriptionSuccess data

                Err err ->
                    FetchFail
        )
        (Http.get ("/api/" ++ toString id ++ "/description") descriptionDecoder)

-- Fetch participants data

getParticipants : Int -> Cmd Msg
getParticipants id =
    Http.send
        (\result ->
            case result of
                Ok data ->
                    GetParticipantSuccess data

                Err err ->
                    FetchFail
        )
        (Http.get ("/api/" ++ toString id ++ "/participants") entryDecoder)


-- Store a new participant

putParticipant : Int -> Participant -> Cmd Msg
putParticipant id participant =
    let
        data =
            object [("name", string participant.name)]
        request =
            Http.request
                { method = "PUT"
                , url = ("/api/" ++ toString id ++ "/participants")
                , headers = []
                , body = Http.jsonBody data
                , expect = Http.expectJson entryDecoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send
            (\result ->
                case result of
                    Ok data ->
                        PutParticipantSuccess data

                    Err err ->
                        FetchFail
            ) request

deleteParticipant : Int -> Int -> Cmd Msg
deleteParticipant modelId participantId =
    let
        request =
            Http.request
                { method = "DELETE"
                , url = ("/api/" ++ toString modelId ++ "/participants/" ++ toString participantId)
                , headers = []
                , body = Http.emptyBody
                , expect = Http.expectJson entryDecoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send
            (\result ->
                case result of
                    Ok data ->
                        PutParticipantSuccess data

                    Err err ->
                        FetchFail
            ) request

-- Update a participant

updateParticipant : Int -> Int -> String -> Cmd Msg
updateParticipant modelId participantId name =
    let
        data =
            object [("name", string name)]
        request =
            Http.request
                { method = "PUT"
                , url = ("/api/" ++ toString modelId ++ "/participants/" ++ toString participantId)
                , headers = []
                , body = Http.jsonBody data
                , expect = Http.expectJson entryDecoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send
            (\result ->
                case result of
                    Ok data ->
                        PutParticipantSuccess data

                    Err err ->
                        FetchFail
            ) request

-- Update description
-- TODO: Proper REST
putDescription : Int -> String -> Cmd Msg
putDescription id descriptionText =
    let
        data =
            object [("description", string descriptionText)]
        request =
            Http.request
                { method = "PUT"
                , url = ("/api/" ++ toString id ++ "/description")
                , headers = []
                , body = Http.jsonBody data
                , expect = Http.expectJson descriptionDecoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send
            (\result ->
                case result of
                    Ok data ->
                        GetDescriptionSuccess data

                    Err err ->
                        FetchFail
            ) request

parseMarkdown : String -> Html Msg
parseMarkdown description =
    let
        default = Markdown.defaultOptions
        markdownOptions = { default | githubFlavored = Just { tables = True, breaks = True }, sanitize = True }
    in
        Markdown.toHtmlWith markdownOptions [ class "description-output" ] description


-- SUBSCRIPTIONS

subscriptions : EventModel -> Sub Msg
subscriptions model =
    Ports.parsedTime ParsedTime

-- EVENT LISTENERS

onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                succeed msg
            else
                fail "not ENTER"
    in
        on "keydown" (andThen isEnter keyCode)

-- VIEWS

-- hideShow: Bool -> List (String, String)
-- hideShow editmode =
--     case editmode of
--         True ->
--             [("display", "block")]

--         False ->
--             [("display", "none")]

descriptionField: EventModel -> Html Msg
descriptionField model =
    (div [] [ 
        ((\edit -> if (edit) then (textarea [ class "description-input mdl-textfield__input", tabindex 2, autofocus model.editing, onBlur PutDescription, onInput EditDescription ] [ text model.description ]) else (parseMarkdown model.description)) model.editing),
        a [ attribute "href" "#" , class "material-icons", attribute "aria-label" "Edit description", attribute "title" "Edit description",  onClick EditDescriptionToggle ] [ text "mode_edit" ]]
    )

listParticipants: EventModel -> Html Msg
listParticipants model =
    case model.participants of
        Nothing ->
            (div [][])

        Just participants ->
            let
                makeListItem = (\participant ->
                    (li [ class "mdc-list-item" ] [
                        img [ class "mdc-list-item__start-detail", attribute "src" "https://i.imgur.com/64YQrF7.png", attribute "width" "56", attribute "height" "56", attribute "alt" "Picture of someone"] [],
                        ((\participant -> if (participant.edit) then (
                            span [ class "mdc-text-field mdc-text-field--box mdc-text-field--with-trailing-icon mdc-text-field--upgraded" ] [
                                input [ id "pre-filled", type_ "text", class "mdc-text-field__input", value participant.name, onInput ((\participant -> (\name -> EditParticipant participant name)) participant), onEnter (UpdateParticipant participant) ] [],
                                label [ for "pre-filled", class "mdc-text-field__label mdc-text-field__label--float-above" ] [ text "Name" ],
                                i [ class "material-icons mdc-text-field__icon", onClick (DeleteParticipant participant) ] [ text "delete" ],
                                div [ class "mdc-text-field__bottom-line" ] []
                            ]
                        ) else (
                            span [class "mdc-list-item__text"] [
                                span [ class "participant-edit-fields"] [ text participant.name ],
                                span [ class "mdc-list-item__secondary-text"] [ text participant.createdAtTimeSince ]
                            ]
                        )) participant),
                        a [ attribute "href" "#", attribute "onClick" "event.preventDefault();" , class "mdc-list-item__end-detail material-icons", attribute "aria-label" "Edit participant toggle", attribute "title" "Edit participant toggle", onClick ((\part -> if (String.length part.name > 0) then (EditParticipantToggle part) else (NoOp)) participant)] [ text "mode_edit"] 
                    ]))

                addParticipant = (\model -> 
                    (li [ class "mdc-list-item" ] [
                        img [ class "mdc-list-item__start-detail", attribute "src" "https://i.imgur.com/64YQrF7.png", attribute "width" "56", attribute "height" "56", attribute "alt" "Picture of someone"] [],
                        span [ class "mdc-text-field" ] [
                                input [ id "new-participant", type_ "text", class "mdc-text-field__input", onInput NewParticipant, onEnter ((\part -> if (String.length part.name > 0) then PutParticipant else NoOp) model.newParticipant), value model.newParticipant.name  ] [],
                                label [ for "new-participant", class "mdc-text-field__label" ] [ text "Name" ],
                                div [ class "mdc-text-field__bottom-line" ] []
                        ],
                        a [ attribute "href" "#", class "mdc-list-item__end-detail material-icons", attribute "aria-label" "View more information", attribute "title" "More info", onClick ((\part -> if (String.length part.name > 0) then (PutParticipant) else (NoOp)) model.newParticipant)] [ text "add"]
                    ]))
                
                -- divider = (li [ attribute "role" "separator", class "mdc-list-divider mdc-list-divider--inset"] [])
            in 
                (ul [ class "mdc-list mdc-list--two-line mdc-list--avatar-list participant-list" ] (List.append [(addParticipant model)] (List.map makeListItem participants)))

view : EventModel -> Html Msg
view model =
    (div [] [
        div [ class "event-description" ][ descriptionField model ], 
        listParticipants model
    ])
    