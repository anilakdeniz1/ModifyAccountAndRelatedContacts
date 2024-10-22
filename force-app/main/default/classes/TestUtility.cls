/** 
* @author Sami Anıl Akdeniz <anilakdeniz1@gmail.com>
* @date 22/10/2024
* @description test utility class
*/
@isTest
public with sharing class TestUtility {
    
    public static Account createAccount() {
        Account anAccount = new Account(
            Name = 'Test Account',
            Type = 'Customer',
            Industry = 'Technology',
            Phone = '123-456-7890',
            Email = 'test_account@test.com'
        );

        insert anAccount;
        
        return anAccount;
    }

    public static Account prepareAccount() {
        return new Account(
            Name = 'Test Account',
            Type = 'Customer',
            Industry = 'Technology',
            Phone = '123-456-7890',
            Email = 'test_account@test.com'
        );
    }

    public static Contact createContactWithAccount(Id accountId) {
        Contact aContact = new createContact(
        FirstName = 'Test',
        LastName = 'Contact',
        Email = 'email@test.com',
        Phone = '987-654-3210',
        Title = 'Sales Representative',
        AccountId = accountId
        );

        insert aContact;

        return aContact;
    }

    public static prepareContactWithAccount(Id accountId) {
        return new Contact(
        FirstName = 'Test',
        LastName = 'Contact',
        Email = 'email@test.com',
        Phone = '987-654-3210',
        Title = 'Sales Representative',
        AccountId = accountId
        );
    }

    public static createMultipleContactWithAccount(Id accountId, Integer length) {

        List<Contact> conListToBeInserted = new List<Contact>();
        for (Integer i=0; i<length; i++) {
            Contact aContact = new createContact(
            FirstName = 'Test',
            LastName = 'Contact' + i,
            Email = 'email@test.com',
            Phone = '987-654-3210',
            Title = 'Sales Representative',
            Is_Primary_Contact__c = false,
            AccountId = accountId
            );
            conListToBeInserted.add(aContact);

            insert conListToBeInserted;

            return conListToBeInserted;
        }
    }
}