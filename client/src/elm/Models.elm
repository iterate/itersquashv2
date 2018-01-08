module Models exposing (..)

-- MODEL

type alias EventModel =
    { participants : Maybe (List Participant)
    , title : String
    , description : String
    , parsedDescription: String 
    , editing : Bool
    , id: Int
    , newParticipant: Participant }

type alias ServerData =
    { participants : List Participant
    , title : String
    , description : String
    , id : String }

type alias Participant = {
      edit : Bool
    , id   : Int
    , name : String
    , createdAt : String
    , createdAtTimeSince : String
}
