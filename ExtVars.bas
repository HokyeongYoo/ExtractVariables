Attribute VB_Name = "Module1"
Option Explicit


Public Sub ExtractVars()
    
    Dim fnr As Integer
    Dim BASFileName As String
    
    Dim RecData As String
    Dim TRecData As String
    Dim SRecData() As String
    Dim RecDataSaved As String
    
    Dim i As Long
    Dim j As Long
    Dim k As Long, l As Long
    Dim h As Long
    
    Dim idx As Long
    ReDim VarArray(1) As String
    Dim UArray As Variant
    Dim ArrCount As Long
    Dim Flag As Long
    
    Dim strFileToOpen As Variant
    
    Dim KeywordRec(2) As String
    ReDim KeyWord(0) As String
    ReDim KeyWordLen(0) As Long
    Dim ExceptFlag As Boolean
    
    'File Dialog
    strFileToOpen = Application.GetOpenFilename _
    (Title:="Please choose a file to open", _
    FileFilter:="VBA Code Files *.bas (*.bas),")
    
    '���õ� ����(��� ����)�� ����
    If strFileToOpen <> "" And strFileToOpen <> False Then
        BASFileName = strFileToOpen
    Else
        Exit Sub
    End If
    
    Worksheets("Temp").Range("A:XFD").ClearContents
    Worksheets("Temp2").Range("A:XFD").ClearContents
    
    fnr = FreeFile()
    k = 1
    idx = 0
    
    i = 0
    
    Open ThisWorkbook.Path & "\VBAKeywords.txt" For Input As #fnr
    
    Do While Not EOF(fnr)
        
        ReDim Preserve KeyWord(i)
        ReDim Preserve KeyWordLen(i)
        
        Line Input #fnr, RecData
        
        KeyWord(i) = RecData
        KeyWordLen(i) = Len(KeyWord(i))
        
        i = i + 1
        
    Loop
    
    Close #fnr
    
    i = 0
    
    fnr = FreeFile()
    Open BASFileName For Input As #fnr
    
    Do While Not EOF(fnr)
        
        Line Input #fnr, RecData
        
        '��ɾ� �޺κ�(������)�� ��ġ�� �ּ� ������ ���� ó��
        If InStr(RecData, "'") > 0 Then RecData = Left(RecData, InStr(RecData, "'") - 1)
        
        '���� ������ ū ����ǥ�� �ش��ϴ� �κ��� ��� ���� ó��
        Do While InStr(RecData, """") > 0
            RecData = Left(RecData, InStr(RecData, """") - 1) & Right(RecData, Len(RecData) - InStr(InStr(RecData, """") + 1, RecData, """"))
        Loop
        
        'tab ���ڰ� �ִ� ��� trim ó���� �ǵ��� ��� ���� �ʱ� ������ tab ���ڸ� ��� ����
        RecData = Replace(RecData, vbTab, "")
        
        '������ �� ���� �ִ� blank �� ��� ����
        RecData = Trim(RecData)
        
        'trim ó�� �� ���� ���� underline �� �ִ� ��쿡 ���� ó���� �ѱ�
        If Right(RecData, 1) = "_" Then
            RecDataSaved = RecDataSaved & Left(RecData, Len(RecData) - 1)
        Else
            RecData = RecDataSaved & RecData

            i = 2
            
            '======================================================================================================================================================
            '* �迭 �Ķ���� üũ ����
            '======================================================================================================================================================
            '���� ��ȣ ���� ���� ����
            If InStr(RecData, "(") > 0 Then
                
                '���� ���� ��ġ ���Ŀ� ���� ��ȣ�� �ִ� ���� ��� ����
                Do While InStr(i, RecData, "(") > 1
                    
                    '���� ��ȣ ���� ���ڰ� ������ �ƴ� ���, ��, �迭(������ �Լ��� ���ν����� �� ���� ����)�� �ǴܵǴ� ��쿡 ����
                    If Mid(RecData, i, 1) = "(" And Mid(RecData, i - 1, 1) <> " " Then
                        
                        ArrCount = 0
                        Flag = 1
                        
                        '���� ��ȣ ���� ��ġ���� ó������ �޸��� ������ ��ġ���� �ݺ�
                        j = i + 1
                        Do While Flag > 0
                            If Mid(RecData, j, 1) = "(" Then
                                Flag = Flag + 1
                            ElseIf Mid(RecData, j, 1) = ")" Then
                                Flag = Flag - 1
                            ElseIf Mid(RecData, j, 1) = "," And Flag = 1 Then
                                ArrCount = ArrCount + 1
                            End If
                            j = j + 1
                        Loop
                        
                        'MsgBox ArrCount + 1 & "���� ���ڸ� ������ �ֽ��ϴ�."
                        RecData = Left(RecData, i - 1) & "_" & CStr(ArrCount + 1) & "�����迭 " & Right(RecData, Len(RecData) - i)
                        
                    End If
                    
                    i = i + 1
                    
                Loop
                
            End If
            '======================================================================================================================================================
            '* �迭 �Ķ���� üũ ��
            '======================================================================================================================================================
            
            TRecData = RecData
        
            '������ �� �տ� �� �� �ִ� ��ɾ� �������� �Ľ� ��� ����
            If TRecData <> "" And _
            Left(TRecData, 1) <> "'" And _
            Left(TRecData, 9) <> "Attribute" And _
            Left(TRecData, 6) <> "Option" And _
            Left(TRecData, 3) <> "Sub" And _
            Left(TRecData, 6) <> "Public" And _
            Left(TRecData, 4) <> "Call" Then
                
                i = i + 1
                
                '�޸� ���� ����
                TRecData = Replace(TRecData, ", ", " ")
                
                '�� �ٿ� �� �� �̻� ��ɾ� �Էµ� �� ����
                TRecData = Replace(TRecData, ":", "")
                
                'ū ����ǥ �������� ġȯ -> ū ����ǥ ���� ������ ��� ���� ó�� �ʿ�
                'TRecData = Replace(TRecData, """", "")
                
                '���� ��ȣ �տ� ������ �ִ� ���� �迭 ��ȣ�� �ƴ϶� �������� ġȯ
                TRecData = Replace(TRecData, " (", " ")
                
                '���� ��ȣ�� ����
                TRecData = Replace(TRecData, ")", "")
                
                '���� ���� ��ȣ�� �迭 ��ȣ�� �����Ͽ� �������� ġȯ - �̷��� ó���ϸ� �迭 ���� ���� �Ұ�
                'TRecData = Replace(TRecData, "(", "[Array] ")
                
                '�迭 ���𿡼� ���Ǵ� "To" �κ��� �������� ġȯ
                TRecData = Replace(TRecData, " To ", " ")
                
                'TRecData = Replace(TRecData, " ", "")
                
                '������ �� �� �̻� �����ϴ� ��� �ϳ��� ġȯ
                Do While InStr(TRecData, "  ") > 0
                    TRecData = Replace(TRecData, "  ", " ")
                Loop
                
                '�ٽ� �ѹ� ���� �� ���� ����
                TRecData = Trim(TRecData)
                
                '���� �������� ���ڿ� ����
                SRecData = Split(TRecData, " ")
                
                j = 0
                l = 0
                
                Do While j <= UBound(SRecData)
                    
                    ExceptFlag = False
                    j = j + 1
                    
                    For h = 0 To UBound(KeyWord)
                        If UCase(Left(SRecData(j - 1), KeyWordLen(h))) = UCase(KeyWord(h)) Then
                            ExceptFlag = True
                        End If
                    Next h
                    
                    If ExceptFlag = False And _
                    ((Asc(Left(SRecData(j - 1), 1)) >= 65 And Asc(Left(SRecData(j - 1), 1)) <= 90) Or (Asc(Left(SRecData(j - 1), 1)) >= 97 And Asc(Left(SRecData(j - 1), 1)) <= 122)) Then
                        l = l + 1
                        Worksheets("Temp").Cells(k, l) = SRecData(j - 1)
                        ReDim Preserve VarArray(idx + 1)
                        VarArray(idx) = SRecData(j - 1)
                        idx = idx + 1
                    End If
                    
                Loop
                
                If l > 0 Then k = k + 1
                
            End If
            RecDataSaved = ""
        End If
        
    Loop
    
    Close #fnr
    
    For i = 1 To UBound(VarArray)
        Worksheets("Temp2").Cells(i, 1) = VarArray(i - 1)
    Next i
    
    UArray = ArrayUnique(VarArray)
    
    For i = 1 To UBound(UArray)
        Worksheets("Temp2").Cells(i, 2) = UArray(i - 1)
    Next i
    
End Sub
