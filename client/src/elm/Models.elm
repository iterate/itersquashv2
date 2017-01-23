module Models exposing (..)

-- MODEL

type alias RoomModel =
    { entries : List String
    , title : String
    , description : String
    , editing : Bool
    , currentEntry : String }

type alias RoomInfo =
    { entries : List String
    , title : String
    , description : String }
