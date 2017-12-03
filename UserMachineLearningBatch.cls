global with sharing class UserMachineLearningBatch implements Database.Batchable<Sobject>  
{  

global Decimal backDateValue;
  public UserMachineLearningBatch (Decimal selectedValue){
    backDateValue=selectedValue;
   
   System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    backDateValue  '+backDateValue);       
    } 
  
global Database.QueryLocator start(Database.BatchableContext BC)  
{  
Double probabilityScore=100.0;
String query = 'select id from opportunity where Probability=:probabilityScore';
return Database.getQueryLocator(query);  
}  
  
global void execute(Database.BatchableContext BC, List<Opportunity> scope)
{ 
mainFunction();
} 
global void mainFunction()
{
System.debug(LoggingLevel.FINEST,'  ------  :::::::::   ------    newwwwwwww ');
              DateTime endDate = System.Now();
               DateTime newDate;
              if(backDateValue==0.5)
              {
              newDate = System.Now().addMonths(-6);
              }
              else
              {
              
               newDate = System.Now().addYears(-Integer.valueof(backDateValue));
              }
              String type='';
             if(backDateValue==0.5)
              {
              type='6months';
              }
              else if(backDateValue==1)
              {
              type='12months';
              }
              
              else if(backDateValue==2)
              {
              type='24months';
              }
              else if(backDateValue==3)
              {
              type='36months';
              }
              
              List<MachineOpportunityRecord__c> oppIdList=[SELECT OpportunityId__c FROM MachineOpportunityRecord__c where timePeriod__c= :type and OpportunityDate__c > :newDate.Date() and OpportunityDate__c < =:endDate.Date()];
                Set<Id> ldIds = new Set<Id>();
            
           for(MachineOpportunityRecord__c obj:oppIdList)
           {
           ldIds.add(obj.OpportunityId__c);
           }
             List<Opportunity> scope=[Select Id,CloseDate from Opportunity where   CloseDate > :newDate.Date()  and     CloseDate <= :endDate.Date() and Probability=100.0 AND Id not in : ldIds];
                if(scope.size()>=1)
                {
                List<MachineOpportunityRecord__c> machineList=new List<MachineOpportunityRecord__c>();
                for(Opportunity opp : scope)
                {
                MachineOpportunityRecord__c m=new MachineOpportunityRecord__c();
                if(MachineOpportunityRecord__c.OpportunityId__c.getDescribe().isCreateable() && MachineOpportunityRecord__c.timePeriod__c.getDescribe().isCreateable() &&
                  MachineOpportunityRecord__c.OpportunityDate__c.getDescribe().isCreateable())
                {
                m.OpportunityId__c=opp.id;
                m.timePeriod__c=type;
                m.OpportunityDate__c=opp.CloseDate;
                machineList.add(m);
                }
                
                }
                
                insert machineList;
                getOpportunity M=new getOpportunity();
                System.debug(LoggingLevel.FINEST,'  scope'+scope);
                 System.debug(LoggingLevel.FINEST,'  type'+type);
                  System.debug(LoggingLevel.FINEST,'  ldIds'+ldIds);
                M.deleteMachineLearningRecords(type);
                M.machineLogic(scope,type,ldIds);
                
                }
                
                else
                {
                  getOpportunity M=new getOpportunity();
                  M.calculateRevenue(type);
                  M.calculatingMean(type,null);
                }
               
}

global void finish(Database.BatchableContext BC)  
{  
List<Configuration_Instruction__c> lst =Configuration_Instruction__c.getAll().values();

      lst[0].Machine_Pages_Visible__c=true;
      
      update lst[0];
      
      
 
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
List<User> allUsers=new List<User>();
 
allUsers = [SELECT Id,Name,Email from User where name = :UserInfo.getName()];
Id templateId;  
templateId = [select id, name from EmailTemplate where Name = 'delphi email template'].id;

String[] toaddress = new String[]{};
toaddress.add(allUsers[0].Email);
mail.setToAddresses(toaddress);
mail.setTemplateId(templateId);
mail.setTargetObjectId(allUsers[0].Id);
mail.setSaveAsActivity(false);
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   
      
      
          
            
}  
}