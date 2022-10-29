from PyQt5 import QtCore, QtWidgets
from PyQt5.QtGui import * 
from wired_module import * 
import cv2
#	Generated By WiredQT for Python: by Rocky Nuarin, 2021 Phils
class Handler(QtWidgets.QWidget,usercontrol):
	def __init__(self, *param):    
		super(Handler, self).__init__(None)
		initUI(self,param,w=640,h=550,title="WiredQTv5.0",controlbox=True,startpos=(0,30),timeoutdestroy=-1)
		self.GTKForms()
		self.timer=QtCore.QTimer()
		self.timer.timeout.connect(self.loop)
		self.timer.start(10)       

		self.sch=Scheduler(5000)#500 ms
		self.sch.Start()
		
	def createwidget(self,prop,control,parent,event=[]):
		createWidget(self,prop,control,parent,event)         
	def GTKForms(self):
		self.createwidget("{'Name': 'WebCam0', 'Var': '', 'Font': '', 'Enable': 'True', 'Top': '7', 'Width': '302', 'ParentsType': '', 'Picture': '', 'ForeColor': '(0,0,0,1)', 'Visible': 'True', 'BackColor': '(1,1,1,0.25)', 'Events': [[['frameReady', 'self,arg1']]], 'Height': '218', 'Left': '10', 'Tag': 'Activex', 'Text': '', 'Help': '', 'Open': 'False', 'camindex': '1'}",'WebCam','usercontrol',"[['frameReady', 'self,arg1']]")
		self.createwidget("{'Name': 'QPushButton1', 'Var': '', 'Font': '', 'Enable': 'True', 'Top': '309', 'Width': '93', 'ParentsType': '', 'Picture': '', 'ForeColor': '(0,0,0,1)', 'Visible': 'True', 'BackColor': '(1,1,1,0.25)', 'Events': '[released]', 'Height': '30', 'Left': '10', 'Tag': '', 'Text': 'Start', 'Help': ''}",'QPushButton','usercontrol',"[['released', 'self']]")
		self.createwidget("{'Name': 'QPushButton2', 'Var': '', 'Font': '', 'Enable': 'True', 'Top': '308', 'Width': '100', 'ParentsType': '', 'Picture': '', 'ForeColor': '(0,0,0,1)', 'Visible': 'True', 'BackColor': '(1,1,1,0.25)', 'Events': '[clicked]', 'Height': '28', 'Left': '109', 'Tag': '', 'Text': 'Capture and save', 'Help': ''}",'QPushButton','usercontrol',"[['clicked', 'self,arg1']]")
	def Widget(self):
		return self    
	def loop(self):
		if self.form_load==False:
			self.form_load=True
		if self.sch.Event():#timer routine
			#code here
			if self.timeoutdestroy!=-1:
				self.timeoutdestroy-=1
				if self.timeoutdestroy==0:
					pass#self.unload(None)
			self.sch.Start()#restart scheduler      
		
	def connect(self,ev,evusr):
		self.wiredevents.update({ev:evusr})     
	def activeXcreated(self,*args):
		pass    
	def eventFilter(self, obj, event):
		return super(Handler, self).eventFilter(obj, event)
	
	def WebCam0_frameReady(self,arg1):
		arg2=cv2.resize(arg1,(self.WebCam0.Width,self.WebCam0.Height))	
		self.WebCam0.imshow(arg2)		
		self.frame=arg1
	def QPushButton1_released(self):
		self.WebCam0.Open=True
		pass
	def QPushButton2_clicked(self,arg1):
		fname=app_path() + "/images/" + CreateFileName() + ".jpg"# save as datetime.jpg
		cv2.imwrite(fname,self.frame)
		pass
if __name__ == '__main__':
	import sys
	app = QtWidgets.QApplication(sys.argv)
	w = Handler()
	w.show()
	sys.exit(app.exec_())
