module Messages exposing (..)


--CORE & COMMUNITY MODULES/PACKAGES

import Http exposing (..)


--LOCAL MODULES

import Models exposing (RoomInfo, Entry)

-- Define a few custom types for managing the state and data flows


type Msg
    = NoOp
    | Input String
    | Store
    | FetchWoop RoomInfo
    | FetchSuccess RoomInfo
    | FetchFail
    | StoreDescription
