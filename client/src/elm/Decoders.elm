module Decoders exposing (..)

--CORE & COMMUNITY MODULES/PACKAGES
import Json.Decode exposing (Decoder, string, list, object3, object1, (:=))

--LOCAL MODULES
import Models exposing (Entry)

--This module contains the decodes needed to parse the response data from server api's

-- TODO: Instead of RoomInfo, consider rewriting room model to union type.
type alias RoomInfo = { entries: List Entry, title: String, description: String}

-- Decodes room JSON objects
roomDecoder: Decoder RoomInfo
roomDecoder =
    object3 RoomInfo
        ("entries" := (list entryDecoder))
        ("title" := string)
        ("description" := string)


--Decodes room entry data
entryDecoder: Decoder Entry
entryDecoder =
    object1 Entry
        ("name" := string)
