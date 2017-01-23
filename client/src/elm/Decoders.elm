module Decoders exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES

import Json.Decode exposing (Decoder, string, list, map3, map, field)

--LOCAL MODULES

import Models exposing (RoomInfo)

-- Decodes room JSON objects

roomDecoder : Decoder RoomInfo
roomDecoder =
    map3 RoomInfo
        (field "entries" (list (field "name" string) ))
        (field "title" string)
        (field "description" string)
