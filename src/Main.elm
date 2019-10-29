module Main exposing (main)


import Browser
import Html exposing (Html, a, div, footer, h1, i, p, text, textarea)
import Html.Attributes as A exposing (class)
import Html.Events as E
import Markdown


main : Program () Model Msg
main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }


-- MODEL


type alias Model =
  { content : String
  }


init : Model
init =
  { content = defaultContent
  }


-- UPDATE


type Msg
  = ChangedContent String


update : Msg -> Model -> Model
update msg model =
  case msg of
    ChangedContent newContent ->
      { model | content = newContent }


-- VIEW


view : Model -> Html Msg
view { content } =
  div []
    [ viewEditorWindow content
    , viewPreviewerWindow content
    , viewAttribution
    ]


type Icon
  = Edit
  | Expand
  | Html5


viewEditorWindow : String -> Html Msg
viewEditorWindow content =
  div [ class "container container--small" ]
      [ viewEditor content
          |> viewWindow Edit "Editor"
      ]


viewPreviewerWindow : String -> Html msg
viewPreviewerWindow content =
  div [ class "container container--medium" ]
      [ viewPreviewer content
          |> viewWindow Html5 "Previewer"
      ]


viewAttribution : Html msg
viewAttribution =
  footer []
    [ p [ class "attribution" ]
        [ text "by "
        , a [ A.href "https://www.elegantelm.dev" ] [ text "Elegant Elm" ]
        ]
    ]


viewEditor : String -> Html Msg
viewEditor content =
  div [ class "panel panel--short" ]
    [ textarea
        [ class "panel__item editor editor--default"
        , E.onInput ChangedContent
        ]
        [ text content ]
    ]


viewPreviewer : String -> Html msg
viewPreviewer content =
  div [ class "panel panel--short" ]
    [ div
        [ class "panel__item previewer previewer--default" ]
        [ toHtml content ]
    ]


viewWindow : Icon -> String -> Html msg -> Html msg
viewWindow icon title body =
  div [ class "window window--default" ]
    [ div [ class "window__frame" ]
        [ div [ class "window__header" ]
            [ div [ class "window__icon" ]
                [ viewIcon icon ]
            , h1 [ class "window__title" ]
                [ text title ]
            , div [ class "window__resizer" ]
                [ viewIconWithTitle Expand "Fullscreen" ]
            ]
        , div [ class "window__body" ] [ body ]
        ]
    ]


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

    Expand ->
      "fas fa-expand"

    Html5 ->
      "fab fa-html5"


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
