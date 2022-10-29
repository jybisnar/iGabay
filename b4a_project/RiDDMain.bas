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
	Dim btnManageUser As Button
	Dim QFrame4 As Panel
	Dim QFrame5 As Panel
	Dim QFrame6 As Panel
	'Dim img1 As BitmapDrawable

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
	btnManageUser.Initialize("btnManageUser")
	QFrame4.Initialize("QFrame4")
	QFrame5.Initialize("QFrame5")
	QFrame6.Initialize("QFrame6")
	'img1.Initialize(LoadBitmap(File.DirAssets, "plus.png"))
	'img1.Gravity = Gravity.FILL

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
	img.Bitmap = LoadBitmapResize(File.DirAssets,"joey1.png",img.Width,img.Height,False)
	mBase.AddView(btnManageUser,0.62 * mBase.Width,0.02 * mBase.Height,0.30 * mBase.Width,0.05 * mBase.Height)
	btnManageUser.Text = "Manage Users"
	btnManageUser.Color = 0xff000000
	'btnManageUser.SetBackgroundImage(LoadBitmap(File.DirAssets, "plus.png"))
	'btnManageUser.Gravity = Gravity.CENTER
	mBase.AddView(QFrame4,0.07 * mBase.Width,0.13 * mBase.Height,0.85 * mBase.Width,0.16 * mBase.Height)
	QFrame4.Color =  0x00ffffff
	mBase.AddView(QFrame5,0.08 * mBase.Width,0.37 * mBase.Height,0.84 * mBase.Width,0.22 * mBase.Height)
	QFrame5.Color =  0x00ffffff
	mBase.AddView(QFrame6,0.08 * mBase.Width,0.67 * mBase.Height,0.84 * mBase.Width,0.29 * mBase.Height)
	QFrame6.Color =  0x00ffffff

End Sub

'If SubExists(mCallBack,mEventName & "_" & "ExampleEvent") Then
'	CallSub2(mCallBack,mEventName & "_" & "ExampleEvent",123)
'End If
Sub img_click()
End Sub
Sub btnManageUser_click()
	Dim xx As ManageUsers = Starter.ManageUsers1
	xx.Visible = True
	setVisible(False)
End Sub
Sub QFrame4_click()
End Sub
Sub QFrame5_click()
End Sub
Sub QFrame6_click()
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
