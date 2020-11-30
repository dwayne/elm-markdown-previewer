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


view : Model -> Html Msg
view { content, maximized } =
  div []
    [ div [ class "container container--width--small" ]
        [ viewEditorWindow content (maximized == Just Editor) ]
    , div [ class "container container--width--medium" ]
        [ viewPreviewerWindow content (maximized == Just Previewer) ]
    , footer [] [ viewAttribution ]
    ]


viewEditorWindow : String -> Bool -> Html Msg
viewEditorWindow content =
  let
    editor =
      textarea
        [ class "editor window__content"
        , E.onInput EnteredMarkdown
        ]
        [ text content ]
  in
  viewWindow
    { iconClass = "fas fa-edit"
    , title = "Editor"
    , onMaxClick = ClickedMaximizeButton Editor
    , onMinClick = ClickedMinimizeButton
    }
    editor


viewPreviewerWindow : String -> Bool -> Html Msg
viewPreviewerWindow content =
  let
    previewer =
      div [ class "previewer window__content" ]
        [ toHtml content "previewer__html" ]
  in
  viewWindow
    { iconClass = "fab fa-html5"
    , title = "Previewer"
    , onMaxClick = ClickedMaximizeButton Previewer
    , onMinClick = ClickedMinimizeButton
    }
    previewer


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
  { iconClass : String
  , title : String
  , onMaxClick : msg
  , onMinClick : msg
  }


viewWindow : Config msg -> Html msg -> Bool -> Html msg
viewWindow config content isMaximized =
  div
    [ class "window window--theme--forest"
    , A.classList [ ("window--maximized", isMaximized) ]
    ]
    [ div [ class "window__frame" ]
        [ div [ class "window__header" ]
            [ div [ class "window__icon" ] [ i [ class config.iconClass ] [] ]
            , h2 [ class "window__title" ] [ text config.title ]
            , if isMaximized then
                viewMinimizeButton config.onMinClick
              else
                viewMaximizeButton config.onMaxClick
            ]
        , div [ class "window__body" ] [ content ]
        ]
    ]


viewMaximizeButton : msg -> Html msg
viewMaximizeButton onMaxClick =
  button
    [ class "window__button", E.onClick onMaxClick ]
    [ i [ class "fas fa-expand", A.title "Click to maximize" ] [] ]


viewMinimizeButton : msg -> Html msg
viewMinimizeButton onMinClick =
  button
    [ class "window__button", E.onClick onMinClick ]
    [ i [ class "fas fa-compress", A.title "Click to minimize" ] [] ]


viewAttribution : Html msg
viewAttribution =
  p [ class "attribution" ]
    [ text "by "
    , a [ A.href "http://dwaynecrooks.com" ] [ text "Dwayne Crooks" ]
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
