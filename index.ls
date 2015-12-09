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
