#脚本功能：Formant and Bandwidth Extraction

#Formant corrected, especially for u

#使用前提：①只适用于Windows操作系统，Praat版本最好是在6.0及以上；②必须对声音文件标注，有同名的声音文件（WAV格式）和TextGrid标注文件

#脚本作者：耿浦洋（司法鉴定科学研究院），若您使用此脚本进行学术研究，请在脚注中予以说明或在参考文献中进行援引，请尊重知识产权！
#Copyright by Puyang Geng, The Academy of Forensic Science, Department of Criminal Technology, Shanghai, 200063.
#How to cite: Geng, P.Y. (2020). Formant and Bandwidth Extraction [Praat script]. Retrieved from https://github.com/gengpy/Praat-script.git

#写作时间：2020年11月25日

#参数查询：Maximum_formant 5500 for adult female; 5000 for adult male; 8000 for young child.
#Analysing /u/ as having a single formant near 500 Hz whereas you want two formants at 300 and 600 Hz.
#You may like to experiment with this setting on steady vowels.


form  提取共振峰
	sentence Open_Path_(文件路径) C:\Users\Administrator\Desktop\1
	positive Tier_number_(提取第几层) 2
	positive Analysis_points_time_step_(提取精度) 0.001
	sentence Save_Path_(保存路径) C:\Users\Administrator\Desktop\1
	comment Formant Settings:
    positive Maximum_formant 5500
    positive Number_formants 7
    positive Number_tracks 4
    positive F1_ref 500
    positive F2_ref 1485
    positive F3_ref 2450
    positive F4_ref 3550
    positive F5_ref 4650
    positive Window_length 0.005
endform
 

    soundString = do ("Create Strings as file list...", "soundString", open_Path$ + "\*.wav");读取打开路径中的wav文件
    selectObject (soundString)
    fileNumber = do ("Get number of strings")
	result$ = open_Path$ + "/Formant.txt"
	writeFileLine (result$, "fileName", tab$, "lablename", tab$, "time", tab$, "formant1",tab$,"formant2",tab$,"formant3",tab$,"formant4",tab$,"bandwidth1",tab$,"bandwidth2",tab$,"bandwidth3",tab$,"bandwidth4")


for k from 1 to fileNumber;读取和Wav同名的formant与TextGrid文件
      selectObject (soundString)
      fileName$ = do$ ("Get string...", k)
      sound = do ("Read from file...", open_Path$ + "\" + fileName$)
      textgrid = do ("Read from file...", open_Path$ + "\" + fileName$ - "wav" + "Textgrid")
      
	  selectObject (sound)
	  sound2 = Resample... 16000 50
	  
	  selectObject (sound2)
	  formant = To Formant (burg): 0, 'number_formants', 'maximum_formant', 'window_length', 50
	  # max_formant 5500 for adult female
	  selectObject (formant)
	  formant_tracked = Track... 'number_tracks' 'f1_ref' 'f2_ref' 'f3_ref' 'f4_ref' 'f5_ref' 1 1 1
		
	  selectObject (textgrid)
      intervalNumber = do ("Get number of intervals...", tier_number);找到要提取共振峰值的层的interval number

		for i from 1 to intervalNumber
		selectObject (textgrid)
		startTime = Get start time of interval: tier_number,i
		endTime = Get end time of interval: tier_number,i
		extractnums1 = (endTime-startTime)/analysis_points_time_step
		extractnums2 = floor(extractnums1)
		text$ = do$("Get label of interval...",tier_number,i)
		
		if text$<>""

		selectObject (formant_tracked)
		
			for j from 1 to extractnums2
			extractTime=startTime+analysis_points_time_step*j
			f1=Get value at time: 1, extractTime, "hertz", "Linear"
			f2=Get value at time: 2, extractTime, "hertz", "Linear"
			f3=Get value at time: 3, extractTime, "hertz", "Linear"
			f4=Get value at time: 4, extractTime, "hertz", "Linear"
			bd1=Get bandwidth at time: 1, extractTime, "hertz", "linear"
			bd2=Get bandwidth at time: 2, extractTime, "hertz", "linear"
			bd3=Get bandwidth at time: 3, extractTime, "hertz", "linear"
			bd4=Get bandwidth at time: 4, extractTime, "hertz", "linear"
			
			pointTime$=string$(extractTime)
			appendFileLine (result$, fileName$, tab$, text$,tab$,pointTime$,tab$,f1,tab$,f2,tab$,f3,tab$,f4,tab$,bd1,tab$,bd2,tab$,bd3,tab$,bd4)
			endfor
	
		endif
		
		endfor
endfor


select all
Remove

exit 耿浦洋666!









