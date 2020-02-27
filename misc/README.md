Miscellaneous scripts
=====================

fortune-by-random-char
----------------------

Requirements:

* lolcat
* fortune
* cowsay

Displays an ascii character telling you a random fortune. Optional input
is the cow file path that you want to tell you the fortune.

Example: running with special cow file [unsubsquirrel](https://raw.githubusercontent.com/dhiller/rank-amateur-cowsay/master/cows/unsubsquirrel.cow)
(otherwise it will select a random default cowsay character).

```bash
fortune-by-random-char ~/cows/unsubsquirrel.cow
```

![unsubsquirrel telling a fortune](fortune-by-unsubsquirrel.png)

Install requirements on Fedora linux 

```bash
sudo dnf install -y lolcat cowsay fortune-mod
```
