/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
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

        // Get a Case record type
        RecordType rec = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        // Create Cases and assign user as case owner
        List<Case> cases = new List<Case>();
        Case c1 = new Case();
        c1.OwnerId = usr.Id;
        c1.Subject = 'Test Case Assignment Rules 1';
        c1.Status = 'New';
        c1.Priority = 'High';
        c1.RecordTypeID = rec.Id;
        cases.add(c1);

       /* Case c2 = new Case();
        c2.OwnerId = usr.Id;
        c2.Subject = 'Test Case Assignment Rules 2';
        c2.Status = 'New';
        c2.Priority = 'High';
        c2.RecordTypeID = rec.Id;
        cases.add(c2); */

        insert cases;

        List<Id> caseIds = new List<Id>(new Map<Id, Case>(cases).keySet());

        ApplyCaseAssignmentRules.CaseAssign(caseIds);
        
        System.assertNotEquals(usr.Id, caseIds[0], 'Owner has changed');
    }
}