module Main exposing (main)


import Browser
import Html exposing (Html, div, h2, text, textarea)
import Html.Attributes exposing (class)
import Html.Events exposing (onInput)
import Markdown


main : Program () Model Msg
main =
  Browser.sandbox
    { init = init
    , view = view
    , update = update
    }


-- MODEL


type alias Model = String


init : Model
init = defaultContent


-- UPDATE


type Msg
  = ChangedContent String


update : Msg -> Model -> Model
update msg _ =
  case msg of
    ChangedContent newContent ->
      newContent


-- VIEW


view : Model -> Html Msg
view content =
  div []
    [ viewEditor content
    , viewPreviewer content
    ]


viewEditor : String -> Html Msg
viewEditor content =
  div []
    [ h2 [] [ text "Editor" ]
    , textarea [ class "editor", onInput ChangedContent ] [ text content ]
    ]


viewPreviewer : String -> Html msg
viewPreviewer content =
  div []
    [ h2 [] [ text "Previewer" ]
    , toHtml content
    ]


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
