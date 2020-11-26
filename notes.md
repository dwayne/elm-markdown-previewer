# Notes

## Minimized editor window

```html
<div class="window window--theme--forest">
  <div class="window__frame">
    <div class="window__header">
      <div class="window__icon">
        <i class="fas fa-edit"></i>
      </div>
      <h2 class="window__title">Editor</h2>
      <button class="window__button">
        <i class="fas fa-expand" title="Click to maximize"></i>
      </button>
    </div>

    <div class="window__body">
      <textarea class="editor window__content">
        <!-- Markdown goes here. -->
      </textarea>
    </div>
  </div>
</div>
```

## Maximized editor window

To go from the minimized editor window to the maximized editor window you need to do the following:

1. Add the `window--maximized` modifier.
2. Change the button icon's class from `fa-expand` to `fa-compress`.
3. Change the button icon's title from "Click to maximize" to "Click to minimize".
4. Add the `overflow-hidden` class to the `body` tag.

```html
<div class="window window--maximized window--theme--forest">
  <div class="window__frame">
    <div class="window__header">
      <div class="window__icon">
        <i class="fas fa-edit"></i>
      </div>
      <h2 class="window__title">Editor</h2>
      <button class="window__button">
        <i class="fas fa-compress" title="Click to minimize"></i>
      </button>
    </div>

    <div class="window__body">
      <textarea class="editor window__content">
        <!-- Markdown goes here. -->
      </textarea>
    </div>
  </div>
</div>
```

## Minimized previewer window

```html
<div class="window window--theme--forest">
  <div class="window__frame">
    <div class="window__header">
      <div class="window__icon">
        <i class="fab fa-html5"></i>
      </div>
      <h2 class="window__title">Previewer</h2>
      <button class="window__button">
        <i class="fas fa-expand" title="Click to maximize"></i>
      </button>
    </div>

    <div class="window__body">
      <div class="previewer window__content">
        <div class="previewer__html">
          <!-- HTML goes here. -->
        </div>
      </div>
    </div>
  </div>
</div>
```

## Maximized previewer window

To go from the minimized previewer window to the maximized previewer window you need to do the following:

1. Add the `window--maximized` modifier.
2. Change the button icon's class from `fa-expand` to `fa-compress`.
3. Change the button icon's title from "Click to maximize" to "Click to minimize".
4. Add the `overflow-hidden` class to the `body` tag.

```html
<div class="window window--maximized window--theme--forest">
  <div class="window__frame">
    <div class="window__header">
      <div class="window__icon">
        <i class="fab fa-html5"></i>
      </div>
      <h2 class="window__title">Previewer</h2>
      <button class="window__button">
        <i class="fas fa-compress" title="Click to minimize"></i>
      </button>
    </div>

    <div class="window__body">
      <div class="previewer window__content">
        <div class="previewer__html">
          <!-- HTML goes here. -->
        </div>
      </div>
    </div>
  </div>
</div>
```
