{{ config (
  materialized= 'view',
  schema= 'SALESFORCE',
  tags= ["staging","daily"]
)
}}

WITH source AS (
  SELECT * FROM  {{source('DEMO_SALESFORCE','PRICEBOOKENTRY')}}
),
user AS (
  SELECT * FROM  {{ref('W_USERS_D')}}
),
product AS (
  SELECT * FROM  {{ref('V_PRODUCTS_STG')}}
),
pricebook AS (
  SELECT * FROM {{source('DEMO_SALESFORCE','PRICEBOOK2')}}
),
rename AS 
(
SELECT
    --DLHK
    MD5(S.ID) AS K_PRODUCT_PRICES_DLHK
    ,MD5(S.PRICEBOOK2ID) AS K_PRICEBOOK_DLHK
    ,P.K_PRODUCT_DLHK AS K_PRODUCT_DLHK
    ,U2.K_USER_DLHK AS K_CREATED_BY_USER_DLHK
    ,U3.K_USER_DLHK AS K_MODIFIED_BY_USER_DLHK
    --BUSINESS KEYS
    ,S.ID AS K_PRODUCT_PRICES_BK
    ,S.PRICEBOOK2ID AS K_PRICEBOOK_BK
    ,P.K_PRODUCT_BK AS K_PRODUCT_BK
    ,U2.K_USER_BK AS K_CREATED_BY_USER_BK
    ,U3.K_USER_BK AS K_MODIFIED_BY_USER_BK
    ,S.CREATEDDATE AS A_CREATED_DATE
    ,S.LASTMODIFIEDDATE AS A_LAST_MODIFIED_DATE
    --ATTRIBUTES
    ,PR.NAME AS A_PRICEBOOK_NAME
    ,S.NAME AS A_PRICEBOOK_ENTRY_NAME    
    ,S.SYSTEMMODSTAMP AS A_SYSTEM_MOD_STAMP
    --PRODUCT
    ,P.A_DESCRIPTION AS A_PRODUCT_DESCRIPTION    
    ,P.A_FAMILY AS A_PRODUCT_FAMILY
    ,P.A_NAME AS A_PRODUCT_NAME
    ,P.A_PRODUCT_CODE AS A_PRODUCT_CODE
    ,P.A_QUANTITY_UNIT_OF_MEASURE AS A_PRODUCT_QUANTITY_UNIT_OF_MEASURE
    ,P.A_STOCK_KEEPING_UNIT AS A_PRODUCT_STOCK_KEEPING_UNIT
    --BOOLEAN
    ,P.B_IS_ACTIVE AS B_IS_ACTIVE_PRODUCT
    ,P.B_IS_ARCHIVED AS B_IS_ARCHIVED_PRODUCT
    ,S.ISACTIVE AS B_IS_ACTIVE_PRICEBOOK_ENTRY
    ,S.ISARCHIVED AS B_IS_ARCHIVED_PRICEBOOK_ENTRY
    ,S.ISDELETED AS B_IS_DELETED_PRICEBOOK_ENTRY
    ,S.USESTANDARDPRICE AS B_USE_STANDARD_PRICE
    --METRICS
    ,S.UNITPRICE AS M_UNIT_PRICE
     --METADATA
    ,CURRENT_TIMESTAMP as MD_LOAD_DTS
    ,'{{invocation_id}}' AS MD_INTGR_ID
FROM
    source S
    LEFT JOIN user U2 ON U2.K_USER_BK = S.CREATEDBYID
    LEFT JOIN user U3 ON U3.K_USER_BK = S.LASTMODIFIEDBYID 
    LEFT JOIN product P ON P.K_PRODUCT_DLHK = S.PRODUCT2ID
    LEFT JOIN pricebook PR ON PR.ID = s.PRICEBOOK2ID
WHERE
  NOT(S.ISDELETED)
)

SELECT * FROM rename