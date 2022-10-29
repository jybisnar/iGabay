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
	Dim btnGenerateQr as Button
	Dim Main as ImageView
	Dim btnBack as Button
	Dim btnAddUser as Button
	Dim dtgUser as Table
	Dim lblUserData as Label
	Dim QPushButton9 as Button

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
	btnGenerateQr.Initialize("btnGenerateQr")
	Main.Initialize("Main")
	btnBack.Initialize("btnBack")
	btnAddUser.Initialize("btnAddUser")
	txtSearch.Initialize("txtSearch")
	dtgUser.Initialize(Me,"dtgUser",4)
	'dtgUser.LoadTableFromCSV(Dir, Filename, HeadersExist)
	'vb6.SetDataGrid(Activity,Main.SQL,dtgUser,"History")
	lblUserData.Initialize("lblUserData")
	QPushButton9.Initialize("QPushButton9")

End Sub

Public Sub DesignerCreateView (Base As Panel, Lbl As Label, Props As Map)
	mBase = Base
	GTKForms
End Sub
Public Sub GTKForms
	mBase.Color=0x000000'transparent background
	mBase.Width=100%x
	mBase.height=100%y
	mBase.AddView(btnGenerateQr,0.72 * mBase.Width,0.88 * mBase.Height,0.19 * mBase.Width,0.06 * mBase.Height)
	mBase.AddView(Main,0.00 * mBase.Width,0.00 * mBase.Height,1.00 * mBase.Width,1.00 * mBase.Height)
	Main.Bitmap = LoadBitmapResize(File.DirAssets,"joey2.png",Main.Width,Main.Height,true)
	mBase.AddView(btnBack,0.05 * mBase.Width,0.02 * mBase.Height,0.19 * mBase.Width,0.05 * mBase.Height)
	mBase.AddView(btnAddUser,0.76 * mBase.Width,0.02 * mBase.Height,0.19 * mBase.Width,0.05 * mBase.Height)
	dtgUser.AddToParent(mBase,0.05 * mBase.Width,0.18 * mBase.Height,0.91 * mBase.Width,0.44 * mBase.Height)
	'dtgUser.LoadTableFromCSV(File.DirAssets, "datus.csv", True)
	'dtgUser.SetDatagrid(Array As String ("A","B","C"),Array(Array As String("1","2","3"),Array As String("4","5","6")))
	lblUserData.Color =  0x00ffffff
	lblUserData.TextColor = 0xff000000
	lblUserData.Gravity = Gravity.Left
	lblUserData.Text = ""
	mBase.AddView(lblUserData,0.05 * mBase.Width,0.63 * mBase.Height,0.91 * mBase.Width,0.35 * mBase.Height)
	mBase.AddView(QPushButton9,0.73 * mBase.Width,0.89 * mBase.Height,0.19 * mBase.Width,0.06 * mBase.Height)

End Sub

'If SubExists(mCallBack,mEventName & "_" & "ExampleEvent") Then
'	CallSub2(mCallBack,mEventName & "_" & "ExampleEvent",123)
'End If
Sub btnGenerateQr_click()
End Sub
Sub Main_click()
End Sub
Sub btnBack_click()
End Sub
Sub btnAddUser_click()
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
Sub QPushButton9_click()
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
