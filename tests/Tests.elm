module Tests exposing (..)

import Test exposing (..)
import Expect
import String
import App


all : Test
all =
    describe "A Test Suite"
        [ test "App.model.openDropDown should be set properly" <|
            \() ->
                Expect.equal (App.model.openDropDown) App.AllClosed
        , test "Addition" <|
            \() ->
                Expect.equal (3 + 7) 10
        , test "String.left" <|
            \() ->
                Expect.equal "a" (String.left 1 "abcdefg")
        , test "This test should fail" <|
            \() ->
                Expect.fail "failed as expected!"
        ]
