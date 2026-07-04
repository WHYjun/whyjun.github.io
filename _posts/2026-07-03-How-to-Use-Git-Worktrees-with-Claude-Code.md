---
layout: post
lang: en
permalink: blog/How-to-Use-Git-Worktrees-with-Claude-Code
title: How to Use Git Worktrees with Claude Code
categories:
  - development
tags:
  - claude-code
  - git
sharing:
  twitter: How to Use Git Worktrees with Claude Code
---

When Claude Code runs a long task, it edits files in your working directory. If you want to keep working while it does, you end up fighting over the same files. Git worktrees solve this. They let one repository check out several branches into separate folders at once, so Claude can work in one folder while you stay in another.

## What Is a Git Worktree

A worktree is an extra working directory attached to your existing repository. Each worktree sits on its own branch and has its own files on disk, but they all share one `.git` history. You are not cloning the repo again, so you do not pay for a second copy of the object database.

For Claude Code this means isolation. Point Claude at a worktree on a feature branch, and its edits, builds, and test runs stay out of your main checkout.

## Creating a Worktree

Use `git worktree add`. Pass a path for the new folder and the branch to check out.

```bash
git worktree add ../myproject-feature feature-branch
```

This creates `myproject-feature` next to your repo, checked out to `feature-branch`. If the branch does not exist yet, create it in the same command with `-b`.

```bash
git worktree add -b new-feature ../myproject-feature
```

You now have two folders. Your original one stays where it was. The new one is on `new-feature`.

## Running Claude Code in the Worktree

Open a terminal in the worktree folder and start Claude there.

```bash
cd ../myproject-feature
claude
```

Claude now reads and writes files inside `myproject-feature` only. You can go back to your main folder and keep editing, run the app, or start a second Claude session on a different branch. The two sessions never touch the same files.

Claude Code can also manage this for you. When you ask a subagent to work in isolation, it can create a temporary worktree, do its work there, and clean it up when the branch has no changes left.

## Listing and Removing Worktrees

Check what you have with `git worktree list`.

```bash
git worktree list
```

When you are done with a worktree, remove it. This deletes the folder and unregisters it from the repo.

```bash
git worktree remove ../myproject-feature
```

If you deleted the folder by hand, run `git worktree prune` to clear the stale entry.

## When Worktrees Help

* Reviewing Claude's changes on a branch while you keep working on another.
* Running two Claude sessions in parallel on separate features.
* Testing a build without stashing or committing half-finished work.

## When They Get in the Way

* Small changes where a single branch switch would do.
* Tooling that hardcodes an absolute path and breaks in a second folder.
* Node or build caches that you now have to install once per worktree.

## Conclusion

Git worktrees give Claude Code a folder of its own without a second clone. Create one with `git worktree add`, run Claude inside it, and remove it with `git worktree remove` when the branch is merged. If you often want Claude to work while you keep going, keep a spare worktree around and hand it the branch. Happy coding!
