require! {
  \asianbreak
  \html-tokenize
  \readable-stream
  \assert
}

# Very very lazy parser for HTML token.
# It is not accutual parser, just "estimating" the property of token.
# It works well given token type is already detected.
parse-token = ([type, token]) ->
  if token |> Buffer.is-buffer
    token .= to-string!

  switch type
    | \open
      if token.match /^<!--/
        {
          type: type
          category: \comment
        }
      else if token.match /^<!DOCTYPE/i
        {
          type: type
          category: \doctype
        }
      else if token.match /^<!\[CDATA\[/i
        {
          type: type
          category: \cdata
        }
      else if token.match /^<[!?]/
        {
          type: type
          category: \unknown
        }
      else
        name-match = token.match /^<\s*([^\s>]+)/
        assert name-match isnt null

        {
          type: type
          category: \element
          name: name-match.1
        }

    | \close
      if token.match /^-->/
        {
          type: type
          category: \comment
        }
      else if token.match /^\]\]>/
        {
          type: type
          category: \cdata
        }
      else
        name-match = token.match /^<\/\s*([^\s>]+)/
        assert name-match isnt null

        {
          type: type
          category: \element
          name: name-match.1
        }

    | \text
      {
        type: type
        text: token
      }

    | otherwise
      assert false

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
    @tokens = []
    @inline-tokens = []
    # Point the next token index of the newest flushed token
    @flush-pointer = 0

    @tokenizer.on \data @_on-data.bind @

  _transform: (chunk, encoding, done) ->
    @tokenizer.write chunk, encoding, done

  _flush: (done) ->
    @tokenizer.end done

  _on-data: (chunk) ->
    token = parse-token chunk
    token-index = @tokens.push token
    token.index = --token-index
    token.processed = false

    top-token = @_top-stack!

    if token.type is \open
      # Execute auto-closing
      if top-token? and token.name in (@@auto-closing-rules[top-token.name] ? [])
        @_close-token!

      @stack.push token-index

    else if token.type is \close
      # Skip if no corresponding open tag is found in stack
      unless @stack.every((token-index) ~>
        @tokens[token-index].name isnt token.name
      )
        ...

    @push chunk[1]

  _close-token: ->
    opening-token = @_pop-stack!

    if opening-token.name not in @@block-elements
      texts = @inline-tokens.map (token) -> token.text
      processed-texts = asianbreak texts

      for token, token-index in @inline-tokens
        token.text = processed-texts[token-index]
        token.processed = true
        @_flush-tokens!

  _top-stack: -> @tokens[@stack[* - 1]]

  _pop-stack: ->
    popped-token = @_top-stack!
    @stack.pop!
    return popped-token

  # Find tokens which is already processed but not flushed,
  # and flush it to output text
  _flush-tokens: ->
    push-text = ''

    for token-index from @flush-pointer til @tokens.length
      token = @tokens[token-index]

      unless token.type isnt \text or token.processed
        break
      else
        push-text += token.text
        @flush-pointer = token.index + 1

    if push-text.length isnt 0
      @push push-text

module.exports = asianbreak-html
