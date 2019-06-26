module Main exposing (main)


import Browser
import Html exposing (Html, div, h2, i, span, text, textarea)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick, onInput)
import Markdown


main : Program () Model Msg
main =
  Browser.sandbox
    { init = init
    , view = view
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


init : Model
init =
  { content = defaultContent
  , maximized = Nothing
  }


-- UPDATE


type Msg
  = ChangedContent String
  | ClickedMaximize Window
  | ClickedMinimize


update : Msg -> Model -> Model
update msg model =
  case msg of
    ChangedContent newContent ->
      { model | content = newContent }

    ClickedMaximize window ->
      { model | maximized = Just window }

    ClickedMinimize ->
      { model | maximized = Nothing }


-- VIEW


view : Model -> Html Msg
view { content, maximized } =
  div []
    [ viewEditor content maximized
    , viewPreviewer content maximized
    ]


viewEditor : String -> Maybe Window -> Html Msg
viewEditor content maximized =
  div
    [ classList
        [ ("small-window", True)
        , ("center", True)
        , ("mb10", maximized == Nothing)
        , ("maximized", maximized == Just Editor)
        , ("hide", maximized == Just Previewer)
        ]
    ]
    [ div [ class "flex toolbar" ]
        [ i [ class "mr5 fa fa-edit" ] []
        , span [] [ text "Editor" ]
        , if maximized == Just Editor then
            viewMinimize
          else
            viewMaximize Editor
        ]
    , textarea [ class "editor", onInput ChangedContent ] [ text content ]
    ]


viewPreviewer : String -> Maybe Window -> Html Msg
viewPreviewer content maximized =
  div
    [ classList
        [ ("large-window", True)
        , ("center", True)
        , ("maximized", maximized == Just Previewer)
        , ("hide", maximized == Just Editor)
        ]
    ]
    [ div [ class "flex toolbar" ]
        [ i [ class "mr5 fa fa-html5" ] []
        , span [] [ text "Previewer" ]
        , if maximized == Just Previewer then
            viewMinimize
          else
            viewMaximize Previewer
        ]
    , div [ class "previewer" ] [ toHtml content ]
    ]


viewMaximize : Window -> Html Msg
viewMaximize window =
  i [ class "push-right resizer fa fa-arrows-alt"
    , onClick (ClickedMaximize window)
    ]
    []


viewMinimize : Html Msg
viewMinimize =
  i [ class "push-right resizer fa fa-compress"
    , onClick ClickedMinimize
    ]
    []


-- HELPERS


toHtml : String -> Html msg
toHtml =
  Markdown.toHtmlWith
    { githubFlavored = Just { tables = True, breaks = False }
    , defaultHighlighting = Just "elm"
    , sanitize = True
    , smartypants = False
    }
    []


-- DATA


defaultContent : String
defaultContent =
  """# Welcome to my Elm Markdown Previewer!

## This is a sub-heading...
### And here's some other cool stuff:

Heres some code, `<div></div>`, between 2 backticks.

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
