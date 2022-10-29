B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=6.28
@EndOfDesignText@
'version 1.11
Sub Class_Globals
	Private xui As XUI
	Public cvs As B4XCanvas
	Private ModuleSize As Int
	Private const QRVersion As Int = 4
	Private GFSize As Int = 256
	Private ExpTable(GFSize) As Int
	Private LogTable(GFSize) As Int
	Private PolyZero() As Int = Array As Int(0)
	Private Generator4L() As Int = Array As Int(1, 152, 185, 240, 5, 111, 99, 6, 220, 112, 150, 69, 36, 187, 22, 228, 198, 121, 121, 165, 174) '4L
	Private Generator4H() As Int = Array As Int(1, 59, 13, 104, 189, 68, 209, 30, 8, 163, 65, 41, 229, 98, 50, 36, 59)
	Private TempBB As joeBytes
	Private Matrix(0, 0) As Boolean
	Private Reserved(0, 0) As Boolean
	Private NumberOfModules As Int
End Sub

Public Sub Initialize (BitmapSize As Int)
	TempBB.Initialize
	NumberOfModules = 17 + QRVersion * 4
	ModuleSize = BitmapSize / (NumberOfModules + 8)
	PrepareTables
	BitmapSize = ModuleSize * (NumberOfModules + 8)
	
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, BitmapSize, BitmapSize)
	cvs.Initialize(p)
End Sub

Public Sub Create(Text As String) As B4XBitmap
	Dim Bytes() As Byte = Text.GetBytes("utf8") 'non-standard but still recommended
	If Bytes.Length > 78 Then
		Log("Too long!")
		Return Null
	End If
	Dim V_4H As Boolean = Bytes.Length <= 36
	If V_4H Then
		Log("Version 4-H")
	Else
		Log("Version 4-L")
	End If
	Dim Matrix(NumberOfModules, NumberOfModules) As Boolean
	Dim Reserved(NumberOfModules, NumberOfModules) As Boolean
	
	Dim Mode() As Byte = Array As Byte(0, 1, 0, 0) 'byte mode
	Dim ContentCountIndicator() As Byte = UnsignedByteToBits(Bytes.Length)
	Dim EncodedData As joeBytes
	EncodedData.Initialize
	EncodedData.Append(Mode)
	EncodedData.Append(ContentCountIndicator)
	For Each b As Byte In Bytes
		EncodedData.Append(UnsignedByteToBits(Bit.And(0xff, b)))
	Next
	'add terminator
	Dim MaxSize As Int
	If V_4H Then MaxSize = 36 * 8 Else MaxSize = 80 * 8
	Dim PadSize As Int = Min(4, MaxSize - EncodedData.Length)
	Dim pad(PadSize) As Byte
	EncodedData.Append(pad)
	Do While EncodedData.Length Mod 8 <> 0 
		EncodedData.Append(Array As Byte(0))
	Loop
	
	Do While EncodedData.Length < MaxSize
		EncodedData.Append(Array As Byte(1,1,1,0,1,1,0,0))
		If EncodedData.Length < MaxSize Then EncodedData.Append(Array As Byte(0,0,0,1,0,0,0,1))
	Loop
	If V_4H Then
		Version4H(EncodedData)
	Else
		Version4L(EncodedData)
	End If
	AddFinders
	AddDataToMatrix(EncodedData.ToArray, V_4H)
	DrawMatrix
	cvs.Invalidate
	Return cvs.CreateBitmap
End Sub

Private Sub Version4H (EncodedData As joeBytes)
	Dim ecs As List
	ecs.Initialize
	Dim dataBlocks As List
	dataBlocks.Initialize
	For block1 = 0 To 3
		Dim Data() As Byte = EncodedData.SubArray2(block1 * 9 * 8, (block1 + 1) * 9 * 8)
		Dim DataAsInts(Data.Length / 8) As Int
		Dim i As Int
		For i = 0 To Data.Length - 1 Step 8
			DataAsInts(i / 8) = BitsToUnsignedByte(Data, i)
		Next
		dataBlocks.Add(DataAsInts)
		Dim ec() As Int = CalcReedSolomon(DataAsInts, Generator4H)
		If ec.Length < Generator4H.Length - 1 Then
			Dim ec2(Generator4H.Length - 1) As Int
			IntArrayCopy(ec, 0, ec2,  Generator4H.Length - 1 - ec.Length, ec.Length)
			ec = ec2
		End If
		ecs.Add(ec)
	Next
	Dim Interleaved As joeBytes
	Interleaved.Initialize
	For i = 0 To 8
		For block1 = 0 To 3
			Dim ii() As Int = dataBlocks.Get(block1)
			Interleaved.Append(UnsignedByteToBits(ii(i)))
		Next
	Next
	For i = 0 To 15
		For block1 = 0 To 3
			Dim ii() As Int = ecs.Get(block1)
			Interleaved.Append(UnsignedByteToBits(ii(i)))
		Next
	Next
	Dim Pad(7) As Byte
	Interleaved.Append(Pad)
	EncodedData.Clear
	EncodedData.Append(Interleaved.ToArray)
End Sub

Private Sub Version4L (EncodedData As joeBytes)
	Dim Data() As Byte = EncodedData.ToArray
	Dim DataAsInts(Data.Length / 8) As Int
	Dim i As Int
	For i = 0 To Data.Length - 1 Step 8
		DataAsInts(i / 8) = BitsToUnsignedByte(Data, i)
	Next
	Dim ec() As Int = CalcReedSolomon(DataAsInts, Generator4L)
	Dim pad(8 * (Generator4L.Length - 1 - ec.Length)) As Byte
	EncodedData.Append(pad)
	For Each i As Int In ec
		EncodedData.Append(UnsignedByteToBits(i))
	Next
End Sub

Private Sub AddDataToMatrix (Encoded() As Byte, Ver4H As Boolean)
	Dim order As List = CreateOrder
	'mask 0: (row + column) mod 2 == 0
	For Each b As Byte In Encoded
		Dim xy() As Int = GetNextPosition(order)
		Matrix(xy(0), xy(1)) = (b = 1)
		If (xy(1) + xy(0)) Mod 2 = 0 Then Matrix(xy(0), xy(1)) = Not(Matrix(xy(0), xy(1)))
	Next
	If Ver4H Then
		Dim format() As Byte = Array As Byte(0,0,1,0,1,1,0,1,0,0,0,1,0,0,1) 'H0
	Else
		Dim format() As Byte = Array As Byte(1,1,1,0,1,1,1,1,1,0,0,0,1,0,0) 'L0
	End If
	For i = 0 To 5
		Matrix(i, 8) = format(i) = 1
		Matrix(8, NumberOfModules - 1 - i) = format(i) = 1
	Next
	Matrix(7, 8) = format(6) = 1
	Matrix(8, NumberOfModules - 1 - 6) = format(6) = 1
	Matrix(8, 8) = format(7) = 1
	Matrix(8, 7) = format(8) = 1
	For i = 0 To 5
		Matrix(8, 5 - i) = format(i + 9) = 1
	Next
	For i = 0 To 7
		Matrix(NumberOfModules - 1 - 7 + i, 8) = format(7 + i) = 1
	Next
	
End Sub

Private Sub GetNextPosition (order As List) As Int()
	Do While True
		Dim xy() As Int = order.Get(0)
		order.RemoveAt(0)
		If Reserved(xy(0), xy(1)) = False Then Return xy
	Loop
	Return Null
End Sub

Private Sub CreateOrder As List
	Dim Order As List
	Order.Initialize
	Dim x As Int = NumberOfModules - 1
	Dim y As Int = NumberOfModules - 1
	Dim dy As Int = -1
	Do While x >= 0 And y >= 0
		Order.Add(Array As Int(x, y))
		Order.Add(Array As Int(x - 1, y))
		y = y + dy
		If y = -1 Then
			x = x - 2
			y = 0
			dy = 1
		Else If y = NumberOfModules Then
			x = x - 2
			y = NumberOfModules - 1
			dy = -1
		End If
		If x = 6 Then x = x - 1
	Loop
	Return Order
End Sub

Private Sub DrawMatrix
	cvs.DrawRect(cvs.TargetRect, xui.Color_White, True, 0)
	Dim r As B4XRect
	For y = 0 To NumberOfModules - 1
		For x = 0 To NumberOfModules - 1
			r.Initialize((x + 4) * ModuleSize, (y + 4) * ModuleSize, 0, 0)
			r.Width = ModuleSize 
			r.Height = ModuleSize
			Dim clr As Int
			If Matrix(x, y) Then 
				clr = xui.Color_Black
				'cvs.DrawCircle(r.CenterX, r.CenterY, r.Width / 2, clr, True, 0)
				cvs.DrawRect(r, clr, True, 0)
			End If
		Next
	Next
End Sub

Private Sub BitsToUnsignedByte (b() As Byte, Offset As Int) As Int
	Dim res As Int
	For i = 0 To 7
		Dim x As Int = Bit.ShiftLeft(1, 7 - i)
		res = res + b(i + Offset) * x
	Next
	Return res
End Sub

Private Sub UnsignedByteToBits (Value As Int) As Byte()
	TempBB.Clear
	For i = 7 To 0 Step - 1
		Dim x As Int = Bit.ShiftLeft(1, i)
		Dim ii As Int = Bit.And(Value, x)
		If ii <> 0 Then
			TempBB.Append(Array As Byte(1))
		Else
			TempBB.Append(Array As Byte(0))
		End If
	Next

	Return TempBB.ToArray
End Sub

Private Sub AddFinders
	AddFinder(0, 0, 6)
	AddFinder(NumberOfModules - 7, 0, 6)
	AddFinder(0, NumberOfModules - 7, 6)
	'6 / 26
	AddFinder(26 - 2, 26 - 2, 4)
	
	For i = 8 To NumberOfModules - 8
		Matrix(i, 6) = (i Mod 2 = 0)
		Matrix(6, i) = (i Mod 2 = 0)
		Reserved(i, 6) = True
		Reserved(6, i) = True
	Next
	Matrix(8, NumberOfModules - 1 - 7) = True
	Reserved(8, NumberOfModules - 1 - 7) = True
	For i = 0 To 7
		Reserved(7, i) = True
		Reserved(7, NumberOfModules - 1 - i) = True
		Reserved(8, NumberOfModules - 1 - i) = True
		Reserved(NumberOfModules -1 - 7, i) = True
		Reserved(i, 7) = True
		Reserved(i,NumberOfModules -1 - 7) = True
		Reserved(NumberOfModules -1 - i, 7) = True
		Reserved(NumberOfModules -1 - i, 8) = True
	Next
	For i = 0 To 8
		Reserved(8, i) = True
		Reserved(i, 8) = True
	Next
End Sub

Private Sub AddFinder (Left As Int, Top As Int, SizeMinOne As Int)
	For y = 0 To SizeMinOne
		For x = 0 To SizeMinOne
			Dim value As Boolean
			If x = 0 Or x = SizeMinOne Or y = 0 Or y = SizeMinOne Then
				value = True
			Else if x <> 1 And y <> 1 And x <> SizeMinOne - 1 And y <> SizeMinOne - 1 Then
				value = True
			End If
			Matrix(Left + x, Top + y) = value
			Reserved(Left + x, Top + y) = True
		Next
	Next
End Sub

#Region ReedSolomon

Private Sub CalcReedSolomon (Input() As Int, Generator() As Int) As Int()
	Dim ecBytes As Int = Generator.Length - 1
	Dim InfoCoefficients(Input.Length) As Int
	IntArrayCopy(Input, 0, InfoCoefficients, 0, Input.Length)
	InfoCoefficients = CreateGFPoly(InfoCoefficients)
	InfoCoefficients = PolyMultiplyByMonomial(InfoCoefficients, ecBytes, 1)
	Dim remainder() As Int = PolyDivide(InfoCoefficients, Generator)
	Return remainder
End Sub


Private Sub PrepareTables
	Dim x = 1 As Int
	Dim Primitive As Int = 285
	For i = 0 To GFSize - 1
		ExpTable(i) = x
		x = x * 2
		If x >= GFSize Then
			x = Bit.Xor(Primitive, x)
			x = Bit.And(GFSize - 1, x)
		End If
	Next
	For i = 0 To GFSize - 2
		LogTable(ExpTable(i)) = i
	Next
End Sub

Private Sub CreateGFPoly(Coefficients() As Int) As Int()
	If Coefficients.Length > 1 And Coefficients(0) = 0 Then
		Dim FirstNonZero As Int = 1
		Do While FirstNonZero < Coefficients.Length And Coefficients(FirstNonZero) = 0
			FirstNonZero = FirstNonZero + 1
		Loop
		If FirstNonZero = Coefficients.Length Then
			Return Array As Int(0)
		End If
		Dim res(Coefficients.Length - FirstNonZero) As Int
		IntArrayCopy(Coefficients, FirstNonZero, res, 0, res.Length)
		Return res
	End If
	Return Coefficients
End Sub

Private Sub PolyAddOrSubtract(This() As Int, Other() As Int) As Int()
	If This(0) = 0 Then Return Other
	If Other(0) = 0 Then Return This
	Dim Small() As Int = This
	Dim Large() As Int = Other
	If Small.Length > Large.Length Then
		Dim temp() As Int = Small
		Small = Large
		Large = temp
	End If
	Dim SumDiff(Large.Length) As Int
	Dim LengthDiff As Int = Large.Length - Small.Length
	IntArrayCopy(Large, 0, SumDiff, 0, LengthDiff)
	For i = LengthDiff To Large.Length - 1
		SumDiff(i) = Bit.Xor(Small(i - LengthDiff), Large(i))
	Next
	Return CreateGFPoly(SumDiff)
End Sub

Private Sub IntArrayCopy(Src() As Int, SrcOffset As Int, Dest() As Int, DestOffset As Int, Count As Int)
	For i = 0 To Count - 1
		Dest(DestOffset + i) = Src(SrcOffset + i)
	Next
End Sub

Private Sub PolyMultiplyByMonomial (This() As Int, Degree As Int, Coefficient As Int) As Int()
	If Coefficient = 0 Then Return PolyZero
	Dim product(This.Length + Degree) As Int
	For i = 0 To This.Length - 1
		product(i) = GFMultiply(This(i), Coefficient)
	Next
	Return CreateGFPoly(product)
End Sub

Private Sub PolyDivide (This() As Int, Other() As Int) As Int()
	Dim quotient() As Int = PolyZero
	Dim remainder() As Int = This
	Dim denominatorLeadingTerm As Int = Other(0)
	Dim inverseDenominatorLeadingTerm As Int = GFInverse(denominatorLeadingTerm)
	Do While remainder.Length >= Other.Length And remainder(0) <> 0
		Dim DegreeDifference As Int = remainder.Length - Other.Length
		Dim scale As Int = GFMultiply(remainder(0), inverseDenominatorLeadingTerm)
		Dim term() As Int = PolyMultiplyByMonomial(Other, DegreeDifference, scale)
		Dim iterationQuotient() As Int = GFBuildMonomial(DegreeDifference, scale)
		quotient = PolyAddOrSubtract(quotient, iterationQuotient)
		remainder = PolyAddOrSubtract(remainder, term)
	Loop
	Return remainder
End Sub

Private Sub GFInverse(a As Int) As Int
	Return ExpTable(GFSize - LogTable(a) - 1)
End Sub

Private Sub GFMultiply(a As Int, b As Int) As Int
	If a = 0 Or b = 0 Then
		Return 0
	End If
	Return ExpTable((LogTable(a) + LogTable(b)) Mod (GFSize - 1))
End Sub

Private Sub GFBuildMonomial(Degree As Int, Coefficient As Int) As Int()
	If Coefficient = 0 Then Return PolyZero
	Dim c(Degree + 1) As Int
	c(0) = Coefficient
	Return c
End Sub

Public Sub AddBitmap(QRBmp As B4XBitmap, logo As B4XBitmap, Alpha As Int) As B4XBitmap
	Dim bc As BitmapCreator
	bc.Initialize(QRBmp.Width, QRBmp.Height)
	bc.CopyPixelsFromBitmap(QRBmp)
	Dim LogoBC As BitmapCreator
	LogoBC.Initialize(QRBmp.Width, QRBmp.Height)
	LogoBC.CopyPixelsFromBitmap(logo)
	Dim argb, largb As ARGBColor
	For x = 0 To bc.mWidth - 1
		For y = 0 To bc.mHeight - 1
			bc.GetARGB(x, y, argb)
			LogoBC.GetARGB(x, y, largb)
			If largb.a > 0 Then
				largb.a = Alpha
				LogoBC.SetARGB(x, y, largb)
				bc.BlendPixel(LogoBC, x, y, x, y)
			End If
		Next
	Next
	Return bc.Bitmap
End Sub

Private Sub LogArray(arr As List) 'ignore
	Log(arr)
End Sub

#End Region