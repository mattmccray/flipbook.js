# FlipBook.js

FlipBook is an embeddable comic viewer optimized for use with Flip Comics... 
Cine Comics... Storyboard Comics... Slideshow Comics? I'm not sure what to call 
'em. Marvel calls them "Infinite Digital Comics," Mark Waid calls them "Digital
Comics." I just call them "awesome." I want everyone to be able to make them 
-- and *show* them -- who wants to.

Here's some example HTML markup:

```html
<div 
  data-flipbook-pages="25" 
  data-flipbook-theme="light-shiny"
  data-flipbook-autofocus="true"
  data-flipbook-autofit="yes"
  data-flipbook-background="black"
  data-flipbook-path="comics/chapter-1/page-##.jpg" 
  data-flipbook-copyright="&copy; Me!" 
  data-flipbook-author="by Matt McCray"
  data-flipbook-title="l33tville">
  <div>
    <p>Loading comic viewer...</p>
  </div>
  <noscript>
    Please enable JavaScript, or upgrade to 
    a modern browser to read this comic.
  </noscript>
</div>
```

There is (or will be) an included jQuery plugin, if you want a little more
programmatic approach to creating and configuring FlipBook viewers.


## Working Guidelines

The FlipBook Viewer is not for everybody, it's meant for showing multiple 
page/screen comics WITHOUT reloading the page.

- It should "Just Work"
- It needs to not only support iOS/mobile -- but *rock* on it
- Themeable
- Fairly configurable, but not a kitchen-sink
- Easy to use and easy to embed in your site
- Regarding dependencies and styles, "Batteries included"
- Small-ish

**Intentionally** missing non-features:

-   Page/screen transitions -- As a comic writer/artist you need to think hard
    about how pages are 'flipped.' It effects the story telling.
   
    Also, the moment any animation is introduced it crosses the line into that
    horrible abomination "motion comics." Motion comics aren't comics, they are
    *really shitty* animation. We don't want that.
   
    That said, I may add support for cross-dissolves and flashes for per screen
    usage -- never a global option -- if it seems like such a device would be
    used for good, not evil.


## Supported Platforms

For use with modern browsers. Tested on later versions of:

- Chrome
- Firefox
- Safari (Mac and iOS)
- Internet Explorer (9)

## Things Coming Sooner Than Version 2

- Hash urls. (#/page/N -- allowing bookmarks or links to specific page)
- Support for reading images inside the div and pulling those out instead of 
  generating img tags via the path/pages options.
- A `greedyKeys` option to always handle hotkeys even if viewer isn't focused.
- A `stretchedZoom` option to stretch the image to fit, as best as possible,
  within the zoomed screen area even if it's larger than the original image
  size.
- A `beginReadingAt` option to start on a screen other than the first.
- When screen count gets to a certain length, allow reading after a specific
  percentage of images have loaded (instead of 100%).

## Probable Features for Version 2

- Support for comics with variable sized images (different size per screen).
- Configurable/customizable end screen content.
- Comic meta data in the info/help screen (or perhaps a new screen).
- Rearrangeable UI elements.
- Animate zooming in and out.
- User options screen so they can disable/enable features. (saves via
  localStorage) 
- Tweak the design to use divs with background-images for the screens instead
  of img tags?
- Add a NSFW flag that will show a warning before the first page?

## Ideas or Things That Would Be Cool

- A sharing button/screen for Twitter/Facebook/Tumblr
- Tumblr integration -- embed a comic in a blog entry. (How would this work?
  Is this even possible? I don't know yet.)


## I Want Your Feedback

Have a cool idea? Think something isn't working how it *should*? Please let me
know! 

While FlipBook is fairly focused in its goals (comics only, not general
photo usage) -- I'd like to know how it's being used and where to guide it,
going forward.

> [matt@inkwellian.com](matt@inkwellian.com)