require! {
  \chai
  \concat-stream
  './': Asianbreak
}

# `it` is reserved by LiveScript
It = global.it

expect = chai.expect

# Shorthand method
convert = (text, done) ->
  asianbreak = Asianbreak!
  asianbreak.pipe concat-stream {encoding: \string} done
  asianbreak.end text

describe 'Basic Usage' ->
  It 'accepts string input and emit it as buffer' (done) ->
    asianbreak = Asianbreak!
    asianbreak.on \data -> expect it .to.be.instanceof Buffer
    asianbreak.on \finish -> done!
    asianbreak.end 'foobar'

  It 'accepts buffer input and emit it as buffer' (done) ->
    asianbreak = Asianbreak!
    asianbreak.on \data -> expect it .to.be.instanceof Buffer
    asianbreak.on \finish -> done!
    asianbreak.end Buffer 'foobar'

  It 'parrots input with some simple cases' (done) ->
    convert '<p></p>' ->
      expect it .to.equal '<p></p>'
      done!
