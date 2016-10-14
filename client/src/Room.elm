module Room exposing (..)

-- MODEL
type alias Entry = { name: String }
type alias RoomModel = { entries : List Entry, title: String, description: String, currentEntry: Entry}

-- For "safety" we create a type alias for application input from the page
type alias Flags = { room: String }
