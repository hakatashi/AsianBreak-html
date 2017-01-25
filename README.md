# AsianBreak-html

[![Greenkeeper badge](https://badges.greenkeeper.io/hakatashi/AsianBreak-html.svg)](https://greenkeeper.io/)

> Automatically strip breaklines from HTML for east asian people, based on new CSS3 spec of white-space property.

[travis-image]: https://travis-ci.org/hakatashi/AsianBreak-html.svg?branch=master
[travis-url]: https://travis-ci.org/hakatashi/AsianBreak-html
[gemnasium-image]: https://gemnasium.com/hakatashi/AsianBreak-html.svg
[gemnasium-url]: https://gemnasium.com/hakatashi/AsianBreak-html
[npm-image]: https://img.shields.io/npm/v/asianbreak-html.svg
[nodeico-image]: https://nodei.co/npm/asianbreak-html.png?downloads=true
[npm-url]: http://npmjs.com/package/asianbreak-html
[license-image]: https://img.shields.io/npm/l/asianbreak-html.svg

[![npm status][nodeico-image]][npm-url]

[![Build Status][travis-image]][travis-url]
[![Dependency Status][gemnasium-image]][gemnasium-url]
[![npm version][npm-image]][npm-url]
[![LICENSE][license-image]][npm-url]

```js
const Asianbreak = require('asianbreak-html');
const asianbreak = Asianbreak();

asianbreak.pipe(process.stdout);

asianbreak.end(`
    <blockquote>

        婆さんは先刻から暦の話をしきりに為していた。
        <em>みずのえ</em>だの<em>かのと</em>だの、
        八朔だの友引だの、爪を切る日だの普請をする日だのと
        頗る煩いものであった。

        <cite style="
            font-size: 0.8em;
        ">夏目漱石『それから』</cite>

    </blockquote>
`);
```

output:

```html
<blockquote>

    婆さんは先刻から暦の話をしきりに為していた。<em>みずのえ</em>だの<em>かのと</em>だの、八朔だの友引だの、爪を切る日だの普請をする日だのと頗る煩いものであった。<cite style="
        font-size: 0.8em;
    ">夏目漱石『それから』</cite>

</blockquote>
```

## Background

> TODO: write

## API

This module exposes single class `Asianbreak`,
which allows you to use your normal [stream Transforming API](https://nodejs.org/api/stream.html#stream_class_stream_transform).

Processed HTML is emitted when it is ready even in partial form
so it is "streaming." :smiley:

### constructor: `Asianbreak([options])`

* `options`: **unimplemented**

Create new AsianBreak transforming instance. `new` can be omitted.
