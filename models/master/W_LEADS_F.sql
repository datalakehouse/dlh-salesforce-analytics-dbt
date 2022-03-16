{{ config (
  materialized= 'table',
  schema= var('target_schema'),
  tags= ["master", "daily"],
  transient=false
)
}}

SELECT
  *
FROM
  {{ref('V_LEADS_STG')}} AS C