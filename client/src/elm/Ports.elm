port module Ports exposing (..)
import Models exposing (Participant)

-- MOMENT interop

port parsedTime : (List Participant -> msg) -> Sub msg
port parseTime : List Participant -> Cmd msg