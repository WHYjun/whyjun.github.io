---
layout: post
lang: en
permalink: golang/The-2026-Way-to-Skip-Empty-Fields-in-Go-JSON
title: The 2026 Way to Skip Empty Fields in Go JSON
categories:
  - Golang
tags:
  - golang
  - json
sharing:
  twitter: The 2026 Way to Skip Empty Fields in Go JSON
---

Back in 2023 I wrote a Korean post about the `omitempty` struct tag, which drops a field from marshaled JSON when its value is the zero value for its type. That's still true and still the tag you reach for first. What's new since then is `omitzero`, added in Go 1.24, and it exists because `omitempty` has a blind spot that no amount of clever tagging can fix.

## omitempty, Still the Baseline

Add `,omitempty` after a field's JSON name and the encoder drops that field whenever the value is zero: an empty string, a `0`, a `nil` pointer, a `nil` or empty slice or map.

```go
type Person struct {
	Name      string `json:"name,omitempty"`
	Age       int    `json:"age,omitempty"`
	Address   string `json:"address,omitempty"`
	Telephone string `json:"telephone,omitempty"`
}
```

```go
p := Person{
	Name:      "John",
	Age:       0,
	Address:   "",
	Telephone: "123-456-7890",
}
json.Marshal(p)
// {"name":"John","telephone":"123-456-7890"}
```

`Age` and `Address` disappear, `Name` and `Telephone` survive. This is exactly the 2023 example and it still works exactly like this in Go 1.26.4.

## Where omitempty Gives Up

`omitempty` only recognizes a fixed list of zero values, and a struct isn't on it. No matter what its fields hold, a struct is never "empty" as far as `omitempty` is concerned. `time.Time` is a struct, so a zero `time.Time` sails straight through:

```go
type Event struct {
	Name      string    `json:"name,omitempty"`
	StartedAt time.Time `json:"startedAt,omitempty"`
}
```

```go
e := Event{Name: "standup"}
json.Marshal(e)
// {"name":"standup","startedAt":"0001-01-01T00:00:00Z"}
```

I ran this myself rather than trust memory, and there it is: `StartedAt` was never set, and the payload still ships January 1, year 1, as if that were a real timestamp.

## omitzero Fixes the Struct Case

Go 1.24 added `omitzero`, a tag that checks the literal zero value of a field's type, or calls the field's `IsZero() bool` method if it has one. `time.Time` has one. Swap the tag and the field disappears:

```go
type EventZero struct {
	Name      string    `json:"name,omitempty"`
	StartedAt time.Time `json:"startedAt,omitzero"`
}
```

```go
ez := EventZero{Name: "standup"}
json.Marshal(ez)
// {"name":"standup"}
```

Same struct, same unset field, and this time it's actually gone. That's the whole reason `omitzero` exists: any type with a real `IsZero()` method, not just `time.Time`, now gets a tag that can see through it.

## Don't Assume It Replaces omitempty Everywhere

Here's the part that caught me off guard. `omitempty` drops a slice whenever its length is zero, whether the slice is `nil` or an empty-but-allocated `[]int{}`. `omitzero` does not treat those the same. It only drops a `nil` slice. An empty, non-nil slice stays in the output.

```go
type Batch struct {
	Name  string `json:"name,omitzero"`
	Items []int  `json:"items,omitzero"`
}
```

```go
json.Marshal(Batch{Name: "nil-slice"})
// {"name":"nil-slice"}

json.Marshal(Batch{Name: "empty-slice", Items: []int{}})
// {"name":"empty-slice","items":[]}
```

I checked the same case with `omitempty` on an identical struct, and it drops both:

```go
json.Marshal(BatchEmpty{Name: "empty-slice", Items: []int{}})
// {"name":"empty-slice"}
```

This isn't a bug in my code, it's the documented behavior, and there's an [open issue](https://github.com/golang/go/issues/75036) tracking how often it trips people up. If you swap `omitempty` for `omitzero` on a slice field expecting identical output, an empty-but-initialized slice is where the two tags quietly part ways.

## What to Use Where

Keep `omitempty` for strings, numbers, maps, and slices, where "empty means empty" already matches what you want. Reach for `omitzero` on struct-valued fields like `time.Time`, or your own types with an `IsZero() bool` method, where `omitempty` simply can't help. Don't reach for `omitzero` on a slice just because it sounds like the newer, better tag; check whether your slices are ever the non-nil-but-empty kind first.

One more thing worth knowing: Go 1.26 also ships an experimental `encoding/json/v2` package behind `GOEXPERIMENT=jsonv2`, a separate effort from `omitzero` and not the default yet. Go 1.27 is expected to flip that default, but that's a different post.

## Conclusion

`omitempty` from 2023 hasn't changed and is still the right first move. `omitzero`, new in Go 1.24, covers the case `omitempty` was never built for: struct fields with a real notion of "zero" that isn't nil or an empty literal. Just don't assume the two tags agree on everything, because on slices they don't, and I'd rather you find that out here than in production. Happy coding!
