# HandyNotes: NPCs (Forever)

**EN** — A [HandyNotes](https://www.curseforge.com/wow/addons/handynotes) plugin for **WoW Forever** that shows vendors and service NPCs
(repair, bankers, auctioneers, flight masters, innkeepers, trainers, transmogrifiers…) on the world map and the minimap,
with a minimap button to filter them by function.

**FR** — Plugin [HandyNotes](https://www.curseforge.com/wow/addons/handynotes) pour **WoW Forever** qui affiche les marchands et PNJ de service
(réparation, banquiers, commissaires-priseurs, maîtres de vol, aubergistes, maîtres, transmogrifieurs…) sur la carte et la minicarte,
avec un bouton de minicarte pour les filtrer par fonction.

## Installation
1. Installer **HandyNotes**.
2. Télécharger l'addon (*Releases*, ou *Code → Download ZIP*) et copier le dossier **`HandyNotes_NPCs_Forever`** dans `Interface/AddOns/`.
   Le nom du dossier doit être exactement `HandyNotes_NPCs_Forever` (comme le fichier `.toc`).
3. Relancer le jeu ou taper `/reload`.

## Utilisation
- **Bouton de la minicarte** : un clic ouvre le menu des fonctions de PNJ (cases à cocher, sous-menus pour les classes, métiers,
  types de marchands et maîtres de vol, « Show on Continent »). Compatible avec MinimapButtonButton.
- **Options** : `Échap > Interface > AddOns > HandyNotes > Plugins > PNJ (Forever)` (taille et opacité des icônes, faction, etc.).
- **Clic sur une icône** : point de passage (TomTom si installé).
- **Commandes** : `/npcsforever` (nombre de points), `/npcsforever menu`, `/npcsforever debug`, `/npcsforever icons`, `/npcsforever reset`.

## Langues
enUS, frFR, deDE, esES/esMX, itIT, ptBR, ruRU, koKR, zhCN, zhTW. Les textes sans équivalent dans le jeu sont traduits par l'addon ;
ces traductions n'ont pas été relues par des locuteurs natifs : les corrections sont les bienvenues (*Issues* ou *Pull requests*).

## Données
Les positions viennent de la base de **Wowhead Forever**, encore partielle (bêta) : certains PNJ n'ont pas de position et sont absents.
Les données sont mises à jour régulièrement (`Data.lua`).

*Projet de fan, non affilié à Blizzard Entertainment ni à Wowhead.*
