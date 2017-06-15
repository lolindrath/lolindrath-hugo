---
title: "Embarassing Old Code"
date: 2014-04-10T05:32:00-05:00
comments: true
tags:
  - programming
published: true
---

# The Inspiration #

We just switched to [Slack](https://slack.com/) at work and a friend created some [integrations](https://github.com/davidmays/slack-integration) using PHP. This reminded me of a personal PHP project I'd worked on and thought I should dig it up.

# The Setup #

Back in 2005 I was doing C# WinForms work for a day job and just dealing with falling out of love with Perl. I hadn't done any serious web development since college. I got into GTD pretty heavily and was looking around for tools that I could use anywhere. Of course a web app was the best solution for that time since there really wasn't much in the way of smart phones or devices out[^palm].

[^palm]: My Handspring Visor Platinum didn't count. Though graffiti worked pretty well.

I found a great project run by [BSAG](http://rousette.org.uk/blog/)[^contribute] called [Tracks](http://getontracks.org/). It was built using Ruby on Rails. I didn't know Ruby or Rails so of course the logical thing to do was to rewrite it in PHP.

[^contribute]: I even managed to [contribute](https://github.com/TracksApp/tracks/wiki/Contributors) back a little code (my first ever OSS contribution).

I've been using Rails off and on from 2008 to 2012 and from 2012 mostly full time. Ruby is now one of my favorite languages and I think this project helped me understand what a good web framework Rails is.

Let's see what gems we can discover in this treasure trove of old code.

# Overall #

Overall this code doesn't match my current sense of code cleanliness. There's a mix of tabs and spaces everywhere and tons of trailing whitespace. There's lots of dead code, mostly around database access. It looks like I was working on multiple different techniques at once.

```php
<?php
$query = $this->db->prepare('UPDATE todos SET context_id=:context_id, description=:description, notes=:notes, due=:due, project_id=:project_id WHERE id=:id');
$query->bindParam(':id', $id);
$query->bindParam(':context_id', $context_id);
$query->bindParam(':description', $description);
$query->bindParam(':notes', $notes);
$query->bindParam(':due', $due);
$query->bindParam(':project_id', $project_id);
?>
```

About the only thing I have going for me in this code is that I'm doing variable replacement in my SQL statements properly so it's at least not one giant SQL injection attack.

# Project Structure #

![Project Structure](/2014-04-10-embarassing-old-code/project_structure.png)

Man, I had no concept of organization in this thing.

The `tpl` files are actually just PHP files I was using as templates, I guess the idea is that they were kind of like `erb`'s. I remember thinking how clever I was to use PHP as the templating language (because that's what it was developed for) and not something like [Smarty](http://www.smarty.net/).

# My Idea of MVC #

```php
<?php while($row = $completed->fetch(PDO::FETCH_ASSOC)): ?>
  <tr>
    <td valign="top"><img src='<?=$c->BASE_URL?>/img/done-checkmark.gif' alt="done checkmark" /></td><td valign="top"><?=htmlentities($row["description"],ENT_QUOTES, 'utf-8');?> (<?=$row['context_name'];?>, <?=$row['project_name'];?>)</td>
  </tr>
<?php endwhile; ?>
```

So... there's really no division between models and views. I have one giant model that sets up the queries, the views actually execute it and use the raw results.

I remember trying to figure out why people needed models since if I wrote them it would basically just be querying the database and filling in an object with what I already had in my [associative array](http://www.php.net/manual/en/language.types.array.php).

```php
<?php
class AgingController extends MvcController
{
  public function route($options, $tpl)
  {
    global $db;
    $model = new TodoModel();

    $tpl->set('title', 'Portage - Aging');

    $body = & new Template('aging.tpl');
    $body->set('c', Config::singleton());
    $body->set('completed', $model->getLastCompleted());

    $agingQuery = $model->getSortedByCreated();

    $body->set('todos', $agingQuery);

    $tpl->set('content', $body->fetch());

    return;
  }
}
?>
```

My controllers at least load the view and combine *some* of the data and inject it into the views. I can appreciate some of the magic that Rails does by automatically matching views to controller actions after seeing how much boiler plate code is copied everywhere in here (not that I couldn't have done better with the language that I had...).

# My Crazy Router #

```php
<?php
else if($options[$c->offset] == "todo")
{
  if($options[$c->offset+1] == "edit")
  {
    $todoEdit = new TodoEditController();
    $todoEdit->route($options, $tpl);
  }
  else
  {
    if($options[$c->offset+1] == 'submit')
    {
      //set some cookies
      setcookie("last_project", $_REQUEST["project_id"], time()+$c->COOKIE_TIMEOUT, "/");
      setcookie("last_context", $_REQUEST["context_edit_id"], time()+$c->COOKIE_TIMEOUT, "/");
    }

    $todo = new TodoController();
    $todo->route($options, $tpl);
?>
```

my `IndexController.php`[^comment] contains a giant nested if statement that handles all the routing for the site. I remember one of the issues I ran into was trying to figure out where I was. If I was hosted at `http://lolindrath.com/gtd/` vs `http://gtd.lolindrath.com` I had a global offset variable to figure out where the parts of the URL I cared about started (i.e. `/todo/12`). I spent a good bit of time reading [CakePHP](http://cakephp.org/) source code trying to figure out how they did it (I obviously never got around to fixing that up).

[^comment]: Redundant comment! "Redundant comments are just places to collect lies and misinformation." - [Clean Code](http://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882/ref=sr_1_1?s=books&ie=UTF8&qid=1397121759&sr=1-1&keywords=clean+code)

# Death of a Project #

I abandoned the project sometime in 2010 then I learned Ruby on Rails and how to deploy it. I used the main Tracks project for quite a while until I setup a task syncing system using [gitdocs](https://github.com/nesquena/gitdocs). Now I've moved onto using Taskpaper and Dropbox.

# Conclusion #

* I've obviously come a long way in my development as a programmer / software engineer / software architect.
* It's nice to keep these bits of old projects around as yard sticks with which to measure growth and progress.
* I hope I see just as much growth in my coding style in another couple years.

