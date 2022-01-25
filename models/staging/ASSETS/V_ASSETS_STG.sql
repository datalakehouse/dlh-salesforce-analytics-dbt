{{ config (
  materialized= 'view',
  schema= 'SALESFORCE',
  tags= ["staging", "daily"]
)
}}

WITH source AS (
  SELECT * FROM  {{source('DEMO_SALESFORCE','ASSET')}}
),

rename AS 
(
        --DLHK
    MD5(ID) AS K_ASSET_DLHK
    ,MD5( TRIM(COALESCE(ACCOUNTID, '00000000000000000000000000000000'))  ) AS K_ACCOUNT_DLHK
    ,MD5( TRIM(COALESCE(CONTACTID, '00000000000000000000000000000000'))  ) AS K_CONTACT_DLHK
    ,MD5( TRIM(COALESCE(LASTMODIFIEDBYID, '00000000000000000000000000000000'))  ) AS K_LAST_MODIFIED_BY_USER_DLHK
    ,MD5( TRIM(COALESCE(OWNERID, '00000000000000000000000000000000'))  ) AS K_OWNER_USER_DLHK
    ,MD5( TRIM(COALESCE(PARENTID, '00000000000000000000000000000000'))  ) AS K_PARENT_DLHK
    ,MD5( TRIM(COALESCE(ROOTASSETID, '00000000000000000000000000000000'))  ) AS K_ROOT_ASSET_DLHK
    ,MD5( TRIM(COALESCE(PRODUCT2ID, '00000000000000000000000000000000'))  ) AS K_PRODUCT2_DLHK
    ,MD5( TRIM(COALESCE(ASSETPROVIDEDBYID, '00000000000000000000000000000000'))  ) AS K_ASSET_PROVIDED_BY_DLHK
    ,MD5( TRIM(COALESCE(ASSETSERVICEDBYID, '00000000000000000000000000000000'))  ) AS K_ASSET_SERVICE_BY_DLHK
    ,MD5( TRIM(COALESCE(CREATEDBYID, '00000000000000000000000000000000'))  ) AS K_CREATED_BY_USER_DLHK
    --BUSINESS KEYS
    ,ID AS K_ASSET_BK
    ,ACCOUNTID AS K_ACCOUNT_BK
    ,CONTACTID AS K_CONTACT_BK
    ,LASTMODIFIEDBYID AS K_LAST_MODIFIED_BY_USER_BK
    ,OWNERID AS K_OWNER_USER_BK
    ,PARENTID AS K_PARENT_BK    
    ,ROOTASSETID AS K_ROOT_ASSET_BK    
    ,PRODUCT2ID AS K_PRODUCT2_BK
    ,ASSETPROVIDEDBYID AS K_ASSET_PROVIDED_BY_BK
    ,ASSETSERVICEDBYID AS K_ASSET_SERVICE_BY_BK    
    ,CREATEDBYID AS K_CREATED_BY_USER_BK
    --ATTRIBUTES
    ,CREATEDDATE AS A_CREATED_DATE
    ,CURRENTLIFECYCLEENDDATE AS A_CURRENT_LIFE_CYCLE_END_DATE
    ,DESCRIPTION AS A_DESCRIPTION
    ,INSTALLDATE AS A_INSTALL_DATE
    ,LASTMODIFIEDDATE AS A_LAST_MODIFIED_DATE
    ,LASTREFERENCEDDATE AS A_LAST_REFERENCED_DATE
    ,LASTVIEWEDDATE AS A_LAST_VIEWED_DATE
    ,LIFECYCLEENDDATE AS A_LIFE_CYCLE_END_DATE
    ,LIFECYCLESTARTDATE AS A_LIFE_CYCLE_START_DATE
    ,NAME AS A_NAME
    ,PRODUCTCODE AS A_PRODUCT_CODE
    ,PURCHASEDATE AS A_PURCHASE_DATE
    ,SERIALNUMBER AS A_SERIAL_NUMBER
    ,STATUS AS A_STATUS
    ,STOCKKEEPINGUNIT AS A_STOCK_KEEPING_UNIT
    ,SYSTEMMODSTAMP AS A_SYSTEM_MOD_STAMP
    ,USAGEENDDATE AS A_USAGE_END_DATE    
    --BOOLEANS
    ,HASLIFECYCLEMANAGEMENT AS B_HAS_LIFE_CYCLE_MANAGEMENT
    ,ISCOMPETITORPRODUCT AS B_IS_COMPETITOR_PRODUCT
    ,ISDELETED AS B_IS_DELETED
    ,ISINTERNAL AS B_IS_INTERNAL    
    ,ASSETLEVEL AS A_ASSET_LEVEL
    --METRICS
    ,CURRENTAMOUNT AS M_CURRENTAMOUNT
    ,CURRENTMRR AS M_CURRENTMRR
    ,CURRENTQUANTITY AS M_CURRENTQUANTITY
    ,PRICE AS M_PRICE
    ,QUANTITY AS M_QUANTITY
    ,TOTALLIFECYCLEAMOUNT AS M_TOTAL_LIFE_CYCLE_AMOUNT
     --METADATA
    ,CURRENT_TIMESTAMP as MD_LOAD_DTS
    ,'{{invocation_id}}' AS MD_INTGR_ID
FROM source 
)

SELECT * FROM rename