port module Main exposing (main)


import Browser
import Html exposing (Html, a, button, div, footer, h2, i, p, text, textarea)
import Html.Attributes as A exposing (class)
import Html.Events as E
import Markdown


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , subscriptions = always Sub.none
    , update = update
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
  ( { content = defaultContent
    , maximized = Nothing
    }
  , Cmd.none
  )


-- UPDATE


type Msg
  = ChangedContent String
  | Maximized Window
  | Minimized


update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    ChangedContent newContent ->
      ( { model | content = newContent }
      , Cmd.none
      )

    Maximized window ->
      ( { model | maximized = Just window }
      , onEvent "maximize"
      )

    Minimized ->
      ( { model | maximized = Nothing }
      , onEvent "minimize"
      )


-- PORTS


port onEvent : String -> Cmd msg


-- VIEW


view : Model -> Html Msg
view { content, maximized } =
  div []
    [ div [ class "container container--width--small" ]
        [ viewEditorWindow (maximized == Just Editor) content ]
    , div [ class "container container--width--medium" ]
        [ viewPreviewerWindow (maximized == Just Previewer) content ]
    , footer []
        [ viewAttribution ]
    ]


viewEditorWindow : Bool -> String -> Html Msg
viewEditorWindow isMaximized content =
  viewWindow
    { icon = Edit
    , title = "Editor"
    , isScrollable = False
    , maximize = Maximized Editor
    }
    isMaximized
    <| textarea
         [ class "editor editor--theme--forest window__content"
         , A.classList [ ("editor--locked", isMaximized) ]
         , E.onInput ChangedContent
         ]
         [ text content ]


viewPreviewerWindow : Bool -> String -> Html Msg
viewPreviewerWindow isMaximized content =
  viewWindow
    { icon = Html5
    , title = "Previewer"
    , isScrollable = True
    , maximize = Maximized Previewer
    }
    isMaximized
    <| div [ class "previewer previewer--theme--forest window__content" ]
         [ toHtml content "previewer__markdown" ]


toHtml : String -> String -> Html msg
toHtml content className =
  Markdown.toHtmlWith
    { githubFlavored = Just { tables = True, breaks = False }
    , defaultHighlighting = Just "elm"
    , sanitize = True
    , smartypants = False
    }
    [ class className ]
    content


type alias Config msg =
  { icon : Icon
  , title : String
  , isScrollable : Bool
  , maximize : msg
  }


viewWindow : Config Msg -> Bool -> Html Msg -> Html Msg
viewWindow config isMaximized body =
  div
    [ class "window window--theme--forest"
    , A.classList [ ("window--maximized", isMaximized) ]
    ]
    [ div [ class "window__frame" ]
        [ div [ class "window__header" ]
            [ div [ class "window__icon" ] [ viewIcon config.icon ]
            , h2 [ class "window__title" ] [ text config.title ]
            , if isMaximized then
                button
                  [ class "window__button"
                  , E.onClick Minimized
                  ]
                  [ viewIconWithTitle Compress "Click to minimize" ]
              else
                button
                  [ class "window__button"
                  , E.onClick config.maximize
                  ]
                  [ viewIconWithTitle Expand "Click to maximize" ]
            ]
        , div
            [ class "window__body"
            , A.classList
                [ ("window__body--scrollable"
                  , config.isScrollable && isMaximized
                  )
                ]
            ]
            [ body ]
        ]
    ]


type Icon
  = Edit
  | Html5
  | Expand
  | Compress


viewIcon : Icon -> Html msg
viewIcon icon =
  i [ class (iconClass icon) ] []


viewIconWithTitle : Icon -> String -> Html msg
viewIconWithTitle icon title =
  i [ class (iconClass icon), A.title title ] []


iconClass : Icon -> String
iconClass icon =
  case icon of
    Edit ->
      "fas fa-edit"

    Html5 ->
      "fab fa-html5"

    Expand ->
      "fas fa-expand"

    Compress ->
      "fas fa-compress"


viewAttribution : Html msg
viewAttribution =
  p [ class "attribution" ]
    [ text "by "
    , a [ A.href "https://www.dwaynecrooks.com" ] [ text "Dwayne Crooks" ]
    ]


-- DATA


defaultContent : String
defaultContent =
  """# Welcome to my Elm Markdown Previewer!

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
    (x:_) ->
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
