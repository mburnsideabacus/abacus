public with sharing class LFLLoginBannerController {
   
        @AuraEnabled(cacheable=true)  
        public static LFL_Notification_Banner__mdt getBannerDetail() {
            
            return [ 
                    SELECT Id, Published__c, Description__c, Start__c, End__c, Message__c
                    FROM LFL_Notification_Banner__mdt 
                    where Published__c = true
                    LIMIT 1
                   ];
        }
        }
