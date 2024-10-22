---
title: Linux Kernel Names
date: 2024-10-22
comments: true
published: true
tags:
  - linux
  - fun
---

Instagram served me a Reel the other day of Linux Torvalds talking about
how every Linux kernel had a name in the Makefile. There's some pretty good ones
but I think my favorite is `Linux for Workgroups`.

```
"Divemaster Edition"
"People's Front"
💕 Valentine's Day Edition 💕
Affluent Albatross
Anniversary Edition
Arr Matey! A Hairy Bilge Rat!
Avast! A bilge rat!
Baby Opossum Posse
Blurry Fish Butt
Bobtail Squid
Charred Weasel
Crazed Snow-Weasel
Diseased Newt
Erotic Pickled Herring
Fearless Coyote
Flesh-Eating Bats with Fangs
Frozen Wasteland
Funky Weasel is Jiggy wit it
Holy Dancing Manatees,  Batman!
Homicidal Dwarf Hamster
Hurr durr I'ma ninja sloth
Jeff Thinks I Should Change This, But To What?
Killer Bat of Doom
Kleptomaniac Octopus
Linux for Workgroups
Man-Eating Seals of Antiquity
Merciless Moray
Nocturnal Monster Puppy
One Giant Leap for Frogkind
Opossums on Parade
Psychotic Stoned Sheep
Roaring Lionus
Rotary Wombat
Saber-toothed Squirrel
Sheep on Meth
Shuffling Zombie Juror
Shy Crocodile
Sliding Snow Leopard
Sneaky Weasel
Superb Owl
Temporary Tasmanian Devil
Terrified Chipmunk
Trick or Treat
Unicycling Gorilla
Wet Seal
Woozy Numbat
```

Here's my quick and dirty script to spit them out:

```bash
for tag in $(git tag)
do
	echo Checking out ${tag}...
	git checkout --quiet $tag
	name=$(grep NAME Makefile)
	echo ${tag},${name}
	git clean -f --quiet
	git reset --quiet --hard HEAD
	git clean -fd --quiet
done
```