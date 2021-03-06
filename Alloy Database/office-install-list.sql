USE [ALLOYDB]
GO

SELECT
  [Product_Name] AS [Office Version],
  [Computer_Name] AS [Computer Name],
  [Full_Name] AS [Owner],
  [Last_Audit] AS [Last Audit]
FROM (
  SELECT * FROM (
         SELECT
           [Soft_Products].[Product_Name],
           [Computer_List_Active].[Computer_Name],
           [Persons].[Full_Name],
           [Detected_Software_Products].[First_Audit],
           [Detected_Software_Products].[Last_Audit],
           ROW_NUMBER()
           OVER ( PARTITION BY [Computer_List_Active].[Computer_Name]
             ORDER BY [Detected_Software_Products].[Last_Audit] DESC ) RowNum
         FROM [ALLOYDB].[dbo].[Detected_Software_Products]
           JOIN [Soft_Products] ON [Soft_Products].[ID] = [Detected_Software_Products].[Soft_Product_ID]
           JOIN [Computer_List_Active] ON [Computer_List_Active].[ID] = [Detected_Software_Products].[Object_ID]
           JOIN [Persons] ON [Persons].[ID] = [Computer_List_Active].[Owner_ID]
         WHERE ([Soft_Products].[Product_Name] LIKE '%Microsoft Office Professional%' OR
                [Soft_Products].[Product_Name] LIKE '%Microsoft Office Enterprise%')
       ) AS DerivedTable
  WHERE RowNum = 1
) AS TableData
ORDER BY [Last_Audit] DESC;
