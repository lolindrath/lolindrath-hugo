---
title: How to install and use Hombrew from your home directory
date: 2011-09-13T15:08:00Z
comments: true
published: true
tags:
  - osx
  - homebrew
aliases:
  - /2011/09/13/hombrew-from-home-directory/
---

I just got a Macbook Pro at work. So far I like it a lot but I ran into the problem that I'm not an admin (and the permissions on `/usr/local/` were completely locked down) on it and I wanted to be able to install [Homebrew](https://mxcl.github.com/homebrew/) tools whenever I felt like it.

First, clone Homebrew into your home directory:

```bash
    cd $HOME
    git clone https://github.com/mxcl/homebrew.git
```

Next, add Homebrew to your path (your syntax might be different if you're not using bash):

```bash
    export PATH=${HOME}/homebrew/bin:${PATH}
```

Now test, I installed tmux, MacVim and tree (shows a nice hierarchical view of a database structure):

```bash
    brew install tree
    tree
```

