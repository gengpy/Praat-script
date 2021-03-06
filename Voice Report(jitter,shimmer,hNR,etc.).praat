#脚本功能：Voice Report(jitter,shimmer,hNR,etc.)

#使用前提：①适用于mac操作系统(windows系统使用方法请联系作者email：gengpy@ssfjd.cn)，Praat版本最好是在6.0及以上；②必须对声音文件标注，有同名的声音文件（WAV格式）和TextGrid标注文件

#脚本作者：耿浦洋（司法鉴定科学研究院），若您使用此脚本进行学术研究，请在脚注中予以说明或在参考文献中进行援引，请尊重知识产权！
#Copyright reserved by Puyang Geng, The Academy of Forensic Science, Department of Criminal Technology, Shanghai, 200063. Email: gengpy@ssfjd.cn
#How to cite: Geng, P.Y. (2020). Voice Report(jitter,shimmer,hNR,etc.) [Praat script]. Retrieved from https://github.com/gengpy/Praat-script.git

#写作时间：2019年10月30日


form voice report

sentence 路径 /Users/young/Desktop/Analysis/CM/SN1
positive Tier_number 2
endform
dir$=路径$

list=do("Create Strings as file list...","list",dir$+"/"+"*.wav")
numberOfwav=Get number of strings

resultfile$=dir$+"/voicereport_segresult.txt"
writeFile(resultfile$,"File",tab$,"lablename",tab$,"jitter_local",tab$,"jitter_rap",tab$,"jitter_ppq5",tab$,"jitter_ddp",tab$)
appendFileLine(resultfile$,"shimmer",tab$,"shimmer_dB",tab$,"shimmer_apq3",tab$,"shimmer_apq5",tab$,"shimmer_apq11",tab$,"shimmer_dda",tab$,"HNR_dB")

for ifile to numberOfwav
	select list
	wav_name$=do$("Get string...",ifile)
	wav_id=do("Read from file...",dir$+"/"+wav_name$)
	pitch_id=do("Read from file...",dir$+"/"+wav_name$-"wav"+"Pitch")
	textgrid_id=do("Read from file...",dir$+"/"+wav_name$-"wav"+"TextGrid")
	selectObject(wav_id)
		To PointProcess (periodic, cc): 40, 800
		pProcess$ = ("PointProcess " + wav_name$ - ".wav")
	
	select textgrid_id
	tierN=Get number of intervals: tier_number

	for k from 1 to tierN
	select textgrid_id
	labelname$=do$("Get label of interval...", tier_number, k)
	starttime=Get start time of interval: tier_number, k
	endtime=Get end time of interval: tier_number, k
	initialLetter$ = left$ (labelname$, 1,...)
    endLetter$ = right$ (labelname$, 1)
	if initialLetter$ = "a" or initialLetter$ = "o" or initialLetter$ = "e" or initialLetter$ = "i" or initialLetter$ = "u" or initialLetter$ = "v" or initialLetter$ = "y"
		...or  endLetter$ = "0" or  endLetter$ = "1" or  endLetter$ = "2" or  endLetter$ = "3" or  endLetter$ = "4" or  endLetter$ = "5" or  endLetter$ = "6" or  endLetter$ = "7" or  endLetter$ = "8" or  endLetter$ = "9"        
    #         appendFile (resultfile$, newline$)

	selectObject(pProcess$)

	plus wav_id
	plus pitch_id
	voice$=do$("Voice report...",starttime,endtime,40,800,1.3,1.6,0.03,0.45)
	
	jitter_local=extractNumber(voice$,"Jitter (local): ")
	jitter_rap=extractNumber(voice$,"Jitter (rap): ")
	jitter_ppq5=extractNumber(voice$,"Jitter (ppq5): ")
	jitter_ddp=extractNumber(voice$,"Jitter (ddp): ")
	shimmer=extractNumber(voice$,"Shimmer (local): ")
	shimmer_dB=extractNumber(voice$,"Shimmer (local, dB): ")
	shimmer_apq3=extractNumber(voice$,"Shimmer (apq3): ")
	shimmer_apq5=extractNumber(voice$,"Shimmer (apq5): ")
	shimmer_apq11=extractNumber(voice$,"Shimmer (apq11): ")
	shimmer_dda=extractNumber(voice$,"Shimmer (dda): ")
	hNR=extractNumber(voice$,"Mean harmonics-to-noise ratio: ",pyg)

	appendFile(resultfile$,wav_name$,tab$,labelname$,tab$,jitter_local,tab$,jitter_rap,tab$,jitter_ppq5,tab$,jitter_ddp,tab$)
	appendFile(resultfile$,shimmer,tab$,shimmer_dB,tab$,shimmer_apq3,tab$,shimmer_apq5,tab$,shimmer_apq11,tab$,shimmer_dda)
	appendFileLine(resultfile$,tab$,hNR)
	

	endif
	endfor

	selectObject(pProcess$)
	plus wav_id
	plus pitch_id
	plus textgrid_id
	Remove
	
endfor
exit Done!
	