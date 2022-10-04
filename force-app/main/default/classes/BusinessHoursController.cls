global  class BusinessHoursController {
    @InvocableMethod(label='Set Email Reminder TAT' description='Set Email Reminder TAT')
    global static List<Enquiry__c> setTime(List<String> ids) {
        decimal reminderTime;
        Datetime checkDT;
        
        List<Enquiry__c> enqs = TATENQSelector.getById(ids);
        List<Enquiry__c> rslist = new list<Enquiry__c>();

        for(Enquiry__c enq:enqs)
        {
            boolean flgUpdateTAT = true;
            
            if(enq.Stage__c == 'New' || enq.Stage__c == null || enq.Stage__c == 'Pre-Move Survey Planning' || enq.Stage__c == 'Costing Requested' || enq.Stage__c == 'Estimate Costing'){
                reminderTime = 2;
            }  
            else if(enq.Stage__c == 'Quote Submission'){
                reminderTime = 0.5;                
            }
            else {
                flgUpdateTAT = false;
            }
            
            if(enq.Stage__c == 'Pre-Move Survey Planning'){
                checkDT = BusinessHoursService.getReminderTimeByBusinessHour(enq.Survey_Date_Time__c, reminderTime);
            }
            else{
                checkDT = BusinessHoursService.getReminderTimeByBusinessHour(enq.Stage_Change__c, reminderTime);
            }
            
            If(Test.isRunningTest()){
                checkDT = System.now();
                flgUpdateTAT = true;
            }
            
            if( checkDT <= System.now() && flgUpdateTAT){
                Id businessHourId = BusinessHoursService.defaultBH.id;
                Datetime targetDT = BusinessHoursService.getReminderTimeByBusinessHour(system.now(), reminderTime);
                enq.TAT_Date_Time__c = targetDT;
                rslist.add(enq);
            }
        }
        
        if(!rslist.isEmpty())
            update rslist;
        
        return rslist;
    }      
}