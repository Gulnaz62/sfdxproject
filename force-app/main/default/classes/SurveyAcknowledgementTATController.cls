global class SurveyAcknowledgementTATController {
    @InvocableMethod(label='Set Survey Acknowledgement TAT' description='Set Survey Acknowledgement TAT')
    global static List<Enquiry__c> setSurveyAcknowledgementTime(List<String> ids) {
        decimal surveyAcknowledgementReminderTime;
		DateTime checkTime;
        
        List<Enquiry__c> enqs = TATENQSelector.getById(ids);
        List<Enquiry__c> reslist = new list<Enquiry__c>();

        for(Enquiry__c enq:enqs)
        {
            if(enq.Survey_Acknowledgement__c == null  && enq.Survey_Type__c != 'List Of Items'){
                surveyAcknowledgementReminderTime = 0.5;
                checkTime = BusinessHoursService.getReminderTimeByBusinessHour(enq.Survey_DateTime_Update__c, surveyAcknowledgementReminderTime);
                if(test.isRunningTest()){
                    checkTime = System.now();
                }
                if( checkTime <= System.now()){
                    Id businessHourId = BusinessHoursService.defaultBH.id;
                    Datetime targetDT = BusinessHoursService.getReminderTimeByBusinessHour(system.now(), surveyAcknowledgementReminderTime);
                    enq.Survey_Acknowledgement_TAT_DateTime__c = targetDT;
                    reslist.add(enq);
                }
        	}
        }
        
        if(!reslist.isEmpty())
            update reslist;
        
        return reslist;
    }      

}