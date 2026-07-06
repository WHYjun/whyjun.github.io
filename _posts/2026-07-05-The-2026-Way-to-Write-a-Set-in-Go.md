---
layout: post
lang: en
permalink: golang/The-2026-Way-to-Write-a-Set-in-Go
title: The 2026 Way to Write a Set in Go
categories:
  - Golang
tags:
  - golang
  - generics
  - data structure
sharing:
  twitter: The 2026 Way to Write a Set in Go
---

Back in 2021 I wrote a Korean post about building a `Set` in Go. I wasn't arguing that Go needed one built in, I was solving algorithm problems, Advent of Code mostly, and kept running into spots where a set was the natural tool for the job. So I built one. Go is now at 1.26.4, the standard library has picked up generics, iterators, and a `maps` package along the way, and there's still no `Set` type in sight (a [proposal for one](https://github.com/golang/go/issues/69230) has been open for years without landing). That's fine. The same trick from 2021 still solves the problem in 2026, it just looks a lot better written today.

## The Trick Hasn't Changed

A `Set` is a `map` where you only care about the keys. Go's `map` already gives you O(1) inserts, lookups, and deletes with no duplicate keys, which is exactly what a set needs. The empty `struct{}` value costs zero bytes, so you're not paying for values you'll never read.

```go
type Set[T comparable] map[T]struct{}
```

That's the whole idea. What changed since 2021 is everything around it.

## From `interface{}` to Real Generics

The 2021 version had to write `map[interface{}]struct{}`, because Go had no generics yet. Every value going in or out needed a type assertion, and the compiler couldn't stop you from mixing an `int` and a `string` in the same set.

With generics, `Set[T comparable]` gives you a type parameter instead. `comparable` is the built-in constraint for any type Go can use as a map key, so the set stays type-safe without you writing a single assertion.

```go
func NewSet[T comparable](items ...T) Set[T] {
	s := make(Set[T], len(items))
	for _, item := range items {
		s.Add(item)
	}
	return s
}

func (s Set[T]) Add(v T) {
	s[v] = struct{}{}
}

func (s Set[T]) Remove(v T) {
	delete(s, v)
}

func (s Set[T]) Contains(v T) bool {
	_, ok := s[v]
	return ok
}

func (s Set[T]) Len() int {
	return len(s)
}
```

```go
colors := NewSet("red", "green", "blue")
colors.Add("green") // already there, no-op
colors.Remove("red")

colors.Contains("green") // true
colors.Contains("red")   // false
colors.Len()              // 2
```

Try passing an `int` into `colors.Add` and the compiler rejects it before the program ever runs. That's the whole win over the `interface{}` version: the same map-of-empty-struct trick, minus the runtime type checks.

## Iterating Without the Boilerplate

The 2021 post didn't cover iteration, because looping over a `map[interface{}]struct{}` and asserting each key back to its real type wasn't worth showing. Since Go 1.23, the `maps` package exposes `maps.Keys`, which returns an `iter.Seq[T]` you can range over directly.

```go
import "maps"

for c := range maps.Keys(colors) {
	fmt.Println("color:", c)
}
```

If you don't want callers importing `maps` just to walk your set, give the type its own iterator method and return the same thing:

```go
import "iter"

func (s Set[T]) All() iter.Seq[T] {
	return maps.Keys(s)
}
```

```go
for v := range colors.All() {
	fmt.Println(v)
}
```

## Set Algebra for Free

Generics also make union and intersection easy to write once, for every element type, instead of copy-pasting a version per type:

```go
func Union[T comparable](a, b Set[T]) Set[T] {
	result := make(Set[T], len(a)+len(b))
	for v := range a {
		result.Add(v)
	}
	for v := range b {
		result.Add(v)
	}
	return result
}

func Intersect[T comparable](a, b Set[T]) Set[T] {
	result := Set[T]{}
	for v := range a {
		if b.Contains(v) {
			result.Add(v)
		}
	}
	return result
}
```

```go
a := NewSet(1, 2, 3)
b := NewSet(3, 4, 5)

Union(a, b).Len()     // 5
Intersect(a, b).Len() // 1
```

I ran every snippet above against Go 1.26.4, the latest stable release as of this writing, and checked them with `go vet` and `gofmt` before publishing.

## Conclusion

If you hit the same wall I hit in 2021, solving algorithm problems and reaching for a `Set` that isn't there, the fix is still to build one, and Go still hands you good pieces to do it with: a `map`, an empty `struct{}`, and now `comparable` generics and the `maps` package to strip out the boilerplate around them. The core idea aged fine. Everything wrapped around it got sharper. Happy coding!
