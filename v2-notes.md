# Version 2

Use RiotJS.

Usage in your page:

```html
<flip-book
  title="My Comic"
  author="Matt McCray"
  infobar="© 2015 Matt McCray, all rights reserved."
  infolink="http://www.mattmccray.com">
  <flip-screens
    path="/my/path/comic-###.jpg"
    screens="10"
    start="0"
    preload="all"
  ></flip-screens>
  <flip-screen position="first" >
    <h1>Welcome</h1>
    <p>This can be html, as you can tell, or it can be another image.
  </flip-screen>
  <flip-screen position="middle">
    <!-- Advert! Shock! -->
  </flip-screen>
  <flip-screen position="last">
    <p>Thanks for reading! Next up... The swamps of hell.. oooOOOOWOWOOoooo.</p>
  </flip-screen>
</flip-book>
```

Then, anywhere else in your page include:

```html
<script src="/path/to/flipbook.js"></script>
```
