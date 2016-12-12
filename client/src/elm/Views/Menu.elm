module Views.Menu exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES

import Html exposing (Html, Attribute, text, li, ul, i, div, button)
import Html.Attributes exposing (class, attribute, id)

--LOCAL MODULES

import Messages as Msg exposing (Msg)

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
