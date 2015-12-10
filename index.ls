require! {
  \asianbreak
  \html-tokenize
  \readable-stream
}

class asianbreak-html extends readable-stream.Transform
  # See browser's default stylesheets
  # http://trac.webkit.org/browser/trunk/Source/WebCore/css/html.css
  # http://hg.mozilla.org/mozilla-central/file/tip/layout/style/html.css
  @pre-elements = <[pre xmp plaintext textarea listing]>

  # http://www.w3.org/TR/html-markup/syntax.html#void-element
  # http://www.w3.org/TR/html5/syntax.html#void-elements
  # http://www.w3.org/TR/xhtml-media-types/#C_2
  @void-elements = <[
    area base basefont br col command embed hr img input
    isindex keygen link meta param source track wbr
  ]>

  # Every element is inline by default.
  # Firefox default style sheet defines `block` section to override this.
  # http://hg.mozilla.org/mozilla-central/file/tip/layout/style/html.css#l99
  @block-elements = <[
    address article aside blockquote body button caption
    center col colgroup dd details dic dir div dl dt
    fieldset figcaption figure footer foreignobject form
    frame frameset h1 h2 h3 h4 h5 h6 header hgroup hr
    html input isindex keygen layer legend li listing
    main marquee menu multicol nav ol optgroup option p
    plaintext pre progress rt section select summary
    table tbody td text textarea tfoot th thead tr ul
    videocontrols xmp xul
  ]>

  # Elements supposed to have display:none; style or
  # to be rendered aside inline context, such as <rt>.
  @hidden-elements = <[
    area base basefont datalist head link meta noembed
    noframes param rp rt script style template title
  ]>

  # http://www.w3.org/TR/html5/syntax.html#optional-tags
  # This module doesn't exactly implements omitment of start tag
  # because of the consideration to even accept partial snnipet of HTML.
  @auto-closing-rules =
    li: <[li]>
    dt: <[dt dd]>
    dd: <[dt dd]>
    p: <[
      address article aside blockquote div dl fieldset
      footer form h1 h2 h3 h4 h5 h6 header hgroup hr
      main nav ol p pre section table ul
    ]>
    rb: <[rb rt rtc rp]>
    rt: <[rb rt rtc rp]>
    rtc: <[rb rtc rp]>
    rp: <[rb rt rtc rp]>
    optgroup: <[optgroup]>
    option: <[option optgroup]>
    thead: <[tbody tfoot]>
    tbody: <[tbody tfoot]>
    tfoot: <[tbody]>
    tr: <[tr]>
    td: <[td th]>
    th: <[td th]>

  ~>
    super!

    @tokenizer = html-tokenize()
    @stack = []

  _transform: (chunk, encoding, done) ->
    @push chunk
    done()

  _flush: (done) ->
    done()

module.exports = asianbreak-html
