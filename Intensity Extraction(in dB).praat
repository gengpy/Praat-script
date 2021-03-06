#脚本功能：Intensity Extraction(in dB)

#使用前提：①适用于mac操作系统(windows系统使用方法请联系作者email：gengpy@ssfjd.cn)，Praat版本最好是在6.0及以上；②必须对声音文件标注，有同名的声音文件（WAV格式）和TextGrid标注文件

#脚本作者：耿浦洋（司法鉴定科学研究院），若您使用此脚本进行学术研究，请在脚注中予以说明或在参考文献中进行援引，请尊重知识产权！
#Copyright reserved by Puyang Geng, The Academy of Forensic Science, Department of Criminal Technology, Shanghai, 200063. Email: gengpy@ssfjd.cn
#How to cite: Geng, P.Y. (2020). Intensity Extraction(in dB) [Praat script]. Retrieved from https://github.com/gengpy/Praat-script.git

#写作时间：2019年10月5日
#更新时间：2020年11月26日


form 提取音强曲线
   sentence Open_Path_(打开路径) /Users/Administrator/Desktop/1
   positive Tier_(提取层) 2
   positive Analysis_points_time_step_(提取精度) 0.001
   positive Pitch_floor 100
   
endform

soundString = do ("Create Strings as file list...", "soundString", open_Path$ + "/*.wav");
selectObject (soundString)
fileNumber = do ("Get number of strings");
result$ = open_Path$ + "/Intensity.txt"
writeFileLine (result$, "fileName", tab$, "lablename", tab$,"time", tab$, "Intensity")


for k from 1 to fileNumber
selectObject (soundString)
fileName$ = do$ ("Get string...", k)
sound = do("Read from file...", open_Path$ + "/" + fileName$)
textgrid = do("Read from file...", open_Path$ + "/" + fileName$ - "wav" + "TextGrid")

selectObject (textgrid)
intervalnumber = do("Get number of intervals...", tier)

selectObject (sound)
intensityfile = do("To Intensity...", pitch_floor, 0, "yes")


	for i from 1 to intervalnumber
		selectObject(textgrid)
		lablename$ = do$("Get label of interval...", tier, i)
		if lablename$ <> ""
			startpoint = do("Get start time of interval...", tier, i)
			endpoint = do("Get end time of interval...", tier, i)
			steps1 = (endpoint - startpoint)/analysis_points_time_step
			steps2 = floor(steps1)
			
		for j from 0 to steps2
			extractTime=startpoint+j*analysis_points_time_step
			selectObject (intensityfile)
			intensitydata = Get value at time: extractTime, "Cubic"
			pointtime$=string$(extractTime)
			appendFileLine(result$, fileName$, tab$, lablename$, tab$, pointtime$, tab$, intensitydata)
		endfor

		endif
	endfor

	
	
endfor

select all
Remove


exit 耿浦洋666
