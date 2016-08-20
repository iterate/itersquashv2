import Html exposing (h1, div, text, form, input, button)
import Html.Attributes exposing (class, type')

main =
  div [class "container"]
      [h1 [] [text "itercage"]
      ,form [] [input [type' "text"] []
                ,button [type' "submit"] [text "Meld meg på"]
                ]
      ]
