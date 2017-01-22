module Models exposing (..)

-- MODEL

type alias Entry =
    { name : String }

type alias RoomModel =
    { entries : List Entry, title : String, description : String, editing : Bool, currentEntry : Entry }

type alias RoomInfo =
    { entries : List Entry, title : String, description : String }
