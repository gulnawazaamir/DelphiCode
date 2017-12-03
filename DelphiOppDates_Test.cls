@isTest
  public class DelphiOppDates_Test{
  
         static testMethod void testDelphiOppDates1(){
      
             DelphiOppDates dod = new DelphiOppDates();
             dod.selectedVal='2';
             dod.updateDates();
             dod.getbackWardList();
             
             System.Assert(dod.selectedVal != null, 'The Test Account did not insert properly, please check validation rules and other mechanisms');

         }
  }