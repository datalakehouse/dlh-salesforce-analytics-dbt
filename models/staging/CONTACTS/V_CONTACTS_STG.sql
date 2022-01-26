{{ config (
  materialized= 'view',
  schema= 'SALESFORCE',
  tags= ["staging", "daily"]
)
}}

WITH source AS (
  SELECT * FROM  {{source('DEMO_SALESFORCE','CONTACT')}}
),
users AS (
  SELECT * FROM  {{ref('V_USERS_STG')}}
),
rename AS 
(
SELECT
    --DLHK
    MD5(S.ID) AS K_CONTACT_DLHK
    ,MD5( TRIM(COALESCE(S.ACCOUNTID, '00000000000000000000000000000000'))  ) AS K_ACCOUNT_DLHK
    ,MD5( TRIM(COALESCE(S.JIGSAWCONTACTID, '00000000000000000000000000000000'))  ) AS K_JIGSAW_CONTACT_DLHK
    ,MD5( TRIM(COALESCE(S.LASTMODIFIEDBYID, '00000000000000000000000000000000'))  ) AS K_LAST_MODIFIED_BY_USER_DLHK
    ,MD5( TRIM(COALESCE(S.OWNERID, '00000000000000000000000000000000'))  ) AS K_OWNER_USER_DLHK
    ,MD5( TRIM(COALESCE(S.REPORTSTOID, '00000000000000000000000000000000'))  ) AS K_REPORTS_TO_USER_DLHK
    ,MD5( TRIM(COALESCE(S.CREATEDBYID, '00000000000000000000000000000000'))  ) AS K_CREATED_BY_USER_DLHK
    ,MD5( TRIM(COALESCE(S.INDIVIDUALID, '00000000000000000000000000000000'))  ) AS K_INDIVIDUAL_DLHK
    --BUSINESS KEYS
    ,S.ID AS K_CONTACT_BK
    ,S.ACCOUNTID AS K_ACCOUNT_BK
    ,S.CREATEDBYID AS K_CREATED_BY_USER_BK    
    ,S.INDIVIDUALID AS K_INDIVIDUAL_BK
    ,S.JIGSAWCONTACTID AS K_JIGSAW_CONTACT_BK
    ,S.LASTMODIFIEDBYID AS K_LAST_MODIFIED_BY_USER_BK
    ,S.OWNERID AS K_OWNER_USER_BK
    ,S.REPORTSTOID AS K_REPORTS_TO_USER_BK
    --ATTRIBUTES
    ,U.A_FULL_NAME AS A_OWNER_FULL_NAME
    ,S.ASSISTANTNAME AS A_ASSISTANT_NAME
    ,S.ASSISTANTPHONE AS A_ASSISTANT_PHONE
    ,S.BIRTHDATE AS A_BIRTH_DATE
    ,S.CLEANSTATUS AS A_CLEAN_STATUS
    ,S.CREATEDDATE AS A_CREATED_DATE
    ,S.DEPARTMENT AS A_DEPARTMENT
    ,S.DESCRIPTION AS A_DESCRIPTION
    ,S.EMAIL AS A_EMAIL
    ,S.EMAILBOUNCEDDATE AS A_EMAIL_BOUNCED_DATE
    ,S.EMAILBOUNCEDREASON AS A_EMAIL_BOUNCED_REASON
    ,S.FAX AS A_FAX
    ,S.FIRSTNAME AS A_FIRST_NAME
    ,S.HOMEPHONE AS A_HOME_PHONE
    ,S.JIGSAW AS A_JIGSAW
    ,S.LASTACTIVITYDATE AS A_LAST_ACTIVITY_DATE
    ,S.LASTCUREQUESTDATE AS A_LAST_CUREQUEST_DATE
    ,S.LASTCUUPDATEDATE AS A_LAST_CU_UPDATE_DATE
    ,S.LASTMODIFIEDDATE AS A_LAST_MODIFIED_DATE
    ,S.LASTNAME AS A_LAST_NAME
    ,S.LASTREFERENCEDDATE AS A_LAST_REFERENCED_DATE
    ,S.LASTVIEWEDDATE AS A_LAST_VIEWED_DATE
    ,S.LEADSOURCE AS A_LEAD_SOURCE
    ,S.MAILINGCITY AS A_MAILING_CITY
    ,S.MAILINGCOUNTRY AS A_MAILING_COUNTRY
    ,S.MAILINGGEOCODEACCURACY AS A_MAILING_GEOCODE_ACCURACY
    ,S.MAILINGPOSTALCODE AS A_MAILING_POSTALCODE
    ,S.MAILINGSTATE AS A_MAILING_STATE
    ,S.MAILINGSTREET AS A_MAILING_STREET
    ,S.MOBILEPHONE AS A_MOBILE_PHONE
    ,S.NAME AS A_NAME
    ,S.NYN__LANGUAGES__C AS A_NYN__LANGUAGES__C
    ,S.NYN__LEVEL__C AS A_NYN__LEVEL__C    
    ,S.OTHERCITY AS A_OTHER_CITY
    ,S.OTHERCOUNTRY AS A_OTHER_COUNTRY
    ,S.OTHERGEOCODEACCURACY AS A_OTHER_GEOCODE_ACCURACY
    ,S.OTHERPHONE AS A_OTHER_PHONE
    ,S.OTHERPOSTALCODE AS A_OTHER_POSTALCODE
    ,S.OTHERSTATE AS A_OTHER_STATE
    ,S.OTHERSTREET AS A_OTHER_STREET
    ,S.PHONE AS A_PHONE
    ,S.PHOTOURL AS A_PHOTOURL
    ,S.SALUTATION AS A_SALUTATION
    ,S.SYSTEMMODSTAMP AS A_SYSTEMMODSTAMP
    ,S.TITLE AS A_TITLE    
    ,S.ISDELETED AS B_IS_DELETED
    ,S.ISEMAILBOUNCED AS B_IS_EMAIL_BOUNCED
    ,S.MAILINGLATITUDE AS A_MAILING_LATITUDE
    ,S.MAILINGLONGITUDE AS A_MAILING_LONGITUDE
    ,S.OTHERLATITUDE AS A_OTHER_LATITUDE
    ,S.OTHERLONGITUDE AS A_OTHER_LONGITUDE
     --METADATA
    ,CURRENT_TIMESTAMP as MD_LOAD_DTS
    ,'{{invocation_id}}' AS MD_INTGR_ID
FROM source S
    LEFT JOIN users U ON U.K_USER_BK = S.OWNERID
)

SELECT * FROM rename