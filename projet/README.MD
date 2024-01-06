# Le Compiltapeur

Bienvenue dans le projet de fin de semestre d'Interpretation et Compiliation réalisé dans le cadre du cursus de Licence 3 en Informatique de l'Université Paris 8. Ce compilateur a été conçu pour transformer du code source en similaire a du C en code MIPS. À travers ce projet, nous explorons les différentes phases du processus de compilation, de l'analyse lexicale à la génération de code.

## Table des matières
- [Auteur](#auteur)
- [Introduction](#introduction)
- [Fonctionnalités](#fonctionnalités)
- [Execution](#execution)


## Auteur

Bastien Capiaux 21002589

## Introduction

L'objectif principal de ce compilateur est de fournir un outil capable de traduire un langage source simple similaire a du C en langage machine MIPS. En passant par l'analyse syntaxique, l'analyse sémantique, et la génération de code, notre compilateur cherche à optimiser et transformer le code source en un programme exécutable nous sonnant du code source en MIPS.

## Fonctionnalités

-  types de base :
    - entiers,
    - booléens,
    - chaînes de caractères ;
- bibliothèque de base :
    - lecture et écriture sur l’entrée et la sortie standard des types de bases,
    - opérateurs logiques de base sur les booléens (et, ou, non),
    - opérateurs arithmétiques de base sur les entiers (addition, soustraction, multiplication, division, modulo) ;
- expression :
    - valeur,
    - variable,
    - appel de fonction (de la bibliothèque de base ou définie par l’utilisateur·ice) ;
- instructions :
    - déclaration de variable,
    - assignation de la valeur d’une expression à une variable,
    - renvoie de la valeur d’une expression,
    - branchement conditionnel “si expression alors bloc sinon bloc”,
    - boucle “tant que expression faire bloc” ;
- un bloc est une séquence d’instructions ;
- un programme est une liste de définitions de fonctions (dont une s’appelle main) :
    - une fonction déclare son nom, les noms et types de ses arguments, son type de retour, et son corps,
    - le corps d’une fonction est un bloc.

## Execution

Expliquez comment installer votre projet, y compris toutes les dépendances nécessaires.

```bash
# Instruction de construction du projet
make 
# ou
ocamlbuild -use-menhir main.byte

# Instruction de nettoyage
make clean 
# ou
dune clean && rm main.byte

# Instruction de test 
make test

```
