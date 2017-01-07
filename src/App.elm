module App exposing (..)

import Html exposing (Html, text, div, img, button)
import Dict exposing (Dict)
import Mouse
import Dropdown as Dropdown
import StyleSheet exposing (Class(..))
import Style exposing (all)
import Html.Events exposing (onClick)


-- main MODEL


type alias Model =
    { apparaat : Maybe Apparaat
    , bouwGrootte : Maybe BouwGrootte
    , openDropDown : OpenDropDown
    }


type OpenDropDown
    = AllClosed
    | ApparaatDropDown
    | BouwGrootteDropDown


initialModel : Model
initialModel =
    { apparaat = Nothing
    , bouwGrootte = Nothing
    , openDropDown = AllClosed
    }


init : String -> ( Model, Cmd Msg )
init path =
    ( { apparaat = Nothing
      , bouwGrootte = Nothing
      , openDropDown = AllClosed
      }
    , Cmd.none
    )



-- simple types so we can read the code better


type alias Apparaat =
    String


type alias BouwGrootte =
    String



-- global constants / config


allApparaten : Dict Apparaat (List BouwGrootte)
allApparaten =
    Dict.fromList
        [ ( "OLU", [ "1A", "1B", "2A", "2B" ] )
        , ( "GOLU", [ "1B", "3S" ] )
        , ( "BPU", [ "1A", "1B", "2A", "2B" ] )
        ]


apparaten : List Apparaat
apparaten =
    Dict.keys allApparaten


apparaatConfig : Dropdown.Config Msg
apparaatConfig =
    { defaultText = "-- pick a unit --"
    , clickedMsg = Toggle ApparaatDropDown
    , itemPickedMsg = ApparaatPicked
    }


bouwGrootteConfig : Dropdown.Config Msg
bouwGrootteConfig =
    { defaultText = "-- pick a size --"
    , clickedMsg = Toggle BouwGrootteDropDown
    , itemPickedMsg = BouwGroottePicked
    }


type Msg
    = Toggle OpenDropDown
    | ApparaatPicked Apparaat
    | BouwGroottePicked BouwGrootte
    | Blur
    | Reset



-- UPDATE helpers so we can read update itself more easily


noCmd : Model -> ( Model, Cmd msg )
noCmd model =
    ( model, Cmd.none )


setBouwGroottePicked : BouwGrootte -> Model -> Model
setBouwGroottePicked pickedBouwGrootte model =
    { model
        | bouwGrootte = Just pickedBouwGrootte
        , openDropDown = AllClosed
    }


setToggleDropdown : OpenDropDown -> Model -> Model
setToggleDropdown dropdown model =
    let
        newOpenDropDown =
            if model.openDropDown == dropdown then
                AllClosed
            else
                dropdown
    in
        { model | openDropDown = newOpenDropDown }


setApparaatPicked : Apparaat -> Model -> Model
setApparaatPicked pickedApparaat model =
    let
        newBouwGrootte =
            if model.apparaat /= Just pickedApparaat then
                Nothing
            else
                model.bouwGrootte
    in
        { model
            | apparaat = Just pickedApparaat
            , bouwGrootte = newBouwGrootte
            , openDropDown = AllClosed
        }


setBlur : Model -> Model
setBlur model =
    { model
        | openDropDown = AllClosed
    }


setReset : Model -> Model
setReset model =
    { model
        | apparaat = Nothing
        , bouwGrootte = Nothing
        , openDropDown = AllClosed
    }


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Toggle dropdown ->
            model |> setToggleDropdown dropdown |> noCmd

        ApparaatPicked pickedApparaat ->
            model |> setApparaatPicked pickedApparaat |> noCmd

        BouwGroottePicked pickedBouwGrootte ->
            model
                |> setBouwGroottePicked pickedBouwGrootte
                |> noCmd

        Blur ->
            model |> setBlur |> noCmd

        Reset ->
            model |> setReset |> noCmd


{ class, classList } =
    StyleSheet.stylesheet



-- VIEW


view : Model -> Html Msg
view model =
    let
        apparaatContext =
            { selectedItem = model.apparaat
            , isOpen = model.openDropDown == ApparaatDropDown
            }

        bouwGrootteContext =
            { selectedItem = model.bouwGrootte
            , isOpen = model.openDropDown == BouwGrootteDropDown
            }

        bouwGrootten =
            model.apparaat
                |> Maybe.andThen (\c -> Dict.get c allApparaten)
                |> Maybe.withDefault []

        orderingcode =
            case model.apparaat of
                Just a ->
                    case model.bouwGrootte of
                        Just b ->
                            "orderingcode: " ++ a ++ b ++ "..."

                        Nothing ->
                            "orderingcode: " ++ a ++ "..."

                Nothing ->
                    "orderingcode: ..."
    in
        div []
            -- Html.Attributes.style Styles.mainContainer ]
            [ Style.embed StyleSheet.stylesheet
            , div [] [ text orderingcode ]
            , div [ class MainContainer ]
                [ Dropdown.view
                    apparaatConfig
                    apparaatContext
                    apparaten
                , Dropdown.view bouwGrootteConfig bouwGrootteContext bouwGrootten
                ]
            , button [ onClick Reset ] [ text "reset" ]
            ]


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.openDropDown of
        AllClosed ->
            Sub.none

        _ ->
            Mouse.clicks (always Blur)
