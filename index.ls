require! {
  \asianbreak
  \html-tokenize
  \readable-stream
}

class asianbreak-html extends readable-stream.Transform
  ~>
    super!

    @tokenizer = html-tokenize()
    @stack = []

  _transform: (chunk, encoding, done) ->

  _flush: (done) ->

module.exports = asianbreak-html
