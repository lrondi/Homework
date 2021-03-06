Attribute VB_Name = "Module1"
Sub StockVolume()
For Each ws In Worksheets
    
    Dim row As Integer
    Dim openValue As Double
    Dim closeValue As Double
    Dim yearlyChange As Double
    Dim percentChange As Double
    Dim Ticker As String
    
    ws.Range("I1").Value = "Ticker"
    ws.Range("J1").Value = "Yearly Change"
    ws.Range("K1").Value = "Percent Change"
    ws.Range("L1").Value = "Total Stock Volume"
        
    'variables definition
    lastRow = ws.Cells(Rows.Count, 1).End(xlUp).row
    row = 1
    totalVolume = 0
    openValue = ws.Cells(2, 3).Value 'first open value of table
    closeValue = 0
        
    'Total Volume, Yearly Change and Percent Change calculation
    For i = 2 To lastRow
        'if Ticker name is different than the previous one
        If ws.Cells(i, 1).Value <> ws.Cells(i - 1, 1).Value Then
        
            'store Ticker name and row in new table
            ws.Cells(row + 1, 9).Value = ws.Cells(i, 1).Value
            row = row + 1
            
                'calculation of closing value, yearly change and percent change from previous ticker
                If i > 2 Then
                    closeValue = ws.Cells(i - 1, 6).Value
                    yearlyChange = closeValue - openValue
                    ws.Cells(row - 1, 10).Value = yearlyChange
                    If openValue <> 0 Then
                        percentChange = yearlyChange / openValue
                        ws.Cells(row - 1, 11).Value = percentChange
                    Else
                        percentChange = 0
                        ws.Cells(row - 1, 11).Value = percentChange
                    End If
                    'print total Volume of previous Ticker
                    ws.Cells(row - 1, 12).Value = totalVolume
                End If
                
            'calculate new open Value for present Ticker with conditional for the ones that start at 0 and change later and the ones that stay at 0 for all year
            If ws.Cells(i, 3).Value <> 0 Then
                openValue = ws.Cells(i, 3).Value
            Else
                For j = 0 To 500 'arbitrary upper bond, iteration through present Ticker until first non-zero value is find
                    If ws.Cells(i + j, 3).Value <> 0 Then
                        'if Ticker name is the same, the open value is the first non-zero value found
                        If ws.Cells(i + j, 1).Value = ws.Cells(i, 1).Value Then
                            openValue = ws.Cells(i + j, 3).Value
                        'if Ticker name is diff, it means present Ticker has open value of 0 through all year, so take last zero value as open value
                        Else
                            openValue = ws.Cells(i + j - 1, 3).Value
                        End If
                        Exit For
                    End If
                Next j
            End If
            
            'set new initial Total volume as volume of present ticker
            totalVolume = ws.Cells(i, 7).Value
            
        Else
        'if ticker name is the same, add present volume to total volume
            totalVolume = totalVolume + ws.Cells(i, 7).Value
        End If
    
    Next i


    'Hard part

    ws.Range("N2").Value = "Greatest % Increase"
    ws.Range("N3").Value = "Greatest % Decrease"
    ws.Range("N4").Value = "Greatest Total Volume"
    ws.Range("O1").Value = "Ticker"
    ws.Range("P1").Value = "Value"
    lastTickerRow = ws.Cells(Rows.Count, 9).End(xlUp).row
    
    'max % Increase
    maxIncrease = WorksheetFunction.Max(ws.Range("K1:K" & lastTickerRow))
    ws.Range("P2").Value = maxIncrease
    ws.Range("P2").NumberFormat = "0.00%"

    'min % Increase
    minIncrease = WorksheetFunction.Min(ws.Range("K1:K" & lastTickerRow))
    ws.Range("P3").Value = minIncrease
    ws.Range("P3").NumberFormat = "0.00%"
    
    'max Volume
    maxVolume = WorksheetFunction.Max(ws.Range("L1:L" & lastTickerRow))
    ws.Range("P4").Value = maxVolume

    'search for ticker name for each value
    For i = 2 To lastTickerRow
        If ws.Cells(i, 12).Value = maxVolume Then
            Ticker = ws.Cells(i, 9).Value
            ws.Range("O4").Value = Ticker
        ElseIf ws.Cells(i, 11).Value = maxIncrease Then
            Ticker = ws.Cells(i, 9).Value
            ws.Range("O2").Value = Ticker
        ElseIf ws.Cells(i, 11).Value = minIncrease Then
            Ticker = ws.Cells(i, 9).Value
            ws.Range("O3").Value = Ticker
        End If
        'conditional formatting
        If ws.Cells(i, 10).Value >= 0 Then
            ws.Cells(i, 10).Interior.ColorIndex = 4
        Else
            ws.Cells(i, 10).Interior.ColorIndex = 3
        End If
        ws.Cells(i, 11).NumberFormat = "0.00%"
    Next i
    
Next ws

End Sub

