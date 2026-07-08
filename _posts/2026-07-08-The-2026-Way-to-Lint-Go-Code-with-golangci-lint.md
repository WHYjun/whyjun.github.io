---
layout: post
lang: en
permalink: golang/The-2026-Way-to-Lint-Go-Code-with-golangci-lint
title: The 2026 Way to Lint Go Code with golangci-lint
categories:
  - Golang
tags:
  - golang
  - tooling
  - lint
sharing:
  twitter: The 2026 Way to Lint Go Code with golangci-lint
---

Back in 2023 I wrote a Korean post about adopting `golangci-lint` on my team. We'd grown enough that reviewers were spending more time explaining idiomatic Go in PR comments than reviewing the actual logic, and we needed something automated to take that job off our plates. `golangci-lint` was the fix: instead of running `govet`, `gofmt`, and a dozen other tools one at a time, it runs all of them in parallel and caches the results. Three years later that's still exactly why I reach for it. What's changed is everything around it, most of all the config file, which went through a major version bump in 2025.

## Why golangci-lint, Still

The pitch hasn't moved. Go's ecosystem has plenty of good standalone linters, but running each one separately is slow and means juggling a dozen install commands and flag sets. `golangci-lint` wraps them behind one binary, runs them concurrently, and caches analysis results between runs so repeat lints are fast. That's still the whole value proposition, and it's still worth it the moment more than one person touches a repo.

## Installing It

I installed `golangci-lint` fresh today to write this post, and the install story has tightened up. The docs now actively discourage `go install`, calling it "not guaranteed to work" for this project, and point everyone at the binary installer instead. On Windows, that means Git Bash:

```bash
curl -sSfL https://golangci-lint.run/install.sh | sh -s -- -b $(go env GOPATH)/bin v2.12.2

golangci-lint --version
```

```
golangci-lint has version 2.12.2 built with go1.26.2 from c0d3ddc9 on 2026-05-06T11:07:58Z
```

That's the current version as of this post. Pin a version in the install command instead of trusting `latest`, the same way you'd pin any other build tool.

## The Config File Got a Major Version Bump

This is the part of the 2023 post that's fully out of date. `golangci-lint` v2.0.0 shipped in March 2025 with a rewritten config schema, and every `.golangci.yml` I'd written before that no longer loads as-is. The two changes that matter:

- The file needs a top-level `version: "2"`.
- Linters and formatters are now separate sections. Tools like `gofmt`, `gofumpt`, `goimports`, and `gci` used to live under `linters`; they moved to their own `formatters` block, because formatting code and flagging bugs in it are different jobs.

Here's a minimal config in the new shape, which I ran against a real Go file to confirm it loads and works:

```yaml
version: "2"
linters:
  default: standard
  enable:
    - errorlint
formatters:
  enable:
    - gofmt
    - goimports
```

If you've still got a v1 config lying around, don't hand-migrate it. `golangci-lint migrate` does it for you:

```bash
golangci-lint migrate -c .golangci.yml
```

I fed it an old-style config with an `errorlint` and `gofmt` entry under `linters`, and it rewrote the file in place: added `version: "2"`, moved `gofmt` into `formatters`, and warned me that `run.timeout` no longer applies because v2 disables the timeout by default. It even flagged that comments in the original file don't survive the migration, so it's worth a manual diff afterward rather than trusting it blindly.

## Running It

`golangci-lint run` still works exactly like before, and the linters it finds are still worth having. I wrote a small function with the exact bug my 2023 post talked about, wrapping an error with `%s` instead of `%w`:

```go
func readConfig(path string) error {
	_, err := os.ReadFile(path)
	if err != nil {
		return fmt.Errorf("reading config: %s", err)
	}
	return nil
}
```

```bash
golangci-lint run ./...
```

```
main.go:11:43: non-wrapping format verb for fmt.Errorf. Use `%w` to format errors (errorlint)
		return fmt.Errorf("reading config: %s", err)
		                                        ^
1 issues:
* errorlint: 1
```

Same catch as three years ago: `%s` loses the wrapped error, so `errors.Is` and `errors.As` can't see through it later, which matters more the bigger the codebase gets.

One flag did change. The old `--fast` flag is gone; running it now just fails with an unknown-flag error. Its replacement is `--fast-only`, which filters the enabled set down to linters tagged fast:

```bash
golangci-lint run --fast-only ./...
```

On my test file that came back with 0 issues, because `errorlint` isn't tagged as a fast linter and got filtered out, exactly the trade-off you're opting into when you reach for `--fast-only` for a quick pre-commit check instead of the full run.

## Visual Studio Code

The `go.lintTool` and `go.lintFlags` settings I wrote about in 2023 are still there in the Go extension, but `go.lintTool` now has an extra option. `golangci-lint` means v1, and there's a separate `golangci-lint-v2` value for the current major version:

```json
"go.lintTool": "golangci-lint-v2",
"go.lintFlags": ["--fast-only"]
```

If you're still on the plain `golangci-lint` setting and a v2-only config, the extension will be reading a config it doesn't understand, so check which value you have set before you assume it's working.

## Conclusion

The reason to use `golangci-lint` hasn't changed since 2023: one tool, run in parallel, caching results, instead of a dozen linters bolted together by hand. What changed is the config file underneath it, and it changed enough that a three-year-old `.golangci.yml` won't load until you either rewrite it by hand or let `golangci-lint migrate` do it. Run that once, fix your CI flags if you were relying on `--fast`, and the rest of the setup carries over untouched. Happy coding!
