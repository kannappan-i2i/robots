*** Settings ***
Documentation       Insert the sales data for the week and export it as PDF.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.HTTP
Library             RPA.Excel.Files
Library             RPA.Browser.Selenium
Library             RPA.PDF


*** Tasks ***
Insert the sales data for the week and export it as PDF.
    Open the internat website
    Log in
    Fill the form using data from excel file
    Download the Excel file
    Collect the Results
    Export the table as PDF
    Log out and close the browser
    [Teardown]    Log out and close the browser


*** Keywords ***
Open the internat website
    Open Available Browser    https://robotsparebinindustries.com

Log in
    Input Text    username    maria
    Input Text    password    thoushallnotpass
    Submit Form
    Wait Until Page Contains Element    id:sales-form

Download the Excel file
    Download    https://robotsparebinindustries.com/SalesData.xlsx    overwrite=True

Fill the form using data from excel file
    Open Workbook    SalesData.xlsx
    ${sales_rep}=    Read Worksheet As Table    header=True
    Close Workbook
    FOR    ${sales_rep}    IN    @{sales_rep}
        Fill and submit the form    ${sales_rep}
    END

Fill and submit the form
    [Arguments]    ${sales_rep}
    Input Text    firstname    ${sales_rep}[First Name]
    Input Text    lastname    ${sales_rep}[Last Name]
    Input Text    salesresult    ${sales_rep}[Sales]
    Select From List By Value    salestarget    ${sales_rep}[Sales Target]
    Click Button    Submit

Collect the Results
    Screenshot    css:div.sales-summary    ${OUTPUT_DIR}${/}sales_summary.png

Export the table as PDF
    Wait Until Element Is Visible    id:sales-results
    ${sales_results_html}=    Get Element Attribute    id:sales-results    outerHTML
    Html To Pdf    ${sales_results_html}    ${OUTPUT_DIR}${/}sales_results.pdf

Log out and close the browser
    Click Button    Log out
    Close Browser
