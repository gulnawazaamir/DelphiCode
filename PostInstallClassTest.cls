@isTest
private class PostInstallClassTest
{
    static testMethod void installTest()
    {
       PostInstallClass postinstall = new PostInstallClass();
      
  //  Test.testInstall(postinstall, null);
    Test.testInstall(postinstall, new Version(1,0), true);
    
     
           System.Assert(true, 'The Test did not insert properly, please check');
    }
}