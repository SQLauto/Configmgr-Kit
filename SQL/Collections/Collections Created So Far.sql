SELECT     COUNT(RecordID) AS Count, 
                      CASE MessageID WHEN 30015 THEN 'Collections Created' WHEN 30016 THEN 'Collections Edited' WHEN 30017 THEN 'Collections Deleted' END AS Message
FROM         dbo.v_StatusMessage
WHERE     (MessageType = 768) AND (Component IN ('Microsoft.ConfigurationManagement.exe')) AND (DATEDIFF(m, Time, GETDATE()) < 1)
GROUP BY MessageID
HAVING      (MessageID BETWEEN 30015 AND 30017)

select top 20 * from  dbo.v_StatusMessage where MessageID=30015