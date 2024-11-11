class_name NameGenerator extends Object

enum Lang {ASDFG,AUREG,BABAB,CNZHO,FISUO,GEDEU,SESVE,TASWA,UKENG}

func full_name(caps: bool,first: String, second: String="") -> String: #insert some of the name funcs into first, second etc
	var full: String = first
	if second != "": full += " " + second #+" "+third...
	if caps: full = full.to_upper()
	return full

func name_chooser(i: Lang) -> String:
	match i:
		Lang.ASDFG: return full_name(false,asdf_name(5),asdf_name(8))
		Lang.AUREG: return full_name(true,code_name())
		Lang.BABAB: return full_name(false,generic_name(),generic_name())
		Lang.CNZHO: return full_name(false,chinese_name(),chinese_name(true))
		Lang.FISUO: return full_name(false,finn_name(range(0,1)),finn_name(range(0,9)))
		Lang.GEDEU: return full_name(false,schweindeutsch_name(),schweindeutsch_name(true))
		Lang.SESVE: return full_name(false,svensk_name(),svensk_name(true))
		Lang.TASWA: return full_name(false,swahili_name(),swahili_name())
		Lang.UKENG: return full_name(false,english_name(),english_name(true))
		_: return ""

func code_name() -> String: #ABC-123 #.capitalize() first? how about all caps .to_upper()
	var chr: PackedStringArray = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z".split(",")
	var num: String = str(randi() % 10) + str(randi() % 10) + str(randi() % 10)
	return choose(chr) + choose(chr) + choose(chr) + "-" + num

func asdf_name(maxxi: int = 6) -> String: #ctulhuish names
	randomize()
	#var voc: PackedStringArray = "a,e,i,o,u,y".split(",")
	var con: PackedStringArray = "b,c,d,f,g,h,j,k,l,m,n,p,q,r,s,t,v,w,x,z".split(",")
	var voc_umlaut: PackedStringArray = "a,e,i,o,u,y,ü,ä,ö,å,æ,œ,ø,ë,ï,ÿ,á,à,é,è,í,ì,ó,ò,ú,ù,ý,ỳ".split(",")
	var length: int = randi_range(1,maxxi)
	var generated: String = ""
	for l: int in length:
		generated += choose(voc_umlaut + con)
	return generated.capitalize()

func generic_name() -> String: #"tikutaku" names
	randomize()
	var voc: PackedStringArray = "a,e,i,o,u,y".split(",")
	var con: PackedStringArray = "b,c,d,f,g,h,j,k,l,m,n,p,q,r,s,t,v,w,x,z".split(",")
	var generated: String = choose(con) + choose(voc) + choose(con) + choose(voc)
	return generated.capitalize()

func choose(arr: Array) -> String:
	return arr[randi() % len(arr)] #arr.pick_random() doesn't work for packedstringarray

func finn_name(suffixes: Array = range(0,12)) -> String: #finnish names! (almost)
	var vow_fin: PackedStringArray = "o,u,a,e,i,ä,ö,y".split(",") #finnish vowels (don't mix the list order!)
	var con_fin: PackedStringArray = "h,j,k,l,m,n,p,r,s,t,v".split(",") #commonly used finnish consonants
	#for thät vowel chord:
	var umlaut: int = 0
	if randi() % 3 == 1: umlaut = 3
	#double vowels and consonants:
	var vowel: String = fin_randvowchord(vow_fin,umlaut)
	var consonant: String = choose(con_fin)
	if randi() % 2 == 1: vowel += vowel #same 2nd vowel
	elif randi() % 2 == 1: vowel += fin_randvowchord(vow_fin,umlaut) #different 2nd vowel
	if randi() % 2 == 1: consonant = fin_same_consonants(consonant) #same 2nd consonant
	elif randi() % 2 == 1: consonant = fin_different_consonants(consonant) #different 2nd consonant
	#starting with consonant or not:
	var start: String = choose(con_fin)
	if randi() % 3 == 1: start = ""
	#last letter which is practically always one vowel
	var last: String = fin_randvowchord(vow_fin,umlaut)
	var short: bool = false
	if randi() % 6 == 1: #word will cut into the first syllable
		short = true
		last = vowel[-1] #check the last letter for possible suffix
	#suffix magic:
	var random_name: int = suffixes.pick_random() #randi() % nimi
	var suffix: String = fin_suffix(random_name,vow_fin,umlaut,last)
	#final name:
	var generated: String = start + vowel + consonant + last + suffix
	if short && last != suffix: generated =  start + vowel + suffix #short names with certain probability
	while generated.length() == 1: generated = finn_name(suffixes) #as long as only one letter, try again
	return generated.capitalize()

func fin_randvowchord(list: Array, umlaut: int) -> String: #for finn_names only
	return list[randi() % (len(list) - 3) + umlaut]

func fin_same_consonants(kons: String) -> String:
	if kons != "h" && kons != "j" && kons != "v":
		kons += kons #some double consonants don't fit...
	return kons

func fin_different_consonants(kons: String) -> String: #this gets muddy
	#if kons != "j" && kons != "v": #this shouldn't be necessary but it somehow is...
	if "hs".find(kons) != -1: kons += choose(["j","k","m","n","p","t","v"])
	elif "nt".find(kons) != -1: kons += choose(["j","k","n","t","s","v"])
	elif "kp".find(kons) != -1: kons += "s"
	elif kons == "l":  kons += choose(["j","k","m","t","s","v"])
	elif kons == "m": kons += "p"
	return kons

func fin_suffix(arpoo: int,vowel: PackedStringArray,umlaut: int,last: String) -> String:
	var suffix: String = "nen"
	match(arpoo):
		0: suffix = "" #no suffix (similar to first names)
		1: suffix = "s"
		2: suffix = last #repeat last vowel
		3: suffix = "l"+ vowel[2 + umlaut] #la and lä surnames
		4: if last != "i" || last == "e": suffix = "inen" #small hifi thing...
		5: suffix = "ke"
		6: suffix = "re"
		7: 
			var n: String = ""
			if randi() % 2 == 1: n = "n"
			suffix = n + Array("kylä,harju,joki,järvi,kari,keto,korpi,koski,lahti,lampi,luoto,mäki,\
			niemi,pelto,puro,pää,ranta,uoma,vaara,vesi,virta,vuori".split(",")).pick_random()
		8: suffix = "nki" 
		9: suffix = "ti"
		10: suffix = "r"+ vowel[2 + umlaut]+"ll"+ vowel[2 + umlaut]+ vowel[2 + umlaut] #rallaa rällää
		11: suffix = "st"+vowel[2 + umlaut]
	return suffix

func finn_gibberish() -> String:
	var txt: String = ""
	for i: int in randi_range(3,30):
		txt += finn_name()+" "#[0,3,5]
	return txt

func schweindeutsch_name(surname: bool = false) -> String:
	var vow: PackedStringArray = "a,o,u,e,i,ä,ö,ü,y,au,ei,ie,eu".split(",")
	var con: PackedStringArray = "b,ch,d,f,g,h,j,k,l,m,n,p,r,s,ß,sch,t,v,w,x,z".split(",")
	var start: PackedStringArray = "b,bl,d,fr,gr,r,s,sch,schw,st,str,t,th,tr,v,w,z,".split(",") #last , is intentional
	var end: PackedStringArray = "b,ch,dt,f,hm,hn,l,lf,lz,n,ng,nn,nth,rf,rn,s,ß,sch,tt,tz".split(",")
	if randi() % 3 == 1: start = [""] #starting with vowel
	var generated: String = choose(start) + choose(vow) + choose(con) + choose(vow) + choose(end)
	if randi() % 6 == 1: generated = choose(start) + choose(vow) + choose(end) #shorter
	generated = germanic_suffix(generated,surname,"ger")
	while generated == "": generated = germanic_suffix(generated,surname,"ger") #try again until not empty
	return generated.capitalize()

func svensk_name(surname: bool = false) -> String:
	var vow: PackedStringArray = "a,o,u,e,i,ä,ö,å,y".split(",")
	var con: PackedStringArray = "b,ck,d,f,g,h,j,k,l,m,n,p,r,s,t,v,w".split(",")
	var start: PackedStringArray = "b,bl,d,fr,gr,r,s,sj,sk,st,sv,str,t,th,tr,v,w".split(",")
	var end: PackedStringArray = "b,bb,ch,ck,dt,f,hm,hn,hl,l,lf,n,nt,r,rv,rn,s,tt,x".split(",")
	if randi() % 3 == 1: start = [""] #starting with vowel
	var generated: String = choose(start) + choose(vow) + choose(con) + choose(vow) + choose(end)
	if randi() % 3 == 1: generated = choose(start) + choose(vow) + choose(end) #shorter
	generated = germanic_suffix(generated,surname,"sve")
	while generated == "": generated = germanic_suffix(generated,surname,"sve") #try again until not empty
	return generated.capitalize()

func english_name(surname: bool = false) -> String:
	var vow: PackedStringArray = "a,e,i,o,u,aa,ay,ee,ea,ei,ey,eu,ue,ia,ie,oo,ou,oy".split(",")
	var con: PackedStringArray = "b,c,d,f,g,h,j,k,l,m,n,p,q,r,s,t,v,w,x,y,z".split(",")
	var mid: PackedStringArray = "ck,dd,gg,nc,nn,nt,mm,rr,rv,rw,sp,st,th,tt,xt".split(",")
	var start: PackedStringArray = "bl,chr,fr,gl,gr,tr,sc,sh,st,str,".split(",")
	var end: PackedStringArray = "b,ch,ck,d,g,h,hn,k,l,ld,m,mp,n,nce,ng,r,rk,rm,s,th,tt,w,x,".split(",") #cky,hnny,nny,rry,
	var allstart: PackedStringArray = con+start
	var allmid: PackedStringArray = con+mid
	if randi() % 3 == 1: allstart = [""] #starting with vowel
	var generated: String = choose(allstart) + choose(vow) + choose(allmid) + choose(vow) + choose(end)
	if randi() % 6 > 1: generated = choose(allstart) + choose(vow) + choose(end) #shorter
	generated = germanic_suffix(generated.capitalize(),surname,"eng")
	while generated == "": generated = germanic_suffix(generated.capitalize(),surname,"eng") #try again until not empty
	return generated[0].to_upper() + generated.erase(0) #generated.capitalize()

func germanic_suffix(sn: String,surname: bool,ethn: String = "sve") -> String: #works at least for swedish and german...
	var suffix: PackedStringArray = []
	var surn: String = sn
	if surname:
		match ethn:
			"sve": suffix = "berg,borg,bro,bäck,dahl,dal,feldt,fors,gren,gård,holm,lind,lund,löf,man,mark,qvist,skog,sten,ström,åker,".split(",")
			"ger": suffix = "bach,baum,berg,burg,feld,heim,kopf,stein,mann,".split(",")
			"eng": suffix = "field,ford,head,hill,house,ley,lord,man,stone,wood,".split(",")
		if ethn == "eng":
			if randi() % 50 == 1: surn = "Mc" + surn
			elif randi() % 50 == 1: surn = "O\'" + surn
		if randi() % 6 == 1: surn += choose(suffix)
		elif randi() % 8 == 1: surn = choose(suffix) + choose(suffix) #could return empty (see while)
		if randi() % 10 == 1 && (ethn == "ger" || ethn == "eng"):
			if surn.ends_with("e"): surn += "r"
			else: surn += "er"
		elif randi() % 4 == 1: if ethn == "sve" || ethn == "eng": surn += "son"
		elif randi() % 4 == 1 && ethn == "eng": surn += Array("s,ton,".split(",")).pick_random()
	return surn

func chinese_name(longer: bool = false) -> String:
	var initial: PackedStringArray = "b,p,m,f,d,t,n,l,g,k,h,j,q,x,zh,ch,sh,r,z,s,".split(",")
	var final_a: PackedStringArray = "i,a,e,ai,ei,ao,ou,an,en,ang,eng,ong".split(",")
	var final_i: PackedStringArray = "ia,io,ie,iao,iu,ian,in,iang,ing,iong".split(",")
	var final_u: PackedStringArray = "u,ua,uo,uai,ui,uan,un,uang,ueng".split(",")
	var extra: PackedStringArray = "o,lo,er,yo,yu,nü,lü,ju,qu,xu,yue,nüe,lüe,jue,que,xue,yuan,juan,quan,xuan,yun,jun,qun,xun".split(",")
	var syllables: Array = []
	for initti: String in initial:
		if initti == "j" || initti == "q" || initti == "x":
			for i: String in final_i: syllables.append(initti+i)
		elif initti == "":
			final_i = "yi,ya,yo,ye,yao,you,yan,yin,yang,ying,yong".split(",")
			final_u = "wu,wa,wo,wai,wei,wan,wen,wang,weng".split(",")
			for o: String in final_a+final_i+final_u: syllables.append(o)
		elif initti == "zh" || initti == "ch" || initti == "sh" || initti == "z" || initti == "c" \
			|| initti == "s" || initti == "r":
			for a: String in final_a:
				syllables.append(initti+a)
			for u: String in final_u:
				syllables.append(initti+u)
		else: for dump: String in final_a+final_i+final_u: syllables.append(initti+dump)
		for e: String in extra:
			syllables.append(e) #add the exceptions
	var generated: String = choose(syllables)
	if longer && randi() % 2 == 1: generated += choose(syllables) #pick another
	return generated.capitalize()

func swahili_name() -> String: #I cannot speak this language at all but...
	var vow: PackedStringArray = "a,e,i,o,u".split(",") #,ae,ai,ea,eo,ia,ie,ua,ue
	var con: PackedStringArray = "b,ch,d,f,g,h,j,k,l,m,n,p,r,s,t,v,w,y,z,dh,gh,kh,nd,ng,nj,ny,nz,sh,th".split(",") #mb,mv,ng\',
	var con_final: PackedStringArray = "d,f,l,m,n,r".split(",")
	var sn: String = ""
	var syllable_count: int = 2
	if randi() % 4 == 1: syllable_count = randi_range(1,4) #6?
	for s: int in syllable_count:
		var short_rng: int = randi() % 24
		if short_rng != 1: #first consonant (likely)
			var c: String = swa_consonant(con)
			if sn.length() > 0:
				while c[0] == sn[-1]: c = swa_consonant(con) #no duplicate consonants between syllables
			sn += c 
		sn += choose(vow) #first vowel (always)
		if randi() % 16 == 1: sn += choose(vow) #last vowel (unlikely)
		if randi() % 24 == 1 && short_rng != 1: sn += choose(con_final) #last consonant (unlikely)
	return sn.capitalize()

func swa_consonant(cons: PackedStringArray) -> String:
	var c: String = choose(cons) #always
	if randi() % 24 == 1: c = "m" + c #optional initial
	if c != "w" && randi() % 16 == 1: c += "w" #optional final
	return c

func codify(name:String,pinyin: bool=false) -> String: #code compatible name (no special characters etc)
	var n : String = name.to_lower() #æ,œ,ø,ë,ï,ÿ,á,à,é,è,í,ì,ó,ò,ú,ù,ý,ỳ
	n = n.replace(" ",".") #no whitespaces
	n = n.replace("\'","") #omit '
	n = n.replacen("ä","a"); n = n.replacen("å","a"); n = n.replacen("á","a");
	n = n.replacen("à","a"); n = n.replacen("æ","ae");
	n = n.replacen("ö","o"); n = n.replacen("ø","o"); n = n.replacen("ó","o");
	n = n.replacen("ò","o"); n = n.replacen("œ","oe");
	n = n.replacen("ë","e"); n = n.replacen("é","e"); n = n.replacen("è","e");
	n = n.replacen("ï","i"); n = n.replacen("í","i"); n = n.replacen("ì","i");
	n = n.replacen("ÿ","y"); n = n.replacen("ý","y"); n = n.replacen("ỳ","y");
	n = n.replacen("ú","u"); n = n.replacen("ù","u");
	if pinyin: n = n.replacen("ü","v") #pinyin curiosity
	else: n = n.replacen("ü","u")
	n = n.replacen("ß","ss")
	return n #with handle or not? "@" + n

func initials(nam: String) -> String:
	var shorts: PackedStringArray = nam.split(" ")
	var shrt: String = ""
	if shorts.size() > 1:
		for s: String in shorts: shrt += s[0]
		return shrt
	else: return nam
