from PyQt5 import QtCore, QtWidgets
from PyQt5.QtGui import * 
from wired_module import * 
tf=None
np=None
label_map_util=None
vis_util=None
import cv2

#	Generated By WiredQT for Python: by Rocky Nuarin, 2021 Phils
class Handler(QtWidgets.QWidget,usercontrol):	
	#WiredProperty 'ModelFolder': 'mymodel'
	#WiredProperty 'Frozen_Inference': 'saved_model.pb'
	#WiredProperty 'LabelMap': 'label_map.pbtxt'

	def __init__(self, *param):    
		super(Handler, self).__init__(None)
		initUI(self,param,w=1366,h=768,title="WiredQT v1.0",controlbox=True,startpos=(0,30),timeoutdestroy=-1)
		self.GTKForms()
		self.timer=QtCore.QTimer()
		self.timer.timeout.connect(self.loop)
		self.timer.start(10)       

		self.sch=Scheduler(5000)#500 ms
		self.sch.Start()
		self._text=''
		self._ModelFolder=""
		self._Frozen_Inference=""
		self._LabelMap=""
	@property
	def Open(self):
		return 
	@Open.setter	
	def Open(self,value):
		if value:
			global tf,np,label_map_util,vis_util
			tf,np,label_map_util,vis_util=self.setImport()
			MODEL_NAME = self.ModelFolder
			self.detection_model = self.load_model(MODEL_NAME.replace("\\","/"))		
	@property
	def LabelMap(self):
		return self._LabelMap
	@LabelMap.setter	
	def LabelMap(self,value):
		self._LabelMap=value
	@property
	def Frozen_Inference(self):
		return self._Frozen_Inference
	@Frozen_Inference.setter	
	def Frozen_Inference(self,value):
		self._Frozen_Inference=value
	@property
	def ModelFolder(self):
		return self._ModelFolder
	@ModelFolder.setter	
	def ModelFolder(self,value):
		self._ModelFolder=value	
	def connect(self,ev,evusr):
		self.wiredevents.update({ev:evusr})
	def run_inference_for_single_image(model, image):
		image = np.asarray(image)
		#The input needs to be a tensor, convert it using `tf.convert_to_tensor`.
		input_tensor = tf.convert_to_tensor(image)
		#The model expects a batch of images, so add an axis with `tf.newaxis`.
		input_tensor = input_tensor[tf.newaxis,...]
	
		#Run inference
		output_dict = model(input_tensor)
	
		#All outputs are batches tensors.
		#Convert to numpy arrays, and take index [0] to remove the batch dimension.
		#We're only interested in the first num_detections.
		num_detections = int(output_dict.pop('num_detections'))
		output_dict = {key:value[0, :num_detections].numpy() 
			for key,value in output_dict.items()}
		output_dict['num_detections'] = num_detections
	
		#detection_classes should be ints.
		output_dict['detection_classes'] = output_dict['detection_classes'].astype(np.int64)
	
		#Handle models with masks:
		if 'detection_masks' in output_dict:
			#Reframe the the bbox mask to the image size.
			detection_masks_reframed = utils_ops.reframe_box_masks_to_image_masks(
			output_dict['detection_masks'], output_dict['detection_boxes'],
			image.shape[0], image.shape[1])      
			detection_masks_reframed = tf.cast(detection_masks_reframed > 0.5,
			tf.uint8)
			output_dict['detection_masks_reframed'] = detection_masks_reframed.numpy()
	
		return output_dict
	def load_model(self,model_name):
		fname=model_name+"/"+self.Frozen_Inference
		if FileExist(fname)==False:
			print(fname + " Not Found")
			return None
		fname=model_name+"/"+self.LabelMap
		if FileExist(fname)==False:
			print(fname + " Not Found")
			return None
		model =tf.saved_model.load(export_dir=model_name)# tf.saved_model.load(str(model_name))
		serv='serving_default'
		model = model.signatures[serv]
		PATH_TO_LABELS = model_name+'/'+self.LabelMap
		self.category_index = label_map_util.create_category_index_from_labelmap(PATH_TO_LABELS, use_display_name=True)
		return model	
	def show_inference(self,model, image_np,min_score_thresh=0.5):
		#the array based representation of the image will be used later in order to prepare the
		#result image with boxes and labels on it.
		#image_np = np.array(Image.open(image_path))
		#Actual detection.
		output_dict = self.run_inference_for_single_image(model, image_np)
		#Visualization of the results of a detection.
		vis_util.visualize_boxes_and_labels_on_image_array(
			image_np,
			output_dict['detection_boxes'],
			output_dict['detection_classes'],
			output_dict['detection_scores'],
			self.category_index,
			min_score_thresh=min_score_thresh,
			instance_masks=output_dict.get('detection_masks_reframed', None),
			use_normalized_coordinates=True,
			line_thickness=8)#visualize_boxes_and_labels_on_image_array(min_score_thresh
	
		#display(Image.fromarray(image_np))		
		return image_np,output_dict
	def run_inference_for_single_image(self,model, image):
		image = np.asarray(image)
		#The input needs to be a tensor, convert it using `tf.convert_to_tensor`.
		input_tensor = tf.convert_to_tensor(image)
		#The model expects a batch of images, so add an axis with `tf.newaxis`.
		input_tensor = input_tensor[tf.newaxis,...]
	
		#Run inference
		output_dict = model(input_tensor)
	
		#All outputs are batches tensors.
		#Convert to numpy arrays, and take index [0] to remove the batch dimension.
		#We're only interested in the first num_detections.
		num_detections = int(output_dict.pop('num_detections'))
		output_dict = {key:value[0, :num_detections].numpy() 
			for key,value in output_dict.items()}
		output_dict['num_detections'] = num_detections
	
		#detection_classes should be ints.
		output_dict['detection_classes'] = output_dict['detection_classes'].astype(np.int64)
	
		#Handle models with masks:
		if 'detection_masks' in output_dict:
			#Reframe the the bbox mask to the image size.
			detection_masks_reframed = utils_ops.reframe_box_masks_to_image_masks(
			output_dict['detection_masks'], output_dict['detection_boxes'],
			image.shape[0], image.shape[1])      
			detection_masks_reframed = tf.cast(detection_masks_reframed > 0.5,
			tf.uint8)
			output_dict['detection_masks_reframed'] = detection_masks_reframed.numpy()
	
		return output_dict		
	def Detect(self,image_np,min_score_thresh=0.5):
		#Running the tensorflow session
		retlabel=[]
		if self.detection_model==None:
			print("Check LabelMap.pbtxt and Frozen_Inference.pb")
			return None,retlabel
		retlabel=[]
		image_np,retlabel=self.show_inference(self.detection_model, image_np,min_score_thresh)
		return cv2.resize(image_np,(640,480)),retlabel
	def activeXcreated(self,*args):
		pass
	def unload(self,*args):
		destroy=True
		if destroy==True:
			GLib.source_remove(self.timeout_id)
			self._window.hide()
			del self._window
			#ExitApplication() #activate this if u want to destroy this window
			return False
		else:
			self.window.Visible=False
			return True		
	def loop(self):
		if self.form_load==False:
			self.form_load=True
		if self.sch.Event():#timer routine
			#code here
			if self.timeoutdestroy!=-1:
				self.timeoutdestroy-=1
				if self.timeoutdestroy==0:
					self.unload(None)
			self.sch.Start()#restart scheduler
		return True	#return true so that main_loop can call it again 	
	def createwidget(self,prop,control,parent,event=[]):
		createWidget(self,prop,control,parent,event)
	def GTKForms(self):
		pass
	def Widget(self):
		return self
	def setImport(self):
		import tensorflow as tf
		import numpy as np
		from object_detection.utils import label_map_util
		from object_detection.utils import visualization_utils as vis_util	
		return tf,np,label_map_util,vis_util
if __name__ == '__main__':
	import sys
	app = QtWidgets.QApplication(sys.argv)
	w = Handler()
	w.show()
	sys.exit(app.exec_())