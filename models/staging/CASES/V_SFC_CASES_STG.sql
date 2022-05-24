{{ config (
  materialized= 'view',
  schema= var('target_schema', 'SALESFORCE'),
  tags= ["staging", "daily"]
)
}}

WITH source AS (
  SELECT * FROM  {{source(var('source_schema', 'DEMO_SALESFORCE'),'CASE')}}
),
asset AS (
  SELECT * FROM  {{ref('W_SFC_ASSETS_D')}}
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
parent_cases AS (
  SELECT * FROM  {{ref('V_SFC_CASES_HIERARCHY')}}
),
rename AS 
(
SELECT
    --DLHK
    MD5(S.ID) AS K_CASE_DLHK
    ,A.K_ACCOUNT_DLHK
    ,CO.K_CONTACT_DLHK
    ,U.K_USER_DLHK AS K_OWNER_USER_DLHK
    ,U2.K_USER_DLHK AS K_CREATED_BY_USER_DLHK
    ,U3.K_USER_DLHK AS K_MODIFIED_BY_USER_DLHK
    --BUSINESS KEYS
    ,S.ID AS K_CASE_BK
    ,S.ACCOUNTID AS K_ACCOUNT_BK
    ,S.ASSETID AS K_ASSET_BK
    ,S.CONTACTID AS K_CONTACT_BK
    ,S.CREATEDBYID AS K_CREATED_BY_USER_BK  
    ,S.LASTMODIFIEDBYID AS K_MODIFIED_BY_USER_BK
    ,S.MASTERRECORDID AS K_MASTER_RECORD_BK
    ,S.OWNERID AS K_OWNER_USER_BK
    ,S.PARENTID AS K_PARENT_BK
    ,S.SOURCEID AS K_SOURCE_BK
    --ATTRIBUTES
    ,S.CASENUMBER AS A_CASE_NUMBER
    ,P.A_CASE_NUMBER_HIERARCHY
    ,S.CLOSEDDATE AS A_CLOSED_DATE
    ,S.COMMENTS AS A_COMMENTS
    ,S.CONTACTEMAIL AS A_CONTACT_EMAIL
    ,S.CONTACTFAX AS A_CONTACT_FAX
    ,S.CONTACTMOBILE AS A_CONTACT_MOBILE
    ,S.CONTACTPHONE AS A_CONTACT_PHONE
    ,S.CREATEDDATE AS A_CREATED_DATE
    ,S.DESCRIPTION AS A_DESCRIPTION
    ,S.LASTMODIFIEDDATE AS A_LAST_MODIFIED_DATE
    ,S.LASTREFERENCEDDATE AS A_LAST_REFERENCED_DATE
    ,S.LASTVIEWEDDATE AS A_LAST_VIEWED_DATE
    ,S.ORIGIN AS A_ORIGIN
    ,S.PRIORITY AS A_PRIORITY
    ,S.REASON AS A_REASON
    ,S.STATUS AS A_STATUS
    ,S.SUBJECT AS A_SUBJECT
    ,S.SUPPLIEDCOMPANY AS A_SUPPLIED_COMPANY
    ,S.SUPPLIEDEMAIL AS A_SUPPLIED_EMAIL
    ,S.SUPPLIEDNAME AS A_SUPPLIED_NAME
    ,S.SUPPLIEDPHONE AS A_SUPPLIED_PHONE
    ,S.SYSTEMMODSTAMP AS A_SYSTEM_MOD_STAMP
    ,S.TYPE AS A_TYPE
    --BOOLEAN
    ,S.ISCLOSED AS B_IS_CLOSED
    ,S.ISDELETED AS B_ISD_ELETED
    ,S.ISESCALATED AS B_IS_ESCALATED
    --METADATA
    ,CURRENT_TIMESTAMP as MD_LOAD_DTS
    ,'{{invocation_id}}' AS MD_INTGR_ID
FROM source S
    LEFT JOIN user U ON U.K_USER_BK = S.OWNERID
    LEFT JOIN user U2 ON U2.K_USER_BK = S.CREATEDBYID
    LEFT JOIN user U3 ON U3.K_USER_BK = S.LASTMODIFIEDBYID    
    LEFT JOIN account A ON A.K_ACCOUNT_BK = S.ACCOUNTID
    LEFT JOIN contact CO ON CO.K_CONTACT_BK = S.CONTACTID
    LEFT JOIN parent_cases P ON P.K_CASE_BK = S.ID
WHERE
    NOT(S.ISDELETED)
) 

SELECT * FROM rename