{{ config (
  materialized= 'table',
  schema= var('target_schema', 'SALESFORCE'),
  tags= ["master", "daily"],
  transient=false
)
}}

SELECT
  *
FROM
  {{ref('V_SFC_ASSETS_STG')}} AS C