module StyleSheet exposing (..)

import Style exposing (..)


-- import Style.Media

import Color exposing (Color)
import Color.Mixing


--------------------
-- Define Palettes
--------------------


fonts : { code : Property, body : { normal : Property, large : Property } }
fonts =
    { body =
        { normal =
            Style.mix
                [ font "'Noto Sans', Georgia"
                , fontsize 16
                , lineHeight 1.7
                ]
        , large =
            Style.mix
                [ font "'Source Sans Pro', 'Trebuchet MS', 'Lucida Grande', 'Bitstream Vera Sans', 'Helvetica Neue', sans-serif;"
                , fontsize 22
                , lineHeight 1.2
                ]
        }
    , code =
        Style.mix
            [ font "Inconsolata, Courier"
            , fontsize 16
            , lineHeight 1
            ]
    }


{-| Defining all your colors in one place makes fixing color issues a breeze on apps with large style sheets.
-}
colors =
    { white = Color.white
    , black = Color.rgb 10 10 10
    , transparent = Color.rgba 255 255 255 0
    , grey =
        { darkest = Color.darkCharcoal
        , darker = Color.charcoal
        , dark = Color.lightCharcoal
        , medium = Color.darkGrey
        , light = Color.grey
        , lighter = Color.lightGrey
        , lightest = Color.rgb 245 245 245
        , out = Color.rgba 0 0 0 0.4
        }
    , blue =
        { dark = Color.Mixing.darken 0.1 (Color.rgb 12 148 200)
        , normal = Color.rgb 12 148 200
        , light = Color.Mixing.lighten 0.1 (Color.rgb 12 148 200)
        }
    , red =
        { dark = Color.Mixing.darken 0.1 Color.red
        , normal = Color.red
        , light = Color.Mixing.lighten 0.1 Color.red
        }
    }


type Class
    = MainContainer
    | DropdownContainer
    | DropdownInput
    | DropdownDisabled
    | DropdownText
    | DropdownList
    | DropdownListItem


stylesheet : StyleSheet Class msg
stylesheet =
    Style.render
        [ class MainContainer
            [ height auto
              --(percent 100)
            , padding (all 16)
              -- , spacing (all 16)
            , backgroundColor colors.grey.lightest
            ]
        , class DropdownContainer
            [ width (px 216)
              -- , padding (all 16)
            , spacing (all 16)
            , inline
            , fonts.body.large
            ]
        , class DropdownInput
            [ borderWidth (all 0.17)
            , borderRadius (all 4)
            , backgroundColor colors.white
            , cursor "pointer"
            , flowLeft
                { wrap = True
                , horizontal = alignCenter
                , vertical = alignTop
                }
            ]
        , class DropdownDisabled
            [ textColor colors.grey.out
            , cursor "not-allowed"
            ]
        , class DropdownText
            [ flowLeft
                { wrap = True
                , horizontal = alignCenter
                , vertical = alignTop
                }
            ]
        , class DropdownList
            [ topLeft 0 0
            , cursor "pointer"
            , padding ( 4.0, 8.0, 0, 0 )
            , shadows
                [ shadow
                    { offset = ( 0, 2 )
                    , blur = 5
                    , size = 0
                    , color = Color.rgba 0 0 0 0.26
                    }
                ]
            ]
        , class DropdownListItem
            [ flowLeft
                { wrap = True
                , horizontal = alignCenter
                , vertical = alignTop
                }
            , hover
                [ backgroundColor colors.grey.light
                , cursor "pointer"
                ]
            ]
        ]


{-| -}
forever : Float
forever =
    1.0 / 0
