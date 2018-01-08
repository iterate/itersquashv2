module Messages exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES


--LOCAL MODULES

import Models exposing (ServerData, Participant)

-- Define a few custom types for managing the state and data flows


type Msg
    = NoOp
    | NewParticipant String
    | PutParticipant
    | FetchFail
    | UpdateParticipant Participant
    | EditParticipant Participant String
    | EditParticipantToggle Participant
    | PutParticipantSuccess (List Participant)
    | GetParticipantSuccess (List Participant)
    | PutDescription
    | EditDescription String
    | GetDescriptionSuccess String
    | EditDescriptionToggle
    | ParsedTime (List Participant)
    | DeleteParticipant Participant
