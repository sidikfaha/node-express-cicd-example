# Manuel, déploiement continu d’un projet (Nodejs) sur GitHub avec GitHub Action

Stack :

* Projet : Nodejs (express)
* Serveur : Linux
* Outils : Docker, GitHub Actions

## Étape 1 : construction de l'artefact (image docker)

Considérons que le projet est une API REST développée avec Nodejs. La première phase consistera à construire un artefact pour l'API. Puis que nous utiliserons Docker, il s'agira ici de la contruction d'une image. Pour ce faire, Il faudra juste éditer un fichier `Dockerfile`dont la structure basique pour un projet nodejs est la suivante :

```dockerfile
FROM node:18

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8080
CMD [ "node", "server.js" ]
```

Il peut être beaucoup plus complex en fonction des exigences techniques du projet.
Aussi, il faudra penser à créer un fichier `.dockerignore` dont le contenu sera une liste de répertoires à exclure du contexte de docker. Généralement contitué du répertoire `node_modules` et tous les autres répertoires ou fichiers qui ne sont pas nécessaires au fontionnement de l'API.

## Etape 2 : Sauvegarde de l'artefact

Vu que dans l'étape précédente nous avons contruit notre artéfact, nous devons à présent le stocker sur un espace accessible par le serveur qui l'hébergera. les images docker sont stockés dans des répositories précis qui peuvent être managés (tel que Elastic Container Registry chez AWS ou Azure Container Registry chez Azure) ou non managés (Harbor).

## Etape 3 : Téléchargement de l'artefact sur le serveur

Vu que nous avons contruit notre artefact, il est temps de le déployer sur le serveur. Il s'agit ici de faire un `docker pull` de l'image (avec le tag de la plus récente) sur le serveur, détruire le conteneur lancé avec l'ancienne image et lancer un nouveau conteneur basé sur l'image la plus récente.

La commande de lancement doit bien évidemment fournir les variables d'enviornnement réquises et exposer le port adéquat.

Pour pouvoir exécuter toutes ces commandes, on peut effectuer une connexion SSH sur ce dernier (de préférence avec une clé privée).

## Etape 4 : Ecriture du pipeline (GitHub Action)

Tous les pipelines doivent être écris au format `yaml` dans le répertoire `.github/workflows`. Tous les fichiers qui s'y trouvent seront interprétés comme des pipelines.

## Exemple

Dans le fichier [deploy.yml](.github/workflows/deploy.yml), vous avez un exemple de pipeline pour déployer notre API sur un serveur linux distant.
