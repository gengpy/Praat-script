#脚本功能：Pitch Extraction

#使用前提：①适用Windows系统(mzc使用方法请联系作者Email: gengpy@ssfjd.cn)，脚本编写 in Praat 6.1.27；②必须有语音标注TextGrid文件；③无须提前生成Pitch文件，本脚本自动删除跳点，并平滑内插；④同名语音文件（WAV格式）和TextGrid文件置于同一文件夹下

#脚本作者：耿浦洋（司法鉴定科学研究院），若您使用此脚本进行学术研究，请在脚注中予以说明或在参考文献中进行援引，请尊重知识产权！
#Copyright by Puyang Geng, The Academy of Forensic Science, Department of Criminal Technology, Shanghai, 200063. Email: gengpy@ssfjd.cn
#How to cite: Geng, P.Y. (2020). Pitch Extraction in semitone(smoothed&interpolated) [Praat script]. Retrieved from https://github.com/gengpy/Praat-script.git

#编写时间：2020年11月25日
#更新时间：2020年11月26日


form 提取基频
   sentence Open_Path_(打开路径) C:\Users\Administrator\Desktop\1
   positive Tier_(提取层) 2
   positive Analysis_points_time_step_(提取精度) 0.001
   positive Ref_frequency_(半音参考频率) 100
   comment Pitch Settings:
   positive Maximum_pitch 600
   positive Minimum_pitch 75
   positive Time_step 0.75
   positive Octave_cost 0.01
   positive Octave_jump_cost 0.35
   positive Smooth_bandwidth 20

endform

soundString = do ("Create Strings as file list...", "soundString", open_Path$ + "\*.wav");
selectObject (soundString)
fileNumber = do ("Get number of strings");
result$ = open_Path$ + "\Pitch.txt"
writeFileLine (result$, "fileName", tab$, "lablename", tab$, "time", tab$,"Pitch")


for k from 1 to fileNumber
selectObject (soundString)
fileName$ = do$ ("Get string...", k)
sound = do("Read from file...", open_Path$ + "\" + fileName$)
textgrid = do("Read from file...", open_Path$ + "\" + fileName$ - "wav" + "TextGrid")

selectObject (sound)
pitchfile = To Pitch: time_step/minimum_pitch, minimum_pitch, maximum_pitch
Kill octave jumps...
smooth = do ("Smooth...", smooth_bandwidth)
interpolate = do ("Interpolate")
pitchfiletier = do ("Down to PitchTier")

selectObject (textgrid)
intervalnumber = do("Get number of intervals...", tier)


	for i from 1 to intervalnumber
		selectObject(textgrid)
		lablename$ = do$("Get label of interval...", tier, i)
		if lablename$ <> ""
			startpoint = do("Get start time of interval...", tier, i)
			endpoint = do("Get end time of interval...", tier, i)
			steps1 = (endpoint - startpoint)/analysis_points_time_step
			steps2 = floor(steps1)
			pyg
          letter$ = do$ ("Get label of interval...", tier, i)
          initialLetter$ = left$ (letter$, 1)
          endLetter$ = right$ (letter$, 1)

		if initialLetter$ = "a" or initialLetter$ = "o" or initialLetter$ = "e" or initialLetter$ = "i" or initialLetter$ = "u" or initialLetter$ = "v" or initialLetter$ = "y"
             ...or  endLetter$ = "0" or  endLetter$ = "1" or  endLetter$ = "2" or  endLetter$ = "3" or  endLetter$ = "4" or  endLetter$ = "5" or  endLetter$ = "6" or  endLetter$ = "7" or  endLetter$ = "8" or  endLetter$ = "9"...               
             appendFile (result$, newline$)
		
		for j from 0 to steps2
		extractTime=startpoint+j*analysis_points_time_step
		
			selectObject (pitchfiletier)
			
                 valueHertz = do ("Get value at time...", extractTime)
                 semiTone = 12 * log2(valueHertz/ref_frequency)
					pointTime$ = string$(extractTime)

			appendFileLine(result$, fileName$, tab$, lablename$, tab$,pointTime$, tab$,semiTone)
	
		endfor
		endif
		endif
	endfor

endfor

select all
Remove
	
exit 耿浦洋666