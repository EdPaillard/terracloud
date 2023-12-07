# Sample app

- Utilise une base mysql
- Site en PHP
- Gestion schéma DB 
- Tests
- Déploiement kube

## Avant tout votre fichier .env 

Créer un fichier .env dans le dossier sample-app du repo

```conf
DB_CONNECTION=mysql
DB_HOST=xxx.xxx.xxx.xxx
DB_PORT=3306
DB_DATABASE=db_name
DB_USERNAME=username
DB_PASSWORD=passwd
```

## Création du schéma 

```bash
php artisan migrate
```

## Seed du jeu de données 

```bash
php artisan db:seed
```
