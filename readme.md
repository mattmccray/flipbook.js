# FlipBook

Embeddable comic viewer optimized for use with FlipComics.


```html
<div 
  data-flipbook-pages="10" 
  data-flipbook-autofocus="true"
  data-flipbook-theme="dark"
  data-flipbook-path="media/comics/titlea-##.jpg" 
  data-flipbook-copyright="Created by and copyright &copy; Me!" 
  data-flipbook-title="Title A">
  <div>
    <p>Loading comic viewer...</p>
  </div>
  <noscript>
    Please enable JavaScript, or upgrade to a modern browser
    to read this comic.
  </noscript>
</div>
```

### Supported Platforms

For use with modern browsers. Tested on later versions of:

- Chrome
- Firefox
- Safari (Mac and iOS 6)
- Internet Explorer (9)


### Working Guidelines

The FlipBook Viewer is not for everybody, it's meant for showing multiple 
page/screen comics WITHOUT reloading the page.

- It should "Just Work"
- Fairly configurable
- Themeable
- Not a kitchen-sink
- Easy to use, and easy to embed in your site
- Regarding dependecies and styles, "Batteries included"
- Small-ish

**Intentionally** missing:

- Page/screen transitions -- As a comic writer/artist you need to think hard
  about how pages are 'flipped.' It effects the story telling.

  Also, the second any animation is introduced it starts to cross into that
  horrible abomination "motion comics." Motion comics aren't comics, they are
  really shitty animation. We don't want that.

  That said, I may add support for cross-dissolves and flashes on specified
  screens -- never a global option however. If we find that selective use of
  such devices are effective.

## Probable Features for Version 2

- Configurable/customizable End Screen.
- Comic meta data in the info/help screen.
- Use hash urls. (#/page/N -- allowing bookmarks or links to specific page)
- Rearrangable UI elements.
- Animate zooming in and out
- User options screen, so they can disable/enable features (saves to localStorage) 
- Allow reading images inside the div and pull those out instead of generating img tags via path/pages opts.
- Tweak the design to use divs with background-images for the screens instead of img tags?
- Add a NSFW flag that will show a warning before the first page?
