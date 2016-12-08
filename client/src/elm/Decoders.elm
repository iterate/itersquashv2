module Decoders exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES

import Json.Decode exposing (Decoder, string, list, map3, map, field)


--LOCAL MODULES

import Models exposing (RoomInfo, Entry)


--This module contains the decodes needed to parse the response data from server api's
-- TODO: Instead of RoomInfo, consider rewriting room model to union type.

-- Decodes room JSON objects


roomDecoder : Decoder RoomInfo
roomDecoder =
    map3 RoomInfo
        (field "entries" (list entryDecoder))
        (field "title" string)
        (field "description" string)



--Decodes room entry data


entryDecoder : Decoder Entry
entryDecoder =
    map Entry
        (field "name" string)
