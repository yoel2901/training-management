# Mini module de gestion de formations --- Salesforce

## Contexte

Ce projet implémente un mini module de gestion de formations permettant: 
- La gestion des formations 
- La planification de sessions 
- L'inscription de contacts 
- Le contrôle du nombre de places disponibles 
- L'utilisation via l'API REST standard Salesforce (tests réalisés avec Postman)


------------------------------------------------------------------------

## Modélisation des données

### Objet : Training\_\_c (Formation)

  Champ              Type
  ------------------ -----------------
  Name               Text
  Description\_\_c   Long Text
  Duration\_\_c      Number (heures)
  Price\_\_c         Currency
  Active\_\_c        Checkbox

------------------------------------------------------------------------

### Objet : Training_Session\_\_c (Session)

  Champ             Type
  ----------------- ---------------------------------------
  Training\_\_c     Lookup(Training\_\_c)
  Start_Date\_\_c   Date
  End_Date\_\_c     Date
  NbPlaces\_\_c     Number
  Status\_\_c       Picklist (Planned / Full / Cancelled)

Relation : 1 Formation → Plusieurs Sessions

------------------------------------------------------------------------

### Objet : Enrollment\_\_c (Inscription)

  Champ                   Type
  ----------------------- --------------------------------------------
  Training_Session\_\_c   Lookup(Session)
  Contact\_\_c            Lookup(Contact)
  Status\_\_c             Picklist (Confirmed / Pending / Cancelled)
  Comment\_\_c            Text

Relations : 1 Session → Plusieurs Inscriptions\
1 Contact → Plusieurs Inscriptions

------------------------------------------------------------------------

## Logique métier (Apex)

### Gestion des places

Lorsqu'une inscription est confirmée : 
- Vérifiez  les places restantes 
- Blocage si la session est complète
 - Si la dernière place est prise → la session passe automatiquement à "Complete"

### Annulation

Si une inscription confirmée est annulée : - Une place est libérée 
- La session repasse à "Planned" si elle était "Complete"

### Validations

Empêche : - Date de fin \< Date de début 
- Inscription sur session annulée

------------------------------------------------------------------------

## Architecture Technique

Structure adoptée :

Trigger → Service Layer → Base Salesforce

-   Trigger léger 
-   Classe de service Apex centralisant les règles
-   Code bulkifié 

Cette approche garantit la  réutilisabilité et la maintenabilité

------------------------------------------------------------------------

## Interface Utilisateur

Interface réalisée avec Lightning App Builder : Visualisation d'une
session, la liste des inscriptions associées, le statut de la
session et le nombre de places disponibles

------------------------------------------------------------------------

## Indicateur de remplissage

Un champ Formula calcule le taux de remplissage :

Data Type	Formula	 	 
IF(
OR(ISBLANK(confirmed_registrations__c), ISBLANK(NbPlaces__c), NbPlaces__c = 0),
"",
TEXT(ROUND((confirmed_registrations__c / NbPlaces__c) * 100, 0)) & "% " &
IF(
(confirmed_registrations__c / NbPlaces__c) < 0.5, "🟢",
IF(
(confirmed_registrations__c / NbPlaces__c) <= 0.8, "🟠",
"🔴"
)
)
)

------------------------------------------------------------------------


## Limites connues

-   Pas de gestion de liste d'attente
-   Interface volontairement simple
-   Pas de logique de réservation avancée

------------------------------------------------------------------------

## Améliorations possibles

Avec plus de temps : creer un Composant LWC avec barre de progression
dynamique 
Dashboard de suivi 

------------------------------------------------------------------------

## Pour un usage par 200 commerciaux

Optimisation des requêtes SOQL - Gestion du verrouillage

------------------------------------------------------------------------

## Simplifications volontaires

-   Pas de sécurité avancée 
-   Pas de multi-devises

------------------------------------------------------------------------

## Livrables

-   Code source (SFDX Project)
-   Métadonnées Salesforce
-   Collection Postman
-   README