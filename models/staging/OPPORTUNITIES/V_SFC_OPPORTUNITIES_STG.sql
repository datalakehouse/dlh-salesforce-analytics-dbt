{{ config (
  materialized= 'view',
  schema= var('target_schema', 'SALESFORCE'),
  tags= ["staging", "daily"]
)
}}

WITH source AS (
  SELECT * FROM  {{source(var('source_schema', 'DEMO_SALESFORCE'),'OPPORTUNITY')}}
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
    MD5(S.ID) AS K_OPPORTUNITY_DLHK
    ,A.K_ACCOUNT_DLHK
    ,CO.K_CONTACT_DLHK
    ,C.K_CAMPAIGN_DLHK                
    ,U.K_USER_DLHK AS K_OWNER_USER_DLHK
    ,U2.K_USER_DLHK AS K_CREATED_BY_USER_DLHK
    ,U3.K_USER_DLHK AS K_MODIFIED_BY_USER_DLHK
    --BUSINESS KEYS
    ,S.ID AS K_OPPORTUNITY_BK
    ,A.K_ACCOUNT_BK
    ,CO.K_CONTACT_BK
    ,C.K_CAMPAIGN_BK        
    ,U.K_USER_BK AS K_OWNER_USER_BK
    ,U2.K_USER_BK AS K_CREATED_BY_USER_BK
    ,U3.K_USER_BK AS K_MODIFIED_BY_USER_BK
    ,S.PRICEBOOK2ID AS K_PRICEBOOK2_BK
    ,S.LASTAMOUNTCHANGEDHISTORYID AS K_LAST_AMOUNT_CHANGED_HISTORY_BK
    ,S.LASTCLOSEDATECHANGEDHISTORYID AS K_LAST_CLOSE_DATE_CHANGED_HISTORY_BK
    --ATTRIBUTES
    ,S.CLOSEDATE AS A_CLOSE_DATE
    ,CASE
        when S.ISWON then 'Won'
        when not S.ISWON and S.ISCLOSED then 'Lost'
        when not S.ISCLOSED and lower(S.FORECASTCATEGORY) in ('pipeline','forecast','bestcase') then 'Pipeline'
        else 'Other'
      end as A_OPPORTUNITY_STATUS
    ,S.CREATEDDATE AS A_CREATED_DATE
    ,S.DESCRIPTION AS A_DESCRIPTION
    ,S.FISCAL AS A_FISCAL
    ,S.FORECASTCATEGORY AS A_FORECAST_CATEGORY
    ,S.FORECASTCATEGORYNAME AS A_FORECAST_CATEGORY_NAME
    ,S.LASTACTIVITYDATE AS A_LAST_ACTIVITY_DATE
    ,S.LASTMODIFIEDDATE AS A_LAST_MODIFIED_DATE
    ,S.LASTREFERENCEDDATE AS A_LAST_REFERENCED_DATE
    ,S.LASTSTAGECHANGEDATE AS A_LAST_STAGE_CHANGE_DATE
    ,S.LASTVIEWEDDATE AS A_LAST_VIEWED_DATE
    ,S.LEADSOURCE AS A_LEAD_SOURCE
    ,S.NAME AS A_NAME
    ,S.NEXTSTEP AS A_NEXT_STEP
    ,S.STAGENAME AS A_STAGE_NAME
    ,S.SYSTEMMODSTAMP AS A_SYSTEM_MOD_STAMP
    ,S.FISCALQUARTER AS A_FISCALQUARTER
    ,S.FISCALYEAR AS A_FISCALYEAR
    ,S.TYPE AS A_TYPE
    ,S.HASOPENACTIVITY AS B_HAS_OPEN_ACTIVITY
    ,S.HASOPPORTUNITYLINEITEM AS B_HAS_OPPORTUNITY_LINE_ITEM
    ,S.HASOVERDUETASK AS B_HAS_OVERDUE_TASK
    ,S.ISCLOSED AS B_IS_CLOSED
    ,S.ISDELETED AS B_IS_DELETED
    ,S.ISPRIVATE AS B_IS_PRIVATE
    ,S.ISWON AS B_IS_WON
    ,S.AMOUNT AS M_AMOUNT
    ,S.EXPECTEDREVENUE AS M_EXPECTED_REVENUE
    ,S.PROBABILITY AS M_PROBABILITY
    ,S.PUSHCOUNT AS M_PUSH_COUNT
    ,S.TOTALOPPORTUNITYQUANTITY AS M_TOTAL_OPPORTUNITY_QUANTITY
    --METADATA
    ,CURRENT_TIMESTAMP as MD_LOAD_DTS
    ,'{{invocation_id}}' AS MD_INTGR_ID
FROM source S
    LEFT JOIN user U ON U.K_USER_BK = S.OWNERID
    LEFT JOIN user U2 ON U2.K_USER_BK = S.CREATEDBYID
    LEFT JOIN user U3 ON U3.K_USER_BK = S.LASTMODIFIEDBYID
    LEFT JOIN campaign C ON C.K_CAMPAIGN_BK = S.CAMPAIGNID
    LEFT JOIN account A ON A.K_ACCOUNT_BK = S.ACCOUNTID
    LEFT JOIN contact CO ON CO.K_CONTACT_BK = S.CONTACTID
WHERE
    NOT(S.ISDELETED)
) 

SELECT * FROM rename