{{ config (
  materialized= 'view',
  schema= 'SALESFORCE',
  tags= ["staging", "daily"]
)
}}

WITH source AS (
  SELECT * FROM  {{source('DEMO_SALESFORCE','ACCOUNT')}}
),
users AS (
  SELECT * FROM  {{ref('V_USERS_STG')}}
),
parent_accounts AS (
  SELECT * FROM  {{ref('V_ACCOUNTS_HIERARCHY')}}
),

rename AS 
(
 SELECT
--DLHK
  MD5(S.ID) AS K_ACCOUNT_DLHK
  ,MD5( TRIM(COALESCE(S.JIGSAWCOMPANYID, '00000000000000000000000000000000'))  ) AS K_JIGSAW_COMPANY_DLHK
  ,MD5( TRIM(COALESCE(S.LASTMODIFIEDBYID, '00000000000000000000000000000000'))  ) AS K_LAST_MODIFIED_BY_USER_DLHK
  ,K_USER_DLHK AS K_OWNER_USER_DLHK
  ,MD5( TRIM(COALESCE(S.PARENTID, '00000000000000000000000000000000'))  ) AS K_PARENT_DLHK
  ,MD5( TRIM(COALESCE(S.CREATEDBYID, '00000000000000000000000000000000'))  ) AS K_CREATED_BY_USER_DLHK
  ,MD5( TRIM(COALESCE(S.DANDBCOMPANYID,  '00000000000000000000000000000000'))  ) AS K_DAN_DB_COMPANY_DLHK
  --BUSINESS KEYS
  ,S.ID AS K_ACCOUNT_BK
  ,S.JIGSAWCOMPANYID AS K_JIGSAW_COMPANY_BK
  ,S.LASTMODIFIEDBYID AS K_LAST_MODIFIED_BY_USER_BK
  ,S.OWNERID AS K_OWNER_USER_BK
  ,S.PARENTID AS K_PARENT_BK
  ,S.CREATEDBYID AS K_CREATED_BY_USER_BK
  ,S.DANDBCOMPANYID AS K_DAN_DB_COMPANY_BK
  
  --ATTRIBUTES
  ,U.A_FULL_NAME AS A_OWNER_FULL_NAME
  ,U.A_USER_ROLE_FULL_NAME AS A_OWNER_ROLE
  ,U.A_USER_PROFILE_NAME AS A_OWNER_PROFILE
  ,S.ACCOUNTNUMBER AS A_ACCOUNT_NUMBER
  ,S.ACCOUNTSOURCE AS A_ACCOUNT_SOURCE
  ,S.BILLINGCITY AS A_BILLING_CITY
  ,S.BILLINGCOUNTRY AS A_BILLING_COUNTRY
  ,S.BILLINGGEOCODEACCURACY AS A_BILLING_GEOCODE_ACCURACY
  ,S.BILLINGPOSTALCODE AS A_BILLING_POSTALCODE
  ,S.BILLINGSTATE AS A_BILLING_STATE
  ,S.BILLINGSTREET AS A_BILLING_STREET
  ,S.SHIPPINGCITY AS A_SHIPPING_CITY
  ,S.SHIPPINGCOUNTRY AS A_SHIPPING_COUNTRY
  ,S.SHIPPINGGEOCODEACCURACY AS A_SHIPPING_GEOCODE_ACCURACY
  ,S.SHIPPINGPOSTALCODE AS A_SHIPPING_POSTALCODE
  ,S.SHIPPINGSTATE AS A_SHIPPING_STATE
  ,S.SHIPPINGSTREET AS A_SHIPPING_STREET
  ,S.BILLINGLATITUDE AS A_BILLING_LATITUDE
  ,S.BILLINGLONGITUDE AS A_BILLING_LONGITUDE
  ,S.SHIPPINGLATITUDE AS A_SHIPPING_LATITUDE
  ,S.SHIPPINGLONGITUDE AS A_SHIPPING_LONGITUDE
  ,S.CLEANSTATUS AS A_CLEAN_STATUS
  ,S.CREATEDDATE AS A_CREATED_DATE
  ,S.DESCRIPTION AS A_DESCRIPTION
  ,S.DUNSNUMBER AS A_DUNSNUMBER
  ,S.FAX AS A_FAX
  ,S.INDUSTRY AS A_INDUSTRY
  ,S.JIGSAW AS A_JIGSAW
  ,S.LASTACTIVITYDATE AS A_LAST_ACTIVITY_DATE
  ,S.LASTMODIFIEDDATE AS A_LAST_MODIFIED_DATE
  ,S.LASTREFERENCEDDATE AS A_LAST_REFERENCED_DATE
  ,S.LASTVIEWEDDATE AS A_LAST_VIEWED_DATE
  ,S.NAICSCODE AS A_NAICS_CODE
  ,S.NAICSDESC AS A_NAICS_DESC
  ,S.NAME AS A_NAME
  ,P.A_ACCOUNT_FULL_NAME AS A_ACCOUNT_FULL_NAME
  ,S.NYN__ACTIVE__C AS A_NYN__ACTIVE__C
  ,S.NYN__CUSTOMERPRIORITY__C AS A_NYN__CUSTOMERPRIORITY__C
  ,S.NYN__SLAEXPIRATIONDATE__C AS A_NYN__SLAEXPIRATIONDATE__C
  ,S.NYN__SLASERIALNUMBER__C AS A_NYN__SLASERIALNUMBER__C
  ,S.NYN__SLA__C AS A_NYN__SLA__C
  ,S.NYN__UPSELLOPPORTUNITY__C AS A_NYN__UPSELLOPPORTUNITY__C
  ,S.OWNERSHIP AS A_OWNERSHIP
  ,S.PHONE AS A_PHONE
  ,S.PHOTOURL AS A_PHOTO_URL
  ,S.RATING AS A_RATING
  ,S.SIC AS A_SIC
  ,S.SICDESC AS A_SICDESC
  ,S.SITE AS A_SITE
  ,S.SYSTEMMODSTAMP AS A_SYSTEM_MODSTAMP
  ,S.TICKERSYMBOL AS A_TICKER_SYMBOL
  ,S.TRADESTYLE AS A_TRADE_STYLE
  ,S.TYPE AS A_TYPE
  ,S.WEBSITE AS A_WEBSITE
  ,S.YEARSTARTED AS A_YEAR_STARTED  
    --BOOLEAN
  ,S.ISDELETED AS B_IS_DELETED
  --METRICS
  ,S.ANNUALREVENUE AS M_ANNUALREVENUE
  ,S.NUMBEROFEMPLOYEES AS M_NUMBEROFEMPLOYEES
  ,S.NYN__NUMBEROFLOCATIONS__C AS M_NYN__NUMBEROFLOCATIONS__C
    --METADATA
  ,CURRENT_TIMESTAMP as MD_LOAD_DTS
  ,'{{invocation_id}}' AS MD_INTGR_ID
FROM source S
  LEFT JOIN users U on U.K_USER_BK = S.OWNERID
  LEFT JOIN parent_accounts P ON P.K_ACCOUNT_BK = S.ID
)

SELECT * FROM rename