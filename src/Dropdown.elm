module Dropdown exposing (Context, Config, view)

{- a Dropdown component that manages its own state -}

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onWithOptions)
import Json.Decode as Json
import StyleSheet exposing (Class(..))


--import Style exposing (all)
--import Styles.Styles as Styles
-- MODEL
{- Context type alias
   this is dynamic stuff - may change in each update cylce
   this is not managed by the dropdown, but passed in from parent
   kind of like props (including callbacks) in react
-}


type alias Context =
    { selectedItem : Maybe String
    , isOpen : Bool
    }



{- Config is the static stuff, that won't change during life cylce
   Like functions and message constructors
   Also transparent, because this is also owned by parent
-}


type alias Config msg =
    { defaultText : String
    , clickedMsg : msg
    , itemPickedMsg : String -> msg
    }



-- VIEW


{ class, classList } =
    StyleSheet.stylesheet


view : Config msg -> Context -> List String -> Html msg
view config context data =
    let
        mainText =
            context.selectedItem
                |> Maybe.withDefault config.defaultText

        displayStyle =
            if context.isOpen then
                ( "display", "block" )
            else
                ( "display", "none" )

        mainAttr =
            case data of
                [] ->
                    [ class DropdownDisabled
                    , class DropdownInput
                    ]

                _ ->
                    [ class DropdownInput
                    , onClick config.clickedMsg
                    ]
    in
        div
            [ class DropdownContainer ]
            [ p
                mainAttr
                [ span [ class DropdownText ] [ text mainText ]
                , span [] [ text "▾" ]
                ]
            , ul
                [ style <| [ displayStyle ]
                , class DropdownList
                ]
                (List.map (viewItem config) data)
            ]


viewItem : Config msg -> String -> Html msg
viewItem config item =
    li
        [ class DropdownListItem
        , onClick <| config.itemPickedMsg item
        ]
        [ text item ]



-- helper to cancel click anywhere


onClick : msg -> Attribute msg
onClick message =
    onWithOptions
        "click"
        { stopPropagation = True
        , preventDefault = False
        }
        (Json.succeed message)
