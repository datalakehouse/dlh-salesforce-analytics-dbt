{{ config (
  materialized= 'table',
  schema= var('target_schema'),
  tags= ["staging", "daily"],
  transient=false
)
}}

SELECT
  *
FROM
  {{ref('V_CONTACTS_STG')}} AS C