module Messages exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES
import Http

--LOCAL MODULES
import Models exposing (RoomModel, Entry)

-- Define a few custom types for managing the state and data flows
type Msg =
    NoOp
    | Input String
    | Store
    | SendFail Http.Error
    | SendSuccess { entries: List Entry, title: String, description: String}
