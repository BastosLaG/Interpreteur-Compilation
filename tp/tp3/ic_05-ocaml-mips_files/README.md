# Compte à rebours

L'implémentation du programme vu en cours est dans le fichier `countdown.c`.

Il contient en fait deux implémentation, une récursive, et une avec une boucle.

Pour le compiler puis l'exécuter :

    $ gcc countdown.c -o countdown
    $ ./countdown

## En assembleur MIPS

Le fichier `countdown.s` contient une traduction du fichier `countdown.c` en assembleur écrit *à la main*.

Pour l'exécuter avec Spim :

    $ spim -file countdown.s

## Assembleur généré avec OCaml

Le fichier `countdown.ml` contient une traduction du fichier `countdown.c` écrit en OCaml à l'aide de notre module `Mips` pour représenter le code MIPS en OCaml et de notre module `Mips_helper` pour nous faciliter l'écriture de code.

Pour le compiler puis l'exécuter :

    $ dune build countdown.exe
    $ ./countdown.exe

Pour produire un fichier de code assembleur puis l'exécuter avec Spim :

    $ ./countdown.exe > test.s
    $ spim -file test.s

