global class scheduledBatchable implements Schedulable{
     global void execute(SchedulableContext sc) {
     
     getOpportunity gm=new getOpportunity();
     
     Database.executeBatch(gm,10);
      
     }
  }