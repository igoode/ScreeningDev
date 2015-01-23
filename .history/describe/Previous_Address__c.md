2015-01-08 12:33:15
```java
Previous_Address__c Describe:
----------------------------------------------------------------------------------------------------
Total Fields: 	18
----------------------------------------------------------------------------------------------------
Label                                   Name                                    Type                          Length    
------------------------------------------------------------------------------------------------------------------------
Created By ID                           CreatedById                             reference                     18        
Created Date                            CreatedDate                             datetime                                
Deleted                                 IsDeleted                               boolean                                 
Last Activity Date                      LastActivityDate                        date                                    
Last Modified By ID                     LastModifiedById                        reference                     18        
Last Modified Date                      LastModifiedDate                        datetime                                
Owner ID                                OwnerId                                 reference                     18        
Period of Residence From                Period_of_Residence_From__c             date                                    
Period of Residence To                  Period_of_Residence_To__c               date                                    
Postcode                                Postcode__c                             string                        4         
Previous Address ID                     Name                                    string                        80        
Record ID                               Id                                      id                            18        
State                                   State__c                                picklist                      255       
Street Name                             Street_Name__c                          string                        255       
Street No                               Street_No__c                            string                        20        
Suburb                                  Suburb__c                               string                        255       
System Modstamp                         SystemModstamp                          datetime                                
Unit No                                 Unit_No__c                              string                        20        

----------------------------------------------------------------------------------------------------
Record Type Info: 	1
----------------------------------------------------------------------------------------------------
Available Recordtypeid        Default        Name                               
--------------------------------------------------------------------------------
True      012000000000000AAA  True           Master                             

----------------------------------------------------------------------------------------------------
ChildRelationships Info: 	19
----------------------------------------------------------------------------------------------------
Cascadedelete                 Relationshipname              Childsobject                  Field                         
------------------------------------------------------------------------------------------------------------------------
True                          ActivityHistories             ActivityHistory               WhatId                        
True                          AttachedContentDocuments      AttachedContentDocument       LinkedEntityId                
True                          Attachments                   Attachment                    ParentId                      
True                          CombinedAttachments           CombinedAttachment            ParentId                      
True                                                        ContentDistribution           RelatedRecordId               
True                                                        ContentDocumentLink           LinkedEntityId                
                                                            ContentVersion                FirstPublishLocationId        
True                          FeedSubscriptionsForEntity    EntitySubscription            ParentId                      
True                          Events                        Event                         WhatId                        
                                                            FeedComment                   ParentId                      
True                                                        FeedItem                      ParentId                      
True                          Notes                         Note                          ParentId                      
True                          NotesAndAttachments           NoteAndAttachment             ParentId                      
True                          OpenActivities                OpenActivity                  WhatId                        
True                          Histories                     Previous_Address__History     ParentId                      
True                          ProcessInstances              ProcessInstance               TargetObjectId                
                              ProcessSteps                  ProcessInstanceHistory        TargetObjectId                
True                          Tasks                         Task                          WhatId                        
True                          TopicAssignments              TopicAssignment               EntityId                      


```

