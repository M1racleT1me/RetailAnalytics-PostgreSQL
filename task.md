# RetailAnalytics v1.0

Retail analytics data upload, its simple analysis, statistics, customer segmentation

#### Personal information Table

| **Field**                   | **System field name**       | **Format / possible values**                                                     | **Description**                                                                                              |
|:---------------------------:|:---------------------------:|:--------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------:|
| Customer ID                 | Customer_ID                 | ---                                                                              | ---                                                                                                       |
| Name                        | Customer_Name               | Cyrillic or Latin, the first letter is capitalized, the rest are upper case, dashes and spaces are allowed | ---                                                                                                       |
| Surname                     | Customer_Surname            | Cyrillic or Latin, the first letter is capitalized, the rest are upper case, dashes and spaces are allowed | ---                                                                                                       |
| Customer E-mail             | Customer_Primary_Email      | E-mail format                                                                    | ---                                                                                                                             |
| Customer phone number       | Customer_Primary_Phone      | +7 and 10 Arabic numerals                                                                 | ---                                                                                                       |

#### Cards Table

| **Field**   | **System field name**       | **Format / possible values**    | **Description**                    |
|:-----------:|:---------------------------:|:-------------------------------:|:----------------------------------:|
| Card ID     | Customer_Card_ID            | ---                             | ---                                |
| Customer ID | Customer_ID                 | ---                             | One customer can own several cards |

#### Transactions Table

| **Field**                | **System field name**       | **Format / possible values**    | **Description**                                               |
|:------------------------:|:---------------------------:|:-------------------------------:|:-------------------------------------------------------------------------:|
| Transaction ID           | Transaction_ID              | ---                             | Unique value                                                               |
| Card ID                  | Customer_Card_ID            | ---                             | ---                                                                        |
| Transaction sum          | Transaction_Summ            | Arabic numeral                  | Transaction sum in rubles(full purchase price excluding discounts) |
| Transaction date         | Transaction_DateTime        | dd.mm.yyyy hh:mm:ss             | Date and time when the transaction was made                                |
| Store                    | Transaction_Store_ID        | Store ID                        | The store where the transaction was made                                   |

#### Checks Table

| **Field**                                        | **System field name**  | **Format / possible values** | **Description**                                                                                                                  |
|:------------------------------------------------:|:----------------------:|:----------------------------:|:----------------------------------------------------------------------------------------------------------------:|
| Transaction ID                                   | Transaction_ID         | ---                          | Transaction ID is specified for all products in the check                                                         |
| Product in the check                             | SKU_ID                 | ---                          | ---                                                                                                               |
| Number of pieces or kilograms                    | SKU_Amount             | Arabic numeral               | The quantity of the purchased product                                                                             |
| Total amount for which the product was purchased | SKU_Summ               | Arabic numeral               | The purchase amount of the actual volume of this product in rubles (full price without discounts and bonuses) |
| The paid price of the product                    | SKU_Summ_Paid          | Arabic numeral               | The amount actually paid for the product not including the discount                                            |
| Discount granted                                 | SKU_Discount           | Arabic numeral               | The size of the discount granted for the product in rubles                                                 |

#### Product grid Table

| **Field**                     | **System field name**       | **Format / possible values**                  | **Description**                                                                                                                                                                                                |
|:-----------------------------:|:---------------------------:|:---------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| Product ID                    | SKU_ID                      | ---                                           | ---                                                                                                                                                                                                            |
| Product name                  | SKU_Name                    | Cyrillic or Latin, Arabic numerals, special characters | ---                                                                                                                                                                                                            |
| SKU group                     | Group_ID                    | ---                                           | The ID of the group of related products to which the product belongs (for example, same type of yogurt of the same manufacturer and volume, but different flavors). One identifier is specified for all products in the group |


#### Stores Table

| **Field**              | **System field name**    | **Format / possible values** | **Description**                                                  |
|:----------------------:|:------------------------:|:----------------------------:|:----------------------------------------------------------------:|
| Store                  | Transaction_Store_ID     | ---                          | ---                                                              |
| Product ID             | SKU_ID                   | ---                          | ---                                                              |
| Product purchase price | SKU_Purchase_Price       | Arabic numeral               | Purchasing price of products for this store                      |
| Product retail price   | SKU_Retail_Price         | Arabic numeral               | The sale price of the product excluding discounts for this store |


#### SKU group Table

| **Field**         | **System field name** | **Format / possible values**                  | **Description** |
|:-----------------:|:---------------------:|:---------------------------------------------:|:---------------:|
| SKU group         | Group_ID              | ---                                           | ---             |
| Group name        | Group_Name            | Cyrillic or Latin, Arabic numerals, special characters | ---             | 

#### Date of analysis formation Table

| **Field**         | **System field name** | **Format / possible values**                  | **Description** |
|:-----------------:|:---------------------:|:---------------------------------------------:|:---------------:|
| Date of analysis         | Analysis_Formation              | dd.mm.yyyy hh:mm:ss                                           | ---             |


### Output data

#### Customers View

| **Field**                                     | **System field name**          | **Format / possible values**     | **Description**                                                                  |
|:---------------------------------------------:|:------------------------------:|:--------------------------------:|:-----------------------------------------------------------------------------:|
| Customer ID                                   | Customer_ID                    | ---                              | Unique value                                                                   |
| Value of the average check                    | Customer_Average_Check         | Arabic numeral, decimal          | Value of the average check in rubles for the analyzed period                 |
| Average check segment                         | Customer_Average_Check_Segment | High; Medium; Low                | Segment description                                                            |
| Transaction frequency value                   | Customer_Frequency             | Arabic numeral, decimal          | Value of customer visit frequency in the average number of days between transactions |
| Transaction frequency segment                 | Customer_Frequency_Segment     | Often; Occasionally; Rarely      | Segment description                                                            |
| Number of days since the previous transaction | Customer_Inactive_Period       | Arabic numeral, decimal          | Number of days passed since the previous transaction date               |
| Churn rate                                    | Customer_Churn_Rate            | Arabic numeral, decimal          | Value of the customer churn rate                                               |
| Churn rate segment                            | Customer_Churn_Segment         | High; Medium; Low                | Segment description                                                            |
| Segment number                                | Customer_Segment               | Arabic numeral                   | The number of the segment to which the customer belongs                        |
| Main  store ID                                | Customer_Primary_Store         | ---                              | ---                                                                            |

#### Purchase history View

| **Field**                       | **System field name**       | **Format / possible values**     | **Description**                                                       |
|:-------------------------------:|:---------------------------:|:--------------------------------:|:--------------------------------------------------------------------:|
| Customer ID                     | Customer_ID                 | ---                              | ---                                                                   |
| Transaction ID                  | Transaction_ID              | ---                              | ---                                                                   |
| Transaction date                | Transaction_DateTime        | dd.mm.yyyyy hh:mm:ss.0000000     | The date when the transaction was made                                                                                                                                                                                             |
| SKU group                       | Group_ID                    | ---                              | The ID of the group of related products to which the product belongs (for example, same type of yogurt of the same manufacturer and volume, but different flavors). One identifier is specified for all products in the group  |
| Prime cost                      | Group_Cost                  | Arabic numeral, decimal | ---                                                                                                                                                                                                                                         |
| Base retail price               | Group_Summ                  | Arabic numeral, decimal | ---                                                                                                                                                                                                                                         |
| Actual cost paid                | Group_Summ_Paid             | Arabic numeral, decimal | ---                                                                                                                                                                                                                                         |

#### Periods View

| **Field**                                     | **System field name**       | **Format / possible values**     | **Description**                                                                                                                                                                                                 |
|:---------------------------------------------:|:---------------------------:|:--------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| Customer ID                                   | Customer_ID                 | ---                              | ---                                                                                                                                                                                                          |
| SKU group                                     | Group_ID                    | ---                              | The ID of the group of related products to which the product belongs (for example, same type of yogurt of the same manufacturer and volume, but different flavors). One identifier is specified for all products in the group |
| Date of first purchase of the group           | First_Group_Purchase_Date   | yyyy-mm-dd hh:mm:ss.0000000      | ---                                                                                                                                                                                                          |
| Date of last purchase of the group            | Last_Group_Purchase_Date    | yyyy-mm-dd hh:mm:ss.0000000      | ---                                                                                                                                                                                                          |
| Number of transactions with the group         | Group_Purchase              | Arabic numeral, decimal          | ---                                                                                                                                                                                                          |
| Intensity of group purchases                  | Group_Frequency             | Arabic numeral, decimal          | ---                                                                                                                                                                                                          |
| Minimum group discount                        | Group_Min_Discount          | Arabic numeral, decimal | ---                                                                                                                                                                                                          |

#### Groups View

| **Field**                              | **System field name**       | **Format / possible values**     | **Description**                                                                                                                        |
|:--------------------------------------:|:---------------------------:|:--------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------:|
| Customer ID                            | Customer_ID                 | ---                              | ---                                                                                                                                 |
| Group ID                               | Group_ID                    | ---                              | ---                                                                                                                                 |
| Affinity index                         | Group_Affinity_Index        | Arabic numeral, decimal          | Customer affinity index for this group                                                                                 |
| Churn index                            | Group_Churn_Rate            | Arabic numeral, decimal          | Customer churn index for a specific group                                                                                          |
| Stability index                        | Group_Stability_Index       | Arabic numeral, decimal          | Indicator demonstrating the stability of the customer consumption of the group                                                                |
| Actual margin for the group            | Group_Margin                | Arabic numeral, decimal          | Indicator of the actual margin for the group for a particular customer                                                                       |
| Share of transactions with a discount  | Group_Discount_Share        | Arabic numeral, decimal          | Share of purchasing transactions of the group by a customer, within which the discount was applied (excluding the loyalty program bonuses) |
| Minimum size of the discount           | Group_Minimum_Discount      | Arabic numeral, decimal          | Minimum size of the group discount for the customer                                                                    |
| Average discount                       | Group_Average_Discount      | Arabic numeral, decimal          | Average size of the group discount for the customer                                                                                         |


## Chapter III

## Part 1. Creating a database

Write a *part1.sql* script that creates the database and tables described above in the [Input data](#input-data).

Also, add procedures to the script that allow you to import and export data for each table from/to a file with *.csv* and *.tsv* extensions. \
A separator is specified as a parameter of each procedure for importing from a *csv* file.

Enter at least 5 records in every table.
As you progress through the task, you will need new data to test all of your choices.
This new data should also be added to this script. \
Some test data could be found in the *datasets* folder.

If *csv* or *tsv* files were used to add data to the tables, they must also be uploaded to the GIT repository.

## Part 2. Creating views

Create a *part2.sql* script and write the views described above in the [Output data](#output-data). Also add test queries for each view. It is acceptable to create a separate script starting with *part2_* for each view.

You can find more information for each field in the materials.

## Part 3. Role model

Create roles in the *part3.sql* script and give them permissions as described below.

#### Administrator
The administrator has full permissions to edit and view any information, start and stop the processing.

#### Visitor
Only view information of all tables.

