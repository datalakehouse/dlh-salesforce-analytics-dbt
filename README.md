[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

# Salesforce package

This dbt package:

*   Contains a DBT dimensional model based on salesforce cloud data from [Datalakehouse’s](https://www.datalakehouse.io/) connector.
*   The main use of this package is to provide a stable snowflake dimensional model that will provide useful insights for the sales team.
    

### Models

The primary ouputs of this package are fact and dimension tables as listed below. There are  
several intermediate models used to create these two models.

<table data-layout="default" data-local-id="257a8484-0c17-4cf3-ba57-18535ab0cdba" class="confluenceTable"><colgroup><col style="width: 380.0px;"><col style="width: 380.0px;"></colgroup><tbody><tr><th class="confluenceTh"><p>model</p></th><th class="confluenceTh"><p>description</p></th></tr><tr><td class="confluenceTd"><p>W_ACCOUNTS_D</p></td><td class="confluenceTd"><p>Represents an individual account, which is an organization or person involved with your business (such as customers, competitors, and partners). More details about accounts can be found <a href="https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_account.htm" class="external-link" rel="nofollow">here.</a></p></td></tr><tr><td class="confluenceTd"><p>W_ASSETS_D</p></td><td class="confluenceTd"><p>Represents an item of commercial value, such as a product sold by your company or a competitor, that a customer has purchased.<br>More details about assets can be found <a href="https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_account.htm" class="external-link" rel="nofollow">here.</a></p></td></tr><tr><td class="confluenceTd"><p>W_CONTACTS_D</p></td><td class="confluenceTd"><p>Represents a contact, which is a person associated with an account.</p><p>More details about contacts can be found <a href="https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_contact.htm" class="external-link" rel="nofollow">here.</a></p></td></tr><tr><td class="confluenceTd"><p>W_CONTRACTS_D</p></td><td class="confluenceTd"><p>Represents a contract (a business agreement) associated with an Account.</p><p>More details about contracts can be found <a href="https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_contract.htm" class="external-link" rel="nofollow">here.</a></p></td></tr><tr><td class="confluenceTd"><p>W_PRODUCT_PRICES_D</p></td><td class="confluenceTd"><p>Represents a price book that contains the list of products that your org sells and it’s prices.</p><p><a href="https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_pricebook2.htm" class="external-link" rel="nofollow">Pricebook2 details;</a><br><a href="https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_pricebookentry.htm" class="external-link" rel="nofollow">Pricebookentry details;</a><br><a href="https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_product2.htm" class="external-link" rel="nofollow">Product2 details;</a></p></td></tr><tr><td class="confluenceTd"><p>W_USERS_D</p></td><td class="confluenceTd"><p>Represents a user in the organization, and it’s role and profile.</p><p>More details about users can be found <a href="https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_user.htm" class="external-link" rel="nofollow">here.</a></p></td></tr><tr><td class="confluenceTd"><p>W_CAMPAIGNS_F</p></td><td class="confluenceTd"><p>Represents and tracks a marketing campaign, such as a direct mail promotion, webinar, or trade show.</p><p>More details about campaigns can be found <a href="https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_campaign.htm" class="external-link" rel="nofollow">here.</a></p></td></tr><tr><td class="confluenceTd"><p>W_CASES_F</p></td><td class="confluenceTd"><p>Represents a case, which is a customer issue or problem.</p><p>More details about cases can be found <a href="https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_case.htm" class="external-link" rel="nofollow">here.</a></p></td></tr><tr><td class="confluenceTd"><p>W_LEADS_F</p></td><td class="confluenceTd"><p>Represents a prospect or lead.</p><p>More details about leads can be found <a href="https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_lead.htm" class="external-link" rel="nofollow">here.</a></p></td></tr><tr><td class="confluenceTd"><p>W_OPPORTUNITIES_F</p></td><td class="confluenceTd"><p>Represents an opportunity, which is a sale or pending deal.</p><p>More details about opportunities can be found <a href="https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_lead.htm" class="external-link" rel="nofollow">here.</a></p></td></tr></tbody></table>

![](attachments/1242169345/1242234892.png)

Installation Instructions
-------------------------

Check [dbt Hub](https://hub.getdbt.com/dbt-labs/snowplow/latest/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your packages.yml

```yaml
packages:
  - package: datalakehouse/dlh-salesforce-analytics-dbt
    version: [">=0.1.0"]
```

Configuration
-------------

By default, this package uses `DEVELOPER_SANDBOX` as the source database name and `DEMO_SALESFORCE` as schema name. If this is not the where your salesforce data is, change ther below [variables](https://docs.getdbt.com/docs/using-variables) configuration on your `dbt_project.yml:`

```yaml
# dbt_project.yml

...

vars:    
    dlh_salesforce:
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