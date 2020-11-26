module Main exposing (main)


import Html exposing (..)
import Html.Attributes exposing (..)


main : Html msg
main =
  div []
    [ div [ class "container container--width--small" ]
        [ viewMinimizedEditorWindow
        ]
    , div [ class "container container--width--medium" ]
        [ viewMinimizedPreviewerWindow
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


viewMinimizedEditorWindow : Html msg
viewMinimizedEditorWindow =
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
            [ textarea [ class "editor window__content" ] []
            ]
        ]
    ]


viewMinimizedPreviewerWindow : Html msg
viewMinimizedPreviewerWindow =
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
                [ div [ class "previewer__html" ]
                    []
                ]
            ]
        ]
    ]
