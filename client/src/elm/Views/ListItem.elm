module Views.ListItem exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES
import Html exposing (Html, div, text)

--LOCAL MODULES
import Messages as Msg exposing (Msg)
import Models as Entry exposing (Entry)

-- This view writes out the given entries in a list of items

listItem : Entry -> Html Msg
listItem entry =
    ( div [] [ text (entry.name) ] )

listItems : List Entry -> List (Html Msg)
listItems entries =
    ( List.map listItem entries )
