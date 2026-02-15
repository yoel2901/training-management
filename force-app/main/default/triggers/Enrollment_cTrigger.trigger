trigger EnrollmentTrigger on Enrollment__c (before insert, before update, after insert, after update) {
    List<Enrollment__c> enrollmentsToProcess = Trigger.new;
    TrainingService.handleEnrollments(enrollmentsToProcess, Trigger.isBefore, Trigger.isInsert, Trigger.isUpdate);
   
}