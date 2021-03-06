#脚本功能：Duration Extraction(in s)

#使用前提：①适用于mac操作系统(windows系统使用方法请联系作者email：gengpy@ssfjd.cn)，Praat版本最好是在6.0及以上；②必须对声音文件标注，有同名的声音文件（WAV格式）和TextGrid标注文件

#脚本作者：耿浦洋（司法鉴定科学研究院），若您使用此脚本进行学术研究，请在脚注中予以说明或在参考文献中进行援引，请尊重知识产权！
#Copyright reserved by Puyang Geng, The Academy of Forensic Science, Department of Criminal Technology, Shanghai, 200063. Email: gengpy@ssfjd.cn
#How to cite: Geng, P.Y. (2020). Duration Extraction(in s) [Praat script]. Retrieved from https://github.com/gengpy/Praat-script.git

#写作时间：2019年10月5日



form 填入文件所在的文件夹
     sentence path /Users/young/Desktop/Analysis/CM/SN33
	 positive tier 1
endform

string=do("Create Strings as file list...","fileList",path$+"/*.wav")
fileNumber=do("Get number of strings")
result$=path$+"/duration.txt"
writeFileLine(result$,"fileName",tab$,"labelname",tab$,"Duration")
for i from 1 to fileNumber
   selectObject (string)
   fileName$=do$("Get string...",i)
   wav = do("Read from file...",path$+"/"+fileName$)
   text_id = do("Read from file...",path$+"/"+fileName$ - "wav" + "TextGrid")
	select text_id
	numberOfinterval=do("Get number of intervals...",tier)
	
		
		for k from 1 to numberOfinterval
		labelname$=do$("Get label of interval...",tier,k)

		if labelname$ <> ""
		start_time=do("Get starting point...",tier,k)
		end_time=do("Get end point...",tier, k)
		duration=end_time-start_time
		appendFileLine(result$,fileName$,tab$,labelname$,tab$,duration)
		endif	
		endfor
	
	select wav
	plus text_id
	Remove

endfor
exit 耿浦洋666!


