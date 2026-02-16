public with sharing class TrainingService {
    public TrainingService() {

    }

    public static void checkAvailability(List<Enrollment__c> enrollments) {

        Set<Id> sessionIds = new Set<Id>();

        for (Enrollment__c e : enrollments) {
            if (e.Training_Session__c != null && e.Status__c == 'Confirmed') {
                sessionIds.add(e.Training_Session__c);
            }
        }

        if (sessionIds.isEmpty()) {
            return;
        }

        Map<Id, Training_Session__c> sessions = new Map<Id, Training_Session__c>(
            [SELECT Id, NbPlaces__c
             FROM Training_Session__c
             WHERE Id IN :sessionIds]
        );

        Map<Id, Integer> confirmedCounts = new Map<Id, Integer>();

        for (AggregateResult ar : [
            SELECT Training_Session__c sessionId, COUNT(Id) total
            FROM Enrollment__c
            WHERE Training_Session__c IN :sessionIds
            AND Status__c = 'Confirmed'
            GROUP BY Training_Session__c
        ]) {
            confirmedCounts.put((Id) ar.get('sessionId'), (Integer) ar.get('total'));
        }

        for (Enrollment__c e : enrollments) {

            if (e.Status__c != 'Confirmed' || e.Training_Session__c == null) {
                continue;
            }

           Integer usedSeats;

if (confirmedCounts.containsKey(e.Training_Session__c)) {
    usedSeats = confirmedCounts.get(e.Training_Session__c);
} else {
    usedSeats = 0;
}

            Integer maxSeats = (Integer) sessions.get(e.Training_Session__c).NbPlaces__c;

    
            if (usedSeats > maxSeats) {
                e.addError('This training session is already full.');
            }
        }
    }
}