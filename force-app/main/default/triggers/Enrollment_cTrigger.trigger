trigger Enrollment_cTrigger on Enrollment__c (before insert, before update, after insert, after update) {
    TrainingService.checkAvailability(Trigger.new);
    }
  
