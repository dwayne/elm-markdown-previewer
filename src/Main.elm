module Main exposing (main)


import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown


main : Html msg
main =
  view defaultContent


view : String -> Html msg
view content =
  div []
    [ div [ class "container container--width--small" ]
        [ viewMinimizedEditorWindow content
        ]
    , div [ class "container container--width--medium" ]
        [ viewMinimizedPreviewerWindow content
        ]
    , footer []
        [ p [ class "attribution" ]
            [ text "by "
            , a
              [ href "https://www.dwaynecrooks.com" ]
              [ text "Dwayne Crooks" ]
            ]
        ]
    ]


viewMinimizedEditorWindow : String -> Html msg
viewMinimizedEditorWindow content =
  div [ class "window window--theme--forest" ]
    [ div [ class "window__frame" ]
        [ div [ class "window__header" ]
            [ div [ class "window__icon" ]
                [ i [ class "fas fa-edit" ] []
                ]
            , h2 [ class "window__title" ] [ text "Editor" ]
            , button [ class "window__button" ]
                [ i
                  [ class "fas fa-expand"
                  , title "Click to maximize"
                  ]
                  []
                ]
            ]
        , div [ class "window__body" ]
            [ textarea [ class "editor window__content" ] [ text content ]
            ]
        ]
    ]


viewMinimizedPreviewerWindow : String -> Html msg
viewMinimizedPreviewerWindow content =
  div [ class "window window--theme--forest" ]
    [ div [ class "window__frame" ]
        [ div [ class "window__header" ]
            [ div [ class "window__icon" ]
                [ i [ class "fab fa-html5" ] []
                ]
            , h2 [ class "window__title" ] [ text "Previewer" ]
            , button [ class "window__button" ]
                [ i
                  [ class "fas fa-expand"
                  , title "Click to maximize"
                  ]
                  []
                ]
            ]
        , div [ class "window__body" ]
            [ div [ class "previewer window__content" ]
                [ toHtml content "previewer__html"
                ]
            ]
        ]
    ]


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
