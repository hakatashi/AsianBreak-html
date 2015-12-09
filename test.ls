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

describe 'Convertion' ->
  It 'converts breakline within Japanese inline text into nothing' (done) ->
    convert '''
      <p>
        漢字
        汉字
      </p>
    ''' ->
      expect it .to.equal '''
        <p>
          漢字汉字
        </p>
      '''
      done!

  It 'preserves whitespace inside elements to output' (done) ->
    convert '''
      <p class = "
        foo
        bar
      ">
        漢字
        汉字
      </ p>
    ''' ->
      expect it .to.equal '''
        <p class = "
          foo
          bar
        ">
          漢字汉字
        </ p>
      '''
      done!

  It 'mangles inline whitespaces between context' (done) ->
    convert '''
      <p>
        漢字<a href="/">
          リンク
        </a>汉字
      </p>
    ''' ->
      expect it .to.equal '''
        <p>
          漢字<a href="/">リンク</a>汉字
        </p>
      '''
      done!

  It 'mangles inline whitespaces between context' (done) ->
    convert '''
      <p>
        漢字
        <a href="/">リンク</a>
        汉字
      </p>
    ''' ->
      expect it .to.equal '''
        <p>
          漢字<a href="/">リンク</a>汉字
        </p>
      '''
      done!

  It 'doesnt mangle inline whitespaces spreading over multiple context' (done) ->
    convert '''
      <p>
        漢字
        <a href="/">
          リンク
        </a>
        汉字
      </p>
    ''' ->
      expect it .to.equal '''
        <p>
          漢字
          <a href="/">
            リンク
          </a>
          汉字
        </p>
      '''
      done!

  It 'correctly handles self-closing element' (done) ->
    convert '''
      <p>
        漢字
        <img src="/favicon.ico">
        汉字
      </p>
    ''' ->
      expect it .to.equal '''
        <p>
          漢字
          <img src="/favicon.ico">
          汉字
        </p>
      '''
      done!

  It 'correctly handles HTML comments' (done) ->
    convert '''
      <p>
        漢字
        <!--
          漢字
          汉字
        -->
        汉字
      </p>
    ''' ->
      expect it .to.equal '''
        <p>
          漢字
          <!--
            漢字
            汉字
          -->
          汉字
        </p>
      '''

  It 'breaks inline context when block-level element appeared' (done) ->
    convert '''
      <div>
        漢字
        <h1>見出し</h1>
        汉字
      </div>
    ''' ->
      expect it .to.equal '''
        <div>
          漢字
          <h1>見出し</h1>
          汉字
        </div>
      '''
      done!

  It 'correctly converts block-level element inside block-level element' (done) ->
    convert '''
      <div>
        漢字
        <h1>
          見出し
          テキスト
        </h1>
        汉字
      </div>
    ''' ->
      expect it .to.equal '''
        <div>
          漢字
          <h1>
            見出しテキスト
          </h1>
          汉字
        </div>
      '''
      done!

  It 'preserves newlines inside <pre> tag' (done) ->
    convert '''
      <div>
        漢字
        <pre>
          漢字
          汉字
        </pre>
        汉字
      </div>
    ''' ->
      expect it .to.equal '''
        <div>
          漢字
          <pre>
            漢字
            汉字
          </pre>
          汉字
        </div>
      '''
      done!

  It 'preserves newlines inside inline element inside <pre> tag' (done) ->
    convert '''
      <div>
        漢字
        <pre>
          <h1>
            漢字
            汉字
          </h1>
        </pre>
        汉字
      </div>
    ''' ->
      expect it .to.equal '''
        <div>
          漢字
          <pre>
            <h1>
              漢字
              汉字
            </h1>
          </pre>
          汉字
        </div>
      '''
      done!

  It 'ignores but pipes invalid closing element to output' (done) ->
    convert '''
      <p>
        漢字
        </span>
        汉字
      </p>
    ''' ->
      expect it .to.equal '''
        <p>
          漢字</span>汉字
        </p>
      '''
      done!

  It 'ignores but pipes unknown element to output' (done) ->
    convert '''
      <p>
        漢字
        <david>デビッド</david>
        汉字
      </p>
    ''' ->
      expect it .to.equal '''
        <p>
          漢字<david>デビッド</david>汉字
        </p>
      '''
      done!
