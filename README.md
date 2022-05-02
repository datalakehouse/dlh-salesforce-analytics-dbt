# Salesforce package

This dbt package:

*   Contains a DBT dimensional model based on salesforce cloud data from [Datalakehouse’s](https://www.datalakehouse.io/) connector.
*   The main use of this package is to provide a stable snowflake dimensional model that will provide useful insights for your sales team.
    

### Models

The primary ouputs of this package are fact and dimension tables as listed below. There are several intermediate models used to create these models.

|        Model       |        Description       |
|:----------------:|:----------------:|
| W_SFC_ACCOUNTS_D       | <div align="left"> Represents an individual account, which is an organization or person involved with your business (such as customers, competitors, and partners).<br/>More details about accounts can be found [here](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_account.htm). </div> |
| W_SFC_ASSETS_D         | <div align="left">Represents an item of commercial value, such as a product sold by your company or a competitor, that a customer has purchased.<br/>More details about assets can be found [here](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_asset.htm). </div>|
| W_SFC_CONTACTS_D       | <div align="left">Represents a contact, which is a person associated with an account.<br/>More details about contacts can be found [here](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_contact.htm).</div>|
| W_SFC_CONTRACTS_D      | <div align="left">Represents a contract (a business agreement) associated with an Account.<br/>More details about contracts can be found [here](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_contact.htm).</div>|
| W_SFC_PRODUCT_PRICES_D | <div align="left">Represents a price book that contains the list of products that your org sells and it’s prices. <br/>[Pricebook2 details](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_pricebook2.htm); <br/>[Pricebookentry details](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_pricebookentry.htm); <br/>[Product2 details](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_product2.htm);</div>|
| W_SFC_USERS_D          | <div align="left">Represents a user in the organization, and it’s role and profile. <br/>More details about users can be found [here](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_user.htm).</div>|
| W_SFC_CAMPAIGNS_F      | <div align="left">Represents and tracks a marketing campaign, such as a direct mail promotion, webinar, or trade show. More details about campaigns can be found [here](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_campaign.htm).</div>|
| W_SFC_CASES_F          | <div align="left">Represents a case, which is a customer issue or problem. <br/>More details about cases can be found [here](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_case.htm).</div>|
| W_SFC_LEADS_F          | <div align="left">Represents a prospect or lead.<br/>More details about leads can be found [here](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_lead.htm).</div>|
| W_SFC_OPPORTUNITIES_F  | <div align="left">Represents an opportunity, which is a sale or pending deal.<br/>More details about opportunities can be found [here](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_opportunity.htm).</div>|


![](attachments/1242169345/1242234892.png)

Installation Instructions
-------------------------

Check [dbt Hub](https://hub.getdbt.com/dbt-labs/snowplow/latest/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your packages.yml

```yaml
packages:
  - package: datalakehouse/dlh_salesforce
    version: [">=0.1.0"]
```

Configuration
-------------

By default, this package uses `DEVELOPER_SANDBOX` as the source database name and `DEMO_SALESFORCE` as schema name. If this is not the where your salesforce data is, change ther below [variables](https://docs.getdbt.com/docs/using-variables) configuration on your `dbt_project.yml`:

```yaml
# dbt_project.yml

...

vars:    
    source_database: DEVELOPER_SANDBOX
    source_schema: DEMO_SALESFORCE
    target_schema: SALESFORCE
```

### Database support

Core:

*   Snowflake
    

### Contributions

Additional contributions to this package are very welcome! Please create issues or open PRs against `main`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.


*   Fork and :star: this repository :)
*   Check it out and :star: [the datalakehouse core repository](https://github.com/datalakehouse/datalakehouse-core);
