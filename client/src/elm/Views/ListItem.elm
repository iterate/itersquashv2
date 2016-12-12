module Views.ListItem exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES

import Html exposing (Html, div, text, li, span, i)
import Html.Attributes exposing (class)

--LOCAL MODULES

import Messages as Msg exposing (Msg)
import Models as Entry exposing (Entry)


-- This view writes out the given entries in a list of items


listItem : Entry -> Html Msg
listItem entry =
    (li [ class "mdl-list__item" ]
        [ span
            [ class "mdl-list__item-primary-content" ]
                [ i [ class "material-icons mdl-list__item-icon" ]
                    [ text "person" ]
                , text (entry.name) ]
        ]
    )


listComp : List Entry -> List (Html Msg)
listComp entries =
    (List.map listItem entries)
