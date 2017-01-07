# Elm-orderingcode
a user interface for selecting an orderingcode



### to do list

- [x] Change example datastructure in pure-dropdown from `coutry-city` to `apparaat-bouwgrootte`
- [ ] check scaling of datastructure, reading [Medium, impossible](https://medium.com/elm-shorts/how-to-make-impossible-states-impossible-c12a07e907b5#.ptxsqbzbu)
- [x] Add a hoverstyle and pointing arrow on the rolled out dropbox items
- [x] implement CSS via [style-elements](http://package.elm-lang.org/packages/mdgriffith/style-elements/latest)
- [ ] some styles from pure-dropdown are not transferred, especially the other dropdown position is falling down together with dropdown of the selected. WHY??
- [ ] do we need a `classList [(style,True), (OtherStyle, model.sel == ?)]` instead of a `class ..`?
- [x] ~~refactor `pureUpdate` from `update` to get rid of the `(pureUpdate, Cmd.none)` tuple~~
- [x] use pipelined update function [billperegoy](https://becoming-functional.com/making-the-elm-model-modular-7c8a8dcdbf3#.ygvk41u7r) and `noCmd` for `(Model, Cmd.none)`-tuple [WouterIntVelt](https://medium.com/@wintvelt/hey-thats-just-how-i-do-it-50b0e6bf2636#.koy8oxsy7)
- [ ] refactor model as in above article (is also scale item above)
- [ ] refactor dropdown+style-elements with [example of Matt](https://groups.google.com/forum/#!msg/elm-discuss/2GX6L4SGVwA/oVrL94HvBwAJ) using `myMixin`, see below
- [x] Make top div for dispay of total orderingcode selected
- [x] make button for reset to start fresh again ![stand_20161231](/assets/stand_20161231.gif)
- [ ] For keybinding/shortcuts, and possibly keyboard input implement [elm-lang/keyboard](https://github.com/elm-lang/keyboard)
- [ ] implement Drag + Drop for image selector [Medium, drag+drop](https://medium.com/elm-shorts/html5-drag-and-drop-in-elm-88d149d3558f#.qan5mz7nk)
- [ ] or via [github, style-animation](https://github.com/mdgriffith/elm-style-animation) / [package, style-animation](http://package.elm-lang.org/packages/mdgriffith/elm-style-animation/latest) or even [draggable-tabs](https://github.com/thebritican/elm-draggable-tabs)
- [ ] Form validation (for log-in) check [Medium Article](https://becoming-functional.com/a-form-validation-library-for-elm-82ef8c7c39d9#.wjdatd443) and [lib](http://package.elm-lang.org/packages/billperegoy/elm-form-validations/latest/Forms)

#### tip from elm-discuss

You can create a mixin as a function.
```elm
myMixin : Style.Model -> Style.Model
myMixin style =
    { style
        | visibility = hidden
    }

myMixinColor : Style.Model -> Style.Model
myMixinColor style =
    { style
        | colors = palette.blue
    }


dropDown : List (Html.Attribute a) -> List (Element a) -> Element a
dropDown =
    element
        ({ base
            | width = px 300
            , padding = all 20
            , spacing = topBottom 40
         }
            |> myMixin
            |> myMixinColor
        )
```

### Packages used

- This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app), [see this post](https://medium.com/@eduardkyvenko/how-to-create-elm-app-cf052629a11a#.72069tlne)
- First start is implementing the [pure dropdown](https://github.com/wintvelt/elm-dropdown) from [Wouter In't Velt](https://github.com/wintvelt/), [see his post](https://medium.com/elm-shorts/a-reusable-dropdown-in-elm-part-1-d7ac2d106f13#.eaexp5ak7)
- CSS is styled via [style-elements](http://package.elm-lang.org/packages/mdgriffith/style-elements/latest)
