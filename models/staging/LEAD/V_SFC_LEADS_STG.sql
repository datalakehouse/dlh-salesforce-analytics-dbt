{{ config (
  materialized= 'view',
  schema= var('target_schema', 'SALESFORCE'),
  tags= ["staging", "daily"]
)
}}

WITH source AS (
  SELECT * FROM  {{source(var('source_schema', 'DEMO_SALESFORCE'),'LEAD')}}
),
campaign AS (
  SELECT * FROM  {{ref('W_SFC_CAMPAIGNS_F')}}
),
account AS (
  SELECT * FROM  {{ref('W_SFC_ACCOUNTS_D')}}
),
contact AS (
  SELECT * FROM  {{ref('W_SFC_CONTACTS_D')}}
),
user AS (
  SELECT * FROM  {{ref('W_SFC_USERS_D')}}
),
rename AS 
(
SELECT
  --DLHK
  MD5(S.ID) AS K_LEAD_DLHK
  ,A.K_ACCOUNT_DLHK AS K_CONVERTED_ACCOUNT_DLHK
  ,CO.K_CONTACT_DLHK AS K_CONVERTED_CONTACT_DLHK   
  ,U.K_USER_DLHK AS K_OWNER_USER_DLHK
  ,U2.K_USER_DLHK AS K_CREATED_BY_USER_DLHK
  ,U3.K_USER_DLHK AS K_MODIFIED_BY_USER_DLHK
  --BUSINESS KEYS
  ,S.ID AS K_LEAD_BK  
  ,S.CONVERTEDACCOUNTID AS K_CONVERTED_ACCOUNT_BK
  ,S.CONVERTEDCONTACTID AS K_CONVERTED_CONTACT_BK
  ,S.CONVERTEDOPPORTUNITYID AS K_CONVERTED_OPPORTUNITY_BK
  ,S.CREATEDBYID AS K_CREATED_BY_USER_BK
  ,S.DANDBCOMPANYID AS K_DAN_DB_COMPANY_BK
  ,S.INDIVIDUALID AS K_INDIVIDUAL_BK
  ,S.JIGSAWCONTACTID AS K_JIGSAW_CONTACT_BK
  ,S.LASTMODIFIEDBYID AS K_LAST_MODIFIED_BY_USER_BK
  ,S.MASTERRECORDID AS K_MASTER_RECORD_BK
  ,S.OWNERID AS K_OWNER_USER_BK
  --ATTRIBUTES
  ,S.ADDRESS AS A_ADDRESS
  ,S.STATE AS A_STATE
  ,S.STREET AS A_STREET
  ,S.CITY AS A_CITY
  ,S.CLEANSTATUS AS A_CLEAN_STATUS
  ,S.COMPANY AS A_COMPANY
  ,S.COMPANYDUNSNUMBER AS A_COMPANY_DUNS_NUMBER
  ,S.CONVERTEDDATE AS A_CONVERTED_DATE
  ,S.COUNTRY AS A_COUNTRY
  ,S.CREATEDDATE AS A_CREATED_DATE
  ,S.DESCRIPTION AS A_DESCRIPTION
  ,S.EMAIL AS A_EMAIL
  ,S.EMAILBOUNCEDDATE AS A_EMAIL_BOUNCED_DATE
  ,S.EMAILBOUNCEDREASON AS A_EMAIL_BOUNCED_REASON
  ,S.FAX AS A_FAX
  ,S.NAME AS A_NAME
  ,S.FIRSTNAME AS A_FIRST_NAME
  ,S.LASTNAME AS A_LAST_NAME
  ,S.GEOCODEACCURACY AS A_GEOCODE_ACCURACY
  ,S.INDUSTRY AS A_INDUSTRY
  ,S.JIGSAW AS A_JIGSAW
  ,S.LASTACTIVITYDATE AS A_LAST_ACTIVITY_DATE
  ,S.LASTMODIFIEDDATE AS A_LAST_MODIFIED_DATE  
  ,S.LASTREFERENCEDDATE AS A_LAST_REFERENCED_DATE
  ,S.LASTVIEWEDDATE AS A_LAST_VIEWED_DATE
  ,S.LEADSOURCE AS A_LEAD_SOURCE
  ,S.MOBILEPHONE AS A_MOBILE_PHONE  
  ,S.PHONE AS A_PHONE
  ,S.PHOTOURL AS A_PHOTOURL
  ,S.POSTALCODE AS A_POSTALCODE
  ,S.RATING AS A_RATING
  ,S.SALUTATION AS A_SALUTATION
  ,S.STATUS AS A_STATUS
  ,S.SYSTEMMODSTAMP AS A_SYSTEM_MOD_STAMP
  ,S.TITLE AS A_TITLE
  ,S.WEBSITE AS A_WEBSITE
  ,S.LATITUDE AS A_LATITUDE
  ,S.LONGITUDE AS A_LONGITUDE
  --BOOLEAN
  ,S.ISCONVERTED AS B_IS_CONVERTED
  ,S.ISDELETED AS B_IS_DELETED
  ,S.ISUNREADBYOWNER AS B_IS_UNREAD_BY_OWNER
  --METRICS
  ,S.ANNUALREVENUE AS M_ANNUAL_REVENUE  
  ,S.NUMBEROFEMPLOYEES AS M_NUMBER_OF_EMPLOYEES
    --METADATA
  ,CURRENT_TIMESTAMP as MD_LOAD_DTS
  ,'{{invocation_id}}' AS MD_INTGR_ID
FROM source S
    LEFT JOIN user U ON U.K_USER_BK = S.OWNERID
    LEFT JOIN user U2 ON U2.K_USER_BK = S.CREATEDBYID
    LEFT JOIN user U3 ON U3.K_USER_BK = S.LASTMODIFIEDBYID    
    LEFT JOIN account A ON A.K_ACCOUNT_BK = S.CONVERTEDACCOUNTID
    LEFT JOIN contact CO ON CO.K_CONTACT_BK = S.CONVERTEDCONTACTID
WHERE
  NOT(S.ISDELETED)
) 

SELECT * FROM rename