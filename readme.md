# FlipBook.js

FlipBook is an embeddable comic viewer optimized for use with Flip Comics... 
Cine Comics... Storyboard Comics... Slideshow Comics? I'm not sure what to call 
'em. Marvel calls them "Infinite Digital Comics," Mark Waid calls them "Digital
Comics." I just call them "awesome." I want everyone to be able to make them 
-- and *show* them.

You can see an example of the Flipbook viewer here:

> URL SOON

The FlipBook viewer is not for everybody, it's meant for showing multiple 
page/screen comics WITHOUT reloading the page. Here are/were my goals for version 1:

- It should "Just Work"
- It needs to not only support iOS/mobile -- but *rock* on it
- Themeable (currently has: light, light-shiny, gray, dark, and minimal)
- Fairly configurable, but won't include the kitchen sink
- Easy to use and easy to embed in your site
- Regarding dependencies and styles, "Batteries included"
- Small-ish (currently ~15k min+gzip - css and themes included)

**Intentionally** missing non-features:

-   Page/screen transitions -- As a comic writer/artist you need to think hard
    about how pages are 'flipped.' It effects the story telling.
   
    Also, the moment any animation is introduced it crosses the line into that
    horrible abomination "motion comics." Motion comics aren't comics, they are
    *really shitty* animation. We don't want that.
   
    That said, I may add support for cross-dissolves and flashes for per screen
    usage -- never a global option -- if it seems like such a device would be
    used for good, not evil.

## Usage

You'll need to include it on your page, of course:

```html
<script src="flipbook.js"></script>
```

You can create a FlipBook viewer using HTML:

```html
<div 
  data-flipbook-title="My Comic"
  data-flipbook-path="comics/chapter-1/page-##.jpg" 
  data-flipbook-pages="25">
  <div>
    <p>Loading comic viewer...</p>
  </div>
  <noscript>
    Please enable JavaScript, or upgrade to 
    a modern browser to read this comic.
  </noscript>
</div>
```

Or, for a more programmatic approach, you can use the jQuery plugin:

```javascript
$("#my_container").flipbook({
  title: "My Comic",
  pages: 10,
  path: 'images/comic/##.jpg'
})
```

If you're adding HTML after the DOM Ready event and want FlipBook to
rescan the DOM for HTML based controls, you can use:

```javascript
// jQuery
$.flipbook('scan');

// Or directly
flipbook('scanner').run();
```

There are two ways to tell the Flipbook viewer what images to load for your comic.
The first way, shown above, has the control generate all the images based on the
`page` count and `path` options you define. For example, this call:

```javascript
$('.comic').flipbook({
  pages: 5,
  path: "/images/comic-#.jpg"
})
```

Will try and load five images: `/images/comic-1.jpg` `/images/comic-2.jpg`
`/images/comic-3.jpg` `/images/comic-4.jpg` `/images/comic-5.jpg`

If your images have leading zeros, just add the appropriate number of #'s, like this:

```javascript
$('.comic').flipbook({
  pages: 5,
  path: "/images/comic-###.jpg"
})
```

Will try and load five images: `/images/comic-001.jpg` `/images/comic-002.jpg`
`/images/comic-003.jpg` `/images/comic-004.jpg` `/images/comic-005.jpg`

The other way is to manually put the `<img src=""/>` tags yourself within the
flipbook container tag, like this:

```html
<div data-flipbook-title="My Comic">
  <img src="comic/page-1.jpg"/>
  <img src="comic/page-2.jpg"/>
  <img src="comic/page-3.jpg"/>
  <img src="comic/page-4.jpg"/>
  <img src="comic/page-5.jpg"/>
  <img src="comic/page-6.jpg"/>
  <img src="comic/page-7.jpg"/>
  <img src="comic/page-8.jpg"/>
</div>
```

### Experimental HTML

You can also use the (currently considered experimental) `flipbook` tag:

```html
<flipbook title="My Comic" author="Me">
  <img src="comics/1.jpg"/>
  <img src="comics/2.jpg"/>
  <img src="comics/3.jpg"/>
</flipbook>
```

This won't pass an HTML validator -- but that doesn't really matter because it
works fine in modern browsers.

*Note:* This hasn't been heavily test in IE, yet, but this will work in Chrome 
and Firefox.


### Technical questions

**What do I need to include on my page?**

Just `flipbook.js`. It will automatically add the CSS and any other dependencies
it needs if they aren't already present.

**What are its dependencies?**

For desktop browser usage, it only requires jQuery. For mobile browsers, it will
also include Hammer.js for gesture support.

**Does it work with Wordpress/tumblr/other?**

It's just JavaScript and CSS, so yes it will work with whatever CMS you use. If,
however, you're asking if there is a plugin available for those platforms, then
the answer is no. Not yet, anyway. 

### Configuration

Here are all the available options that Flipbook currently supports and their
default values:

```javascript
$('#container').flipbook({
  animated: true, // Whether the UI is animated
  author: "", // Shown in the title bar after the title (in gray, for most themes)
  autofit: true, // Whether to resize the width of the unzoomed control to the width of the comic
  autofocus: false, // Whether to focus the control immediately
  background: "", // The background color to use for the comic area of the control
  copyright: "", // Text to show in the copyright bar under the comic
  greedyKeys: false, // Capture keyboard events even when the control isn't focused
  loadingErrorMsg: "There was a problem loading the images, please refresh your browser." // Message to display if any of the images throw an error while loading
  pages: 10, // Number of pages (or screens) in this comic (used with path option, below)
  path: "path/to/comic/images-##.jpg", // Path to images to generate img tags for (if page option is set above)
  showHelpButton: true, // Toggle help button in title bar
  showLocation: true, // Toggle location display (the X / Y label)
  showProgress: true, // Toggle the progress bar
  showZoomButton: true, // Toggle zoom button in title bar
  start: 1, // Number to start with, if your files don't start with 1
  title: "&nbsp;", // Title of the comic
  zoomDisabled: false, // Entirely disable support (and button) for zooming
})
```

## Supported platforms

For use with modern browsers. Tested on later versions of:

- Chrome
- Firefox
- Safari (Mac and iOS)
- Internet Explorer (9)

## Probable upcoming features

- Hash urls. (#/page/N -- allowing bookmarks or links to specific page)
- A `stretchedZoom` option to stretch the image to fit, as best as possible,
  within the zoomed screen area even if it's larger than the original image
  size. (Currently it will shrink the image to fit, but won't stretch it.)
- A `beginReadingAt` option to start on a screen other than the first.
- Allow reading after a specific percentage of images have loaded, instead of
  100%. Good for really large comics.
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

*Note:* There's not a timetable for any of these features yet.

## Things that would be cool

- A sharing button/screen for Twitter/Facebook/Tumblr
- Tumblr integration -- embed a comic in a blog entry. (How would this work?
  Is this even possible? I don't know yet.)

## I want your feedback

Have a cool idea? Think something isn't working how it *should*? Please let me
know! 

While FlipBook is fairly focused in its goals (comics only, not general
photo usage) -- I'd like to know how it's being used and where to guide it,
going forward.

> [matt@inkwellian.com](matt@inkwellian.com)
