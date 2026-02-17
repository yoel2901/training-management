# README --- Tests API avec Postman (Bearer Token)

## Objectif

Ce document décrit comment tester la création d'inscriptions via l'API
REST standard Salesforce en utilisant Postman et un Bearer Token de
session (méthode adaptée pour un exercice technique).

Les règles métier Apex sont exécutées automatiquement lors des appels API.

------------------------------------------------------------------------

## Contenu de la collection fournie

La collection Postman inclut :

1.  Requête de création d'un Enrollment\_\_c
2.  Exemple de Body JSON
3.  Tests automatisés (succès / erreur)

------------------------------------------------------------------------

## Prérequis

-   Accès à un org Salesforce (Developer / Sandbox)
-   Un Training_Session\_\_c existant
-   Un Contact existant
-   Postman installé

------------------------------------------------------------------------

## 🔐 Récupération du Bearer Token (méthode utilisée)

Pour les besoins de l'exercice, un **Access Token temporaire** a été
récupéré depuis la Developer Console Salesforce.

### Étapes :

1.  Aller dans **Setup**
2.  Ouvrir **Developer Console**
3.  Menu : Debug → Open Execute Anonymous Window
4.  Exécuter le script suivant  :
UserInfo.getSessionId();
String p1 = fullToken.substring(0, fullToken.length() / 2);
String p2 = fullToken.substring(fullToken.length() / 2);

System.debug('PARTIE_1:' + p1);
System.debug('PARTIE_2:' + p2);

Une fois le script executé il faudra cliquer sur "Debug Only"

5.  Copier le token qui est en 2 parties

------------------------------------------------------------------------

## ▶️ Utilisation dans Postman

Dans Postman :

Authorization → Type : Bearer Token

Coller  le token 

------------------------------------------------------------------------

## Configuration de la requête

### Méthode

POST

### URL

https://orgfarm-f030226da4-dev-ed.develop.my.salesforce.com/services/data/v60.0/sobjects/Enrollment__c


------------------------------------------------------------------------

## Body JSON (exemple)

{ "Training_Session\_\_c": "{{session_id}}", 
"Contact\_\_c":"{{contact_id}}",
 "Status\_\_c": "Confirmed", 
 "Comment\_\_c":"Enrollment created via Postman"
 }

------------------------------------------------------------------------

## Tests Postman --- Cas Succès

{
    "Training_Session__c": "a01gL00000gdPRQQA2",
    "Contact__c": "003gL00000VydMWQAZ",
    "Status__c": "Confirmed",
    "Comments__c": "Inscription crée via POSTMAN"
}

------------------------------------------------------------------------

## Tests Postman --- Cas Erreur Métier

{
    "Training_Session__c": "SALESFORCE",
    "Contact__c": "Yoel",
    "Status__c": "Planified",
    "Comments__c": ""
}

------------------------------------------------------------------------

## Exemple de réponse --- Succès

{
    "id": "a02gL00000HX0DxQAL",
    "success": true,
    "errors": []
}

------------------------------------------------------------------------

## Exemple de réponse --- Erreur

\[
    {
        "message": "Training_Session: id value of incorrect type: SALESFORCE",
        "errorCode": "MALFORMED_ID",
        "fields": [
            "Training_Session__c"
        ]
    }
]

------------------------------------------------------------------------

## Pourquoi cette approche pour l'exercice ?

Cette méthode permet de :

-   Tester rapidement l'API REST standard Salesforce
-   Vérifier que les Triggers Apex s'exécutent aussi via API
-   Éviter un développement d'API custom non demandé
-   Se concentrer sur la logique métier

------------------------------------------------------------------------

## Ce qui serait fait en environnement réel

Dans un projet réel, l'authentification serait mise en place via :

-   OAuth 2.0 avec Connected App
-   Gestion sécurisée des tokens