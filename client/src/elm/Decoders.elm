module Decoders exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES

import Json.Decode exposing (Decoder, string, int, list, decodeString, map4, list, map, map3, maybe, field)

--LOCAL MODULES

import Models exposing (ServerData, Participant)

-- Decodes room JSON objects

entryDecoder : Decoder (List Participant)
entryDecoder =
    list personDecoder

descriptionDecoder : Decoder String
descriptionDecoder =
    string

personDecoder : Decoder Participant
personDecoder = 
    map3 (\id name createdAt -> Participant False id name createdAt "") (field "id" int) (field "name" string) (field "createdAt" string)
    