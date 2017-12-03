@isTest
  public class scheduledBatchable_Test{
  
         static testMethod void testscheduledBatchable1(){
            
          Configuration_Instruction__c c1=new Configuration_Instruction__c();
        c1.Machine_Pages_Visible__c=true;
         c1.Name='Trest';
        insert c1;
         
           System.Assert(c1.Name!= null, 'The Test did not insert properly, please check');  
      scheduledBatchable  m1=new scheduledBatchable();
       m1.execute(null);
           

         }
  }