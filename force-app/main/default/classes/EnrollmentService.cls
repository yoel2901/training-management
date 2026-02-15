public with sharing class EnrollmentService {
    public EnrollmentService() {

        return [select Id from Enrollment__c where Session__c = :sessionId and Statut__c = 'Confirmée'];
    }
}