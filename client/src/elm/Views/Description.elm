module Views.Description exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES

import Html exposing (Html, div, text, li, span, i, textarea, label, form, Attribute)
import Html.Attributes exposing (class, action, rows, id, attribute)
import Html.Events exposing (onSubmit)

--LOCAL MODULES

import Messages exposing (..)
import Models as Entry exposing (Entry)

descriptionComp: String -> Html Msg
descriptionComp desc =
    ( form [ onSubmit StoreDescription ]
        [ div [ class "mdl-textfield mdl-js-textfield"]
            [ textarea [ class "mdl-textfield__input", rows 3, id "descriptionBox", (attribute "name" "description") ]
                [ text desc ]
            , label [ class "mdl-textfield__label", (attribute "for" "descriptionBox") ] [ text "Description.." ]
            ]
        ]
    )

-- mdl: String -> Attribute msg
-- mdl attr value =
--     attribute attr value
