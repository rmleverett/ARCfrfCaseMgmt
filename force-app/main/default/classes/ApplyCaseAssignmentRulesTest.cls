@isTest
private class ApplyCaseAssignmentRulesTest {

    @isTest
    static void CaseAssignTest() {

        // Create test user to be case owner
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
         
        User usr = new User(LastName = 'Quill',
                            FirstName='Jason',
                            Alias = 'jqui',
                            Email = 'jason.quill@asdf.com',
                            Username = 'jason.quill@asdf.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );
        insert usr;

        // Create Cases and assign user as case owner
        List<Case> cases = new List<Case>();
        Case c1 = new Case();
        c1.OwnerId = usr.Id;
        c1.Subject = 'Test Case Assignment Rules 1';
        c1.Status = 'New';
        c1.Priority = 'High';
        cases.add(c1);

       /* Case c2 = new Case();
        c2.OwnerId = usr.Id;
        c2.Subject = 'Test Case Assignment Rules 2';
        c2.Status = 'New';
        c2.Priority = 'High';
        cases.add(c2); */

        insert cases;

        List<Id> caseIds = new List<Id>(new Map<Id, Case>(cases).keySet());

        ApplyCaseAssignmentRules.CaseAssign(caseIds);
        
        System.assertNotEquals(usr.Id, caseIds[0], 'Owner has changed');
    }
}