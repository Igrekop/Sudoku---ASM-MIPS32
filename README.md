<h3 align="center">Sudoku Solveur MIPS</h3>

<p align="center">
  Ce projet est un solveur de grille Sudoku développé en assembleur MIPS32 (pour le simulateur MARS ou équivalent) dans le cadre de la première année de BUT Informatique.
  <br />
</p>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

<!-- CAPTURES D'ÉCRAN -->
## Captures d'écran
<img width="1920" height="1004" alt="image" src="https://github.com/user-attachments/assets/7f6681a9-c433-4f32-8418-a23c88e70af0" />

<!-- Ajoutez vos captures d'écran ici -->
<!-- Exemple : ![Capture d'écran du projet](./images/screenshot.png) -->

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table des matières</summary>
  <ol>
    <li>
      <a href="#à-propos-du-projet">À propos du projet</a>
      <ul>
        <li><a href="#construit-avec">Construit avec</a></li>
      </ul>
    </li>
    <li>
      <a href="#pour-commencer">Pour commencer</a>
      <ul>
        <li><a href="#prérequis">Prérequis</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#utilisation">Utilisation</a></li>
    <li><a href="#feuille-de-route">Feuille de route</a></li>
    <li><a href="#contribuer">Contribuer</a></li>
    <li><a href="#licence">Licence</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#remerciements">Remerciements</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## À propos du projet

Ce projet est un solveur de grille Sudoku développé en assembleur MIPS32. L'objectif principal est de lire une grille de Sudoku à partir d'un fichier externe, de vérifier sa validité initiale, puis d'appliquer un algorithme de backtracking récursif pour trouver et afficher toutes les solutions possibles.

### Construit avec

* [![MIPS32](https://img.shields.io/badge/Language-MIPS32-blue.svg)](https://en.wikipedia.org/wiki/MIPS_architecture)

<!-- GETTING STARTED -->
## Pour commencer

Pour exécuter le projet localement sur ton simulateur MIPS (MARS ou équivalent), suis ces étapes.

### Prérequis

* Simulateur MIPS comme [MARS](https://computerscience.missouristate.edu/mars-mips-simulator.htm) ou [SPIM](https://spimsimulator.sourceforge.net/)

### Installation

1. Clone le dépôt
   ```sh
   git clone https://github.com/Igrekop/Sudoku---ASM-MIPS32.git
   ```

2. Ouvrez le fichier `.asm` dans MARS

3. Chargez votre fichier de grille Sudoku dans le répertoire du projet

4. Assemblez et exécutez le programme

<!-- USAGE -->
## Utilisation

Le programme lit une grille depuis un fichier externe, valide la grille, puis affiche toutes les solutions possibles en console.

**Exemple de fichier d'entrée** (`sudoku.txt`) :

```
5 3 0 0 7 0 0 0 0
6 0 0 1 9 5 0 0 0
0 9 8 0 0 0 0 6 0
8 0 0 0 6 0 0 0 3
4 0 0 8 0 3 0 0 1
7 0 0 0 2 0 0 0 6
0 6 0 0 0 0 2 8 0
0 0 0 4 1 9 0 0 5
0 0 0 0 8 0 0 7 9
```

**Commande d'exécution dans MARS** :

1. Ouvrir le fichier `.asm`
2. Exécuter le programme (Run > Go)

<!-- ROADMAP -->
## Feuille de route

- [x] Lecture d'une grille depuis un fichier
- [x] Vérification de la validité initiale
- [x] Implémentation de l'algorithme de backtracking

<!-- CONTRIBUTING -->
## Contribuer

Les contributions sont les bienvenues !

1. Fork le projet
2. Créez votre branche de fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Poussez sur la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

<!-- LICENSE -->
## Licence

Distribué sous la licence MIT. Voir `LICENSE.txt` pour plus d'informations.

<!-- CONTACT -->
## Contact
Email - yvann.du.soub@gmail.com <br>
Project Link: [https://github.com/Igrekop/Sudoku-MIPS32-Solver](https://github.com/Igrekop/Sudoku---ASM-MIPS32)
