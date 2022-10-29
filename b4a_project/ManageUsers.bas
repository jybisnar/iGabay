B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8
@EndOfDesignText@
'Custom View class 
#Event: ExampleEvent (Value As Int)
#DesignerProperty: Key: BooleanExample, DisplayName: Boolean Example, FieldType: Boolean, DefaultValue: True, Description: Example of a boolean property.
#DesignerProperty: Key: IntExample, DisplayName: Int Example, FieldType: Int, DefaultValue: 10, MinRange: 0, MaxRange: 100, Description: Note that MinRange and MaxRange are optional.
#DesignerProperty: Key: StringWithListExample, DisplayName: String With List, FieldType: String, DefaultValue: Sunday, List: Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday
#DesignerProperty: Key: StringExample, DisplayName: String Example, FieldType: String, DefaultValue: Text
#DesignerProperty: Key: ColorExample, DisplayName: Color Example, FieldType: Color, DefaultValue: 0xFFCFDCDC, Description: You can use the built-in color picker to find the color values.
#DesignerProperty: Key: DefaultColorExample, DisplayName: Default Color Example, FieldType: Color, DefaultValue: Null, Description: Setting the default value to Null means that a nullable field will be displayed.
Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Private mBase As Panel
	Private Const DefaultColorConstant As Int = -984833 'ignore
	Dim img As ImageView
	Dim btnBack As Button
	Dim btnAddUser As Button
	Dim dtgUser As Table
	Dim lblUserData As Label
	Dim txtSearch As Label
	Dim genQR As Button
	'Dim QR As Label
	'Private qrcode As QRGenerator
	'Private ImvQR As B4XView
	'Private BmpQR, logo As B4XBitmap
	'Private xui As XUI
	Private DetailsDialog As CustomLayoutDialog
	Private DialogAge As Spinner
	Private DialogYesNO As Spinner
	Private DialogLastName As FloatLabeledEditText
	Private DialogFirstName As FloatLabeledEditText

End Sub
'clsTest.Initialize(Me, "clsTest")
'clsTest.AddToParent(Activity,0,0,100%x,100%y)
Public Sub AddToParent(Parent As Activity, Left As Int, Top As Int, Width As Int,Height As Int)
	mBase.Initialize("mBase")
	Parent.AddView(mBase, Left, Top, Width, Height)
	GTKForms
End Sub
Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
	img.Initialize("img")
	btnBack.Initialize("btnBack")
	btnAddUser.Initialize("btnAddUser")
	txtSearch.Initialize("txtSearch")
	dtgUser.Initialize(Me,"dtgUser",4)
	'dtgUser.LoadTableFromCSV(Dir, Filename, HeadersExist)
	'vb6.SetDataGrid(Activity,Main.SQL,dtgUser,"History")
	lblUserData.Initialize("lblUserData")
	genQR.Initialize("genQR")
	'Dim a As riddQR = Starter.riddQR1
	'qrcode.Initialize(a.qrc.Width)

End Sub

Public Sub DesignerCreateView (Base As Panel, Lbl As Label, Props As Map)
	mBase = Base
	GTKForms
End Sub
Public Sub GTKForms
	mBase.Color=0x000000'transparent background
	mBase.Width=100%x
	mBase.height=100%y
	mBase.AddView(img,0.00 * mBase.Width,0.00 * mBase.Height,1.00 * mBase.Width,1.00 * mBase.Height)
	img.Bitmap = LoadBitmapResize(File.DirAssets,"joey2.png",img.Width,img.Height,False)
	mBase.AddView(btnBack,0.05 * mBase.Width,0.02 * mBase.Height,0.19 * mBase.Width,0.05 * mBase.Height)
	btnBack.Text = "Back"
	btnBack.Color = 0xff000000
	mBase.AddView(btnAddUser,0.73 * mBase.Width,0.02 * mBase.Height,0.23 * mBase.Width,0.05 * mBase.Height)
	btnAddUser.Text = "Enroll a User"
	btnAddUser.Color = 0xff000000
	dtgUser.AddToParent(mBase,0.05 * mBase.Width,0.18 * mBase.Height,0.91 * mBase.Width,0.44 * mBase.Height)
	'dtgUser.LoadTableFromCSV(File.DirAssets, "datus.csv", True)
	'dtgUser.SetDatagrid(Array As String ("A","B","C"),Array(Array As String("1","2","3"),Array As String("4","5","6")))
	lblUserData.Color =  0x00ffffff
	lblUserData.TextColor = 0xff000000
	lblUserData.Gravity = Gravity.Left
	lblUserData.Text = ""
	mBase.AddView(lblUserData,0.05 * mBase.Width,0.63 * mBase.Height,0.91 * mBase.Width,0.35 * mBase.Height)
	txtSearch.Color =  0x00ffffff
	txtSearch.TextColor = 0xff000000
	txtSearch.Gravity = Gravity.Left
	txtSearch.Text = ""
	mBase.AddView(txtSearch,0.05 * mBase.Width,0.11 * mBase.Height,0.91 * mBase.Width,0.05 * mBase.Height)
	mBase.AddView(genQR,0.73 * mBase.Width,0.89 * mBase.Height,0.19 * mBase.Width,0.06 * mBase.Height)
	genQR.Text = "Generate QR"
	genQR.Color = 0xff000000

End Sub

'If SubExists(mCallBack,mEventName & "_" & "ExampleEvent") Then
'	CallSub2(mCallBack,mEventName & "_" & "ExampleEvent",123)
'End If
Sub Main_click()
End Sub
Sub btnBack_click()
	Dim xx As RiDDMain = Starter.RiDDMain1
	xx.Visible = True
	setVisible(False)
End Sub
Sub btnAddUser_click()
'	Dim aa As AddUser = Starter.AddUser1
'	aa.Visible = True
'	setVisible(False)
	Dim sf As Object = DetailsDialog.ShowAsync("Enroll a User:", "Ok", "Cancel", "", LoadBitmap(File.DirAssets, "form.png"), True)
	DetailsDialog.SetSize(100%x, 500dip)
	Wait For (sf) Dialog_Ready(pnl As Panel)
	pnl.LoadLayout("DetailsDialog")
	'0x00002000 = TYPE_TEXT_FLAG_CAP_WORDS (capitalize first character of each word)
	DialogFirstName.EditText.InputType = Bit.Or(0x00002000, DialogFirstName.EditText.InputType)
	DialogLastName.EditText.InputType = Bit.Or(0x00002000, DialogLastName.EditText.InputType)
	DialogAge.Add("")
	For i = 1 To 100
		DialogAge.Add(i)
	Next
	DialogYesNO.Add("")
'	DialogYesNO.Add("Lactating")
'	DialogYesNO.Add("Non-lactating")
	For i = 1 To 1
'		DialogYesNO.Add(i)
		DialogYesNO.Add("lactating")
		DialogYesNO.Add("non lactating")
	Next
	DetailsDialog.GetButton(DialogResponse.POSITIVE).Enabled = False
	Wait For (sf) Dialog_Result(res As Int)
	'force the keyboard to hide
	DialogFirstName.EditText.Enabled = False
	DialogLastName.EditText.Enabled = False
	If res = DialogResponse.POSITIVE Then
		ToastMessageShow($"${DialogFirstName.Text} ${DialogLastName.Text} is ${DialogAge.SelectedItem} years old and is a ${DialogYesNO.SelectedItem} person."$, True)
'		dito ung database prompt
	End If
End Sub

Sub DialogAge_ItemClick (Position As Int, Value As Object)
	CheckAllFieldsValid
End Sub

Sub DialogLastName_TextChanged (Old As String, New As String)
	CheckAllFieldsValid
End Sub

Sub DialogFirstName_TextChanged (Old As String, New As String)
	CheckAllFieldsValid
End Sub

Sub CheckAllFieldsValid
	Dim valid As Boolean = DialogYesNO.SelectedIndex > 0 And DialogAge.SelectedIndex > 0 And DialogFirstName.Text.Length > 0 And DialogLastName.Text.Length > 0
	DetailsDialog.GetButton(DialogResponse.POSITIVE).Enabled = valid
End Sub

Sub txtSearch_click()
End Sub
Sub dtgUser_CellClick (Col As Int, Row As Int)
	Log("CellClick: " & Col & " , " & Row)
	Dim val As String = dtgUser.GetValue(Col, Row)
	ToastMessageShow(val,False)
End Sub
Sub lblUserData_click()
End Sub
Sub genQR_click()
	Dim q As riddQR = Starter.riddQR1
	q.Visible = True
	setVisible(False)
'	BmpQR = qrcode.Create("https://www.google.com")
'	logo = xui.LoadBitmapResize(File.DirAssets,"RIDD PAGING.jpg",BmpQR.Width,BmpQR.height,True)
'	ImvQR.SetBitmap(qrcode.AddBitmap(BmpQR, logo, 255 * 50 / 100).Resize(ImvQR.Width, ImvQR.Height, True))
	'Log(255 * Value / 100)
End Sub

Public Sub getVisible() As Boolean
	Return mBase.Visible
End Sub
Public Sub setVisible(flag As Boolean)
	mBase.Visible=flag
End Sub
Public Sub SetLayout(Left As Int,Top As Int,Width As Int,Height As Int)
	mBase.SetLayout(Left,Top,Width,Height )
End Sub

Public Sub GetBase As Panel
	Return mBase
End Sub
