module Messages exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES

import Http exposing (..)

--LOCAL MODULES

import Models exposing (RoomInfo)

-- Define a few custom types for managing the state and data flows


type Msg
    = NoOp
    | Input String
    | StoreEntry
    | FetchSuccess RoomInfo
    | FetchFail
    | StoreDescription String
    | EditToggle
