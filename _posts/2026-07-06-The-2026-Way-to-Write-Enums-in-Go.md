---
layout: post
lang: en
permalink: golang/The-2026-Way-to-Write-Enums-in-Go
title: The 2026 Way to Write Enums in Go
categories:
  - Golang
tags:
  - golang
  - enums
sharing:
  twitter: The 2026 Way to Write Enums in Go
---

Back in 2022 I wrote a Korean post about faking enums in Go with a typed constant block and `iota`. Go still has no `enum` keyword in 1.26.4, and a couple of language proposals asking for one ([issue #19814](https://github.com/golang/go/issues/19814), [issue #64739](https://github.com/golang/go/issues/64739)) have been open for years without landing. So the trick from 2022 is still exactly how you write an enum in Go today. What's worth a second post is the bug hiding in that trick, because this time I actually ran it instead of just describing it.

## The Trick Hasn't Changed

Go has no `enum` type, so you fake one with a named integer type and a `const` block that uses `iota` to number the values:

```go
type Status int

const (
	StatusOK Status = iota
	StatusError
	StatusPending
)
```

`iota` starts at 0 and increments by one per line, so `StatusOK` is `0`, `StatusError` is `1`, and `StatusPending` is `2`. It reads cleanly and the compiler stops you from mixing a `Status` with a plain `int` by accident.

## Where It Bites You

`iota` always starts at 0, and 0 is also Go's zero value for `int`. If you never explicitly set a `Status` field, decoding a struct from JSON, reading an unset field from a database row, or just declaring `var s Status` all hand you `0` for free. That's fine as long as `0` doesn't mean something you'd act on.

In the example above, it does. Here's a `Request` struct with a `Status` field, and a JSON payload from a queue where whoever built it forgot to set the status:

```go
type Request struct {
	ID        int    `json:"ID"`
	Timestamp int    `json:"Timestamp"`
	Message   string `json:"Message"`
	Status    Status `json:"Status"`
}
```

```json
{
  "ID": 1,
  "Timestamp": 1738000000,
  "Message": "Example message"
}
```

I unmarshaled that payload against the `Request` struct and printed what came out:

```go
var req Request
json.Unmarshal(payload, &req)
fmt.Println(req.Status) // 0
```

`req.Status` decodes as `0`, which is `StatusOK`. A request that never had its status set now looks like a request that succeeded. Nothing errors, nothing panics, the bug just quietly ships. I ran this end to end rather than assuming it, and the zero-value collision is exactly as silent as it sounds: `go vet` has nothing to say about it, because `0` is a perfectly valid `Status`.

## The Fix

Reserve `0` for a case that means "nothing was set," and start your real values at 1:

```go
type Status int

const (
	StatusUnknown Status = iota
	StatusOK
	StatusError
	StatusPending
)
```

Now the same missing-field payload decodes to `StatusUnknown` instead of `StatusOK`. A forgotten field turns into a visible, checkable state instead of a false positive for success. I reran the exact same unmarshal against this version and got `StatusUnknown` back, not `StatusOK`.

This costs you nothing. You still get sequential values, you still get type safety, and now the zero value tells you "this was never set" instead of lying to you.

## Catching It Automatically

If you'd rather not rely on remembering this every time you define an enum, the [`exhaustive`](https://github.com/nishanths/exhaustive) linter (bundled with `golangci-lint`) flags `switch` statements over an enum type that don't cover every constant. It won't catch the zero-value trap directly, but it does force you to handle every `Status` value explicitly wherever you branch on one, which tends to surface an unhandled `StatusUnknown` case as soon as you add it.

## Conclusion

The core trick for an enum in Go hasn't moved since 2022: a named integer type plus a `const`/`iota` block. What's worth remembering is that `iota` starts at 0, and 0 is also your zero value, so your first enum constant is what every unset, forgotten, or zeroed-out `Status` silently becomes. Give that slot to an explicit `Unknown` case and the zero value stops lying to you. Happy coding!
