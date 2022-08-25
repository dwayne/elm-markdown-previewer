port module Main exposing (main)


import Browser
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Markdown


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = always Sub.none
    , view = view
    }


-- MODEL


type alias Model =
  { content : String
  , maximized : Maybe Window
  }


type Window
  = Editor
  | Previewer


init : () -> (Model, Cmd msg)
init _ =
  ( Model defaultContent Nothing
  , Cmd.none
  )


-- UPDATE


type Msg
  = ClickedMaximizeButton Window
  | ClickedMinimizeButton
  | EnteredMarkdown String


update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    ClickedMaximizeButton window ->
      ( { model | maximized = Just window }
      , sendEvent "maximize"
      )

    ClickedMinimizeButton ->
      ( { model | maximized = Nothing }
      , sendEvent "minimize"
      )

    EnteredMarkdown content ->
      ( { model | content = content }
      , Cmd.none
      )


-- PORTS


port sendEvent : String -> Cmd msg


-- VIEW


view : Model -> H.Html Msg
view { content, maximized } =
  H.div []
    [ H.div [ HA.class "container container--width--small" ]
        [ viewEditorWindow content (maximized == Just Editor) ]
    , H.div [ HA.class "container container--width--medium" ]
        [ viewPreviewerWindow content (maximized == Just Previewer) ]
    , H.footer [] [ viewAttribution ]
    ]


viewEditorWindow : String -> Bool -> H.Html Msg
viewEditorWindow content =
  let
    editor =
      H.textarea
        [ HA.class "editor window__content"
        , HE.onInput EnteredMarkdown
        ]
        [ H.text content ]
  in
  viewWindow
    { iconClass = "fas fa-edit"
    , title = "Editor"
    , onMaxClick = ClickedMaximizeButton Editor
    , onMinClick = ClickedMinimizeButton
    }
    editor


viewPreviewerWindow : String -> Bool -> H.Html Msg
viewPreviewerWindow content =
  let
    previewer =
      H.div
        [ HA.class "previewer window__content" ]
        [ toHtml content "previewer__html" ]
  in
  viewWindow
    { iconClass = "fab fa-html5"
    , title = "Previewer"
    , onMaxClick = ClickedMaximizeButton Previewer
    , onMinClick = ClickedMinimizeButton
    }
    previewer


toHtml : String -> String -> H.Html msg
toHtml content className =
  Markdown.toHtmlWith
    { githubFlavored = Just { tables = True, breaks = False }
    , defaultHighlighting = Just "elm"
    , sanitize = True
    , smartypants = False
    }
    [ HA.class className ]
    content


type alias Config msg =
  { iconClass : String
  , title : String
  , onMaxClick : msg
  , onMinClick : msg
  }


viewWindow : Config msg -> H.Html msg -> Bool -> H.Html msg
viewWindow config content isMaximized =
  H.div
    [ HA.class "window window--theme--forest"
    , HA.classList [ ("window--maximized", isMaximized) ]
    ]
    [ H.div [ HA.class "window__frame" ]
        [ H.div [ HA.class "window__header" ]
            [ H.div [ HA.class "window__icon" ] [ H.i [ HA.class config.iconClass ] [] ]
            , H.h2 [ HA.class "window__title" ] [ H.text config.title ]
            , if isMaximized then
                viewMinimizeButton config.onMinClick
              else
                viewMaximizeButton config.onMaxClick
            ]
        , H.div [ HA.class "window__body" ] [ content ]
        ]
    ]


viewMaximizeButton : msg -> H.Html msg
viewMaximizeButton onClick =
  H.button
    [ HA.class "window__button"
    , HE.onClick onClick
    ]
    [ H.i
        [ HA.class "fas fa-expand"
        , HA.title "Click to maximize"
        ]
        []
    ]


viewMinimizeButton : msg -> H.Html msg
viewMinimizeButton onClick =
  H.button
    [ HA.class "window__button"
    , HE.onClick onClick
    ]
    [ H.i
        [ HA.class "fas fa-compress"
        , HA.title "Click to minimize"
        ]
        []
    ]


viewAttribution : H.Html msg
viewAttribution =
  H.p [ HA.class "attribution" ]
    [ H.text "by "
    , H.a [ HA.href "https://github.com/dwayne" ] [ H.text "Dwayne Crooks" ]
    ]


-- DATA


defaultContent : String
defaultContent =
  """# An Elm Markdown Previewer!

## This is a sub-heading...
### And here's some other cool stuff:

Here's some code, `<div></div>`, between 2 backticks.

```
-- This is multi-line code:
head : List a -> Maybe a
head list =
  case list of
    [] ->
      Nothing
    (x::_) ->
      Just x
```

You can also make text **bold**... whoa!
Or _italic_.
Or... wait for it... **_both!_**
And feel free to go crazy ~~crossing stuff out~~.

There's also [links](https://learn.freecodecamp.org/front-end-libraries/front-end-libraries-projects/build-a-markdown-previewer/), and
> Block Quotes!

And if you want to get really crazy, even tables:

Wild Header | Crazy Header | Another Header?
------------ | ------------- | -------------
Your content can | be here, and it | can be here....
And here. | Okay. | I think we get it.

- And of course there are lists.
  - Some are bulleted.
     - With different indentation levels.
        - That look like this.

1. And there are numbererd lists too.
1. Use just 1s if you want!
1. But the list goes on...
- Even if you use dashes or asterisks.
* And last but not least, let's not forget embedded images:

![Elm Logo](https://tinyurl.com/y57bom6e)"""
