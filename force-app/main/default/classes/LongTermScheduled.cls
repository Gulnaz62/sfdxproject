global class LongTermScheduled Implements Schedulable{
    global void execute(SchedulableContext sc){
        setLongTermFlag();
    }
    
    public void setLongTermFlag(){
        List<Job_Process__c> longTermStorageList = new List<Job_Process__c>();
        longTermStorageList = [Select Id, Transit_Status__c, Storage_Type__c, Long_Term_Flag__c, Long_Term_Time_Stamp__c from Job_Process__c 
                               where Transit_Status__c = 'Storage' and Storage_Type__c = 'Long Term Storage'];
        List<Job_Process__c> longTermFlagList = new List<Job_Process__c>();
        
        for(Job_Process__c job: longTermStorageList){
            DateTime dt = job.Long_Term_Time_Stamp__c;
            Date longTermDate = dt.date();
            if(system.today().daysBetween(longTermDate) != 0 && math.mod(system.today().daysBetween(longTermDate), 30) == 0){
                job.Long_Term_Flag__c = true;
            }
            longTermFlagList.add(job);
        }
        update longTermFlagList;
    }
    
    public static String sched5am = '0 0 5 1/1 * ? *';  //Everyday 5AM
    
    global static String scheduleEveryday5AM() {
        LongTermScheduled LT = new LongTermScheduled(); 
        return System.schedule('ScheduleClassEveryDay5AM', sched5am, LT);
    }
}