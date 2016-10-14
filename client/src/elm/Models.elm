module Models exposing (..)

-- MODEL
type alias Entry = { name: String }
type alias RoomModel = { entries : List Entry, title: String, description: String, currentEntry: Entry}
