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
	Dim Main as ImageView
	Dim btnBack as Button
	Dim btnAddUser as Button
	Dim ckYes as CheckBox
	Dim ckNo as CheckBox
	Dim txtName as EditText
	Dim txtAge as EditText

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
	Main.Initialize("Main")
	btnBack.Initialize("btnBack")
	btnAddUser.Initialize("btnAddUser")
	ckYes.Initialize("ckYes")
	ckNo.Initialize("ckNo")
	txtName.Initialize("txtName")
	txtAge.Initialize("txtAge")

End Sub

Public Sub DesignerCreateView (Base As Panel, Lbl As Label, Props As Map)
	mBase = Base
	GTKForms
End Sub
Public Sub GTKForms
	mBase.Color=0x000000'transparent background
	mBase.Width=100%x
	mBase.height=100%y
	mBase.AddView(Main,0.00 * mBase.Width,0.00 * mBase.Height,1.00 * mBase.Width,1.00 * mBase.Height)
	Main.Bitmap = LoadBitmapResize(File.DirAssets,"joey3.png",Main.Width,Main.Height,true)
	mBase.AddView(btnBack,0.05 * mBase.Width,0.02 * mBase.Height,0.19 * mBase.Width,0.05 * mBase.Height)
	mBase.AddView(btnAddUser,0.07 * mBase.Width,0.50 * mBase.Height,0.87 * mBase.Width,0.09 * mBase.Height)
	mBase.AddView(ckYes,0.20 * mBase.Width,0.38 * mBase.Height,0.24 * mBase.Width,0.05 * mBase.Height)
	ckYes.Text="False"
	mBase.AddView(ckNo,0.60 * mBase.Width,0.38 * mBase.Height,0.24 * mBase.Width,0.05 * mBase.Height)
	ckNo.Text="False"
	mBase.AddView(txtName,0.07 * mBase.Width,0.16 * mBase.Height,0.87 * mBase.Width,0.05 * mBase.Height)
	txtName.TextColor=colors.black
	mBase.AddView(txtAge,0.07 * mBase.Width,0.27 * mBase.Height,0.87 * mBase.Width,0.05 * mBase.Height)
	txtAge.TextColor=colors.black

End Sub

'If SubExists(mCallBack,mEventName & "_" & "ExampleEvent") Then
'	CallSub2(mCallBack,mEventName & "_" & "ExampleEvent",123)
'End If
Sub Main_click()
End Sub
Sub btnBack_click()
End Sub
Sub btnAddUser_click()
End Sub
Sub ckYes_CheckedChange(Checked As Boolean)
End Sub
Sub ckNo_CheckedChange(Checked As Boolean)
End Sub
Sub txtName_click()
End Sub
Sub txtAge_click()
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
