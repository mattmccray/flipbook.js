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

## Probable Features for Version 2

- Configurable/customizable End Screen.
- Comic meta data in the info/help screen.
- Use hash urls. (#/page/N -- allowing bookmarks or links to specific page)
- Rearrangable UI elements.
- Animate zooming in and out
- User options screen, so they can disable/enable features (saves to localStorage)