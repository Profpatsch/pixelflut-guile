# Pixelflut Guile

**Pre-pre-pre-alpha!**

A Scheme library for interfacing with 
[Pixelflut](https://github.com/defnull/pixelflut).

This project is intended to be used as a form of teaching programming sometime 
in the future. It can be used as a hook for short (1–3 hour) introductions to 
constructive messing around with simple programming paradigms. So first of all, 
it should be *fun* and *simple*.

If you are searching for a very good course that spans a little more time [How 
to Design Programs](http://www.ccs.neu.edu/home/matthias/HtDP2e/) is it.

For a very in-depth classic about everything programming, 
[SICP](https://mitpress.mit.edu/sicp/full-text/book/book.html) is what you want 
to study (with).

## Concepts

You first produce objects, those are basically long lists of (x . y) pairs that 
specify the pixels that belong to this object

To paint those objects you have to transform them into a list of triples (pixel 
positions with color) and shove these into a paint function.

This makes then whole thing nicely functional and you can apply various 
transformations to the objects and the way you color them.

## Examples

    ;; Config:
    (define server-url "123.456.789.42")
    (define server-port 1234)

    ;; Init
    (pf-init)

    ;; Draw colored rectangle
    (let ((obj (rect 50 30 100 100)))
      (paint (color obj "ffaa33")))

    ;; Draw another one, but this time randomized
    (let ((obj (rect 250 250 50 50)))
      (paint:random (color obj "0055ff")))

## Functions

Objects:

    line:simple x y len dir
        x, y: position
        len: length
        dir: direction symbol (n, s, w, e, nw, ne, sw, se)

    rect x y xlen ylen
        xlen, ylen: width, height

Coloring (returns triples):

    color obj col
        obj: object
        col: color as "rrggbb"

Painting:

    paint triples
    paint:random triples
