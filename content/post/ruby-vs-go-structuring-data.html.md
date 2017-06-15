---
title: Ruby vs Go - Structuring Data
aliases:
  - /2016/06/02/ruby-vs-go-structuring-data/
date: 2016-06-02T15:08:00Z
tags:
  - golang
  - ruby
  - taskpaper
comments: true
published: true
---

I'm trying to write a [Taskpaper](http://taskpaper3.com) parser in Go.

A very basic Taskpaper file looks like this:

```
Home:
- Mow the lawn
Don't hit the flowers

Work:
- Fix all the bugs
Seriously, all the bugs
```

Projects end with a `:` and tasks begin with a `-` and any line that doesn't have that is a note. Projects have tasks and notes and tasks can have notes.

I got totally stuck yesterday on how to structure this data in Go.

If this was Ruby I would do it like this:

```ruby
class Item
  attr_accessor :parent
  attr_accessor :notes
end

class Project < Item
  attr_accessor :tasks

  def initialize(desc)
    super(desc)
  end
end


class Task < Item
  def initialize(desc)
    super(desc)
  end
end


class Note < Item
  def initialize(desc)
    super(desc)
  end
end
```

An `Item` holds generic fields and then there's a `Project`, `Task` and `Note` classes. 

In Go there's no way to say that a `Note` struct has just a generic `Parent` i.e. `Parent *Item`. To work around this I had to create a `ProjectNote` and also a `TaskNote`:

```go
type Item struct {
  Desc string
}

type Project struct {
  Item
  Tasks []Task
  Notes []ProjectNote
  Tags  []ProjectTag
}

type Task struct {
  Item
  Notes  []TaskNote
  Tags   []TaskTag
  Parent *Project
}

type ProjectNote struct {
  Item
  Parent *Project
}

type TaskNote struct {
  Item
  Parent *Task
}

```

It feels a bit wrong to break these out like this but that's probably because I've been stuck in the OO world of Ruby and Java for too long.
