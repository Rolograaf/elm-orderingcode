module App exposing (..)

import Html exposing (Html, text, div, img)
import Html.Attributes exposing (src)
import Dict exposing (Dict)
import Mouse
import Dropdown as Dropdown
import StyleSheet exposing (Class(..))
import Style exposing (all)


-- import Styles.Styles as Styles
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Toggle dropdown ->
            let
                newOpenDropDown =
                    if model.openDropDown == dropdown then
                        AllClosed
                    else
                        dropdown
            in
                ( { model | openDropDown = newOpenDropDown }, Cmd.none )

        ApparaatPicked pickedApparaat ->
            let
                newBouwGrootte =
                    if model.apparaat /= Just pickedApparaat then
                        Nothing
                    else
                        model.bouwGrootte
            in
                ( { model
                    | apparaat = Just pickedApparaat
                    , bouwGrootte = newBouwGrootte
                    , openDropDown = AllClosed
                  }
                , Cmd.none
                )

        BouwGroottePicked pickedBouwGrootte ->
            ( { model
                | bouwGrootte = Just pickedBouwGrootte
                , openDropDown = AllClosed
              }
            , Cmd.none
            )

        Blur ->
            ( { model
                | openDropDown = AllClosed
              }
            , Cmd.none
            )


{ class, classList } =
    StyleSheet.stylesheet


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
    in
        div []
            -- Html.Attributes.style Styles.mainContainer ]
            [ Style.embed StyleSheet.stylesheet
            , div [ class MainContainer ]
                [ Dropdown.view
                    apparaatConfig
                    apparaatContext
                    apparaten
                , Dropdown.view bouwGrootteConfig bouwGrootteContext bouwGrootten
                ]
            ]


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.openDropDown of
        AllClosed ->
            Sub.none

        _ ->
            Mouse.clicks (always Blur)
