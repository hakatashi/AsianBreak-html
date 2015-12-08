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
    @push chunk
    done()

  _flush: (done) ->
    done()

module.exports = asianbreak-html
