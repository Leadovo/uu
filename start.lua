Server_Done = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a')
redis = dofile("./libs/redis.lua").connect("127.0.0.1", 6379)
serpent = dofile("./libs/serpent.lua")
JSON    = dofile("./libs/dkjson.lua")
json    = dofile("./libs/JSON.lua")
URL     = dofile("./libs/url.lua")
http    = require("socket.http")
https   = require("ssl.https")
-------------------------------------------------------------------
whoami = io.popen("whoami"):read('*a'):gsub('[\n\r]+', '')
uptime=io.popen([[echo `uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"D,",h+0,"H,",m+0,"M."}'`]]):read('*a'):gsub('[\n\r]+', '')
CPUPer=io.popen([[echo `top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`]]):read('*a'):gsub('[\n\r]+', '')
HardDisk=io.popen([[echo `df -lh | awk '{if ($6 == "/") { print $3"/"$2" ( "$5" )" }}'`]]):read('*a'):gsub('[\n\r]+', '')
linux_version=io.popen([[echo `lsb_release -ds`]]):read('*a'):gsub('[\n\r]+', '')
memUsedPrc=io.popen([[echo `free -m | awk 'NR==2{printf "%sMB/%sMB ( %.2f% )\n", $3,$2,$3*100/$2 }'`]]):read('*a'):gsub('[\n\r]+', '')
-------------------------------------------------------------------
Runbot = require('luatele')
-------------------------------------------------------------------
local infofile = io.open("./sudo.lua","r")
if not infofile then
if not redis:get(Server_Done.."token") then
os.execute('sudo rm -rf setup.lua')
io.write('\27[1;31mSend your Bot Token Now\n\27[0;39;49m')
local TokenBot = io.read()
if TokenBot and TokenBot:match('(%d+):(.*)') then
local url , res = https.request("https://api.telegram.org/bot"..TokenBot.."/getMe")
local Json_Info = JSON.decode(url)
if res ~= 200 then
print('\27[1;34mBot Token is Wrong\n')
else
io.write('\27[1;34mThe token been saved successfully \n\27[0;39;49m')
TheTokenBot = TokenBot:match("(%d+)")
os.execute('sudo rm -fr .infoBot/'..TheTokenBot)
redis:setex(Server_Done.."token",300,TokenBot)
end 
else
print('\27[1;34mToken not saved, try again')
end 
os.execute('lua5.3 start.lua')
end
if not redis:get(Server_Done.."id") then
io.write('\27[1;31mSend Developer ID\n\27[0;39;49m')
local UserId = io.read()
if UserId and UserId:match('%d+') then
io.write('\n\27[1;34mDeveloper ID saved \n\n\27[0;39;49m')
redis:setex(Server_Done.."id",300,UserId)
else
print('\n\27[1;34mDeveloper ID not saved\n')
end 
os.execute('lua5.3 start.lua')
end
local url , res = https.request('https://api.telegram.org/bot'..redis:get(Server_Done.."token")..'/getMe')
local Json_Info = JSON.decode(url)
local Inform = io.open("sudo.lua", 'w')
Inform:write([[
return {
	
Token = "]]..redis:get(Server_Done.."token")..[[",

id = ]]..redis:get(Server_Done.."id")..[[

}
]])
Inform:close()
local start = io.open("start", 'w')
start:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
sudo lua5.3 start.lua
done
]])
start:close()
local Run = io.open("Run", 'w')
Run:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
screen -S ]]..Json_Info.result.username..[[ -X kill
screen -S ]]..Json_Info.result.username..[[ ./start
done
]])
Run:close()
redis:del(Server_Done.."id")
redis:del(Server_Done.."token")
os.execute('cp -a ../uu/ ../'..Json_Info.result.username..' && rm -fr ~/uu')
os.execute('cd && cd '..Json_Info.result.username..';chmod +x start;chmod +x Run;./Run')
end
Information = dofile('./sudo.lua')
sudoid = Information.id
Token = Information.Token
bot_id = Token:match("(%d+)")
os.execute('sudo rm -fr .infoBot/'..bot_id)
bot = Runbot.set_config{
api_id=16097628,
api_hash='d21f327886534832fdf728117ac7b809',
session_name=bot_id,
token=Token
}
Sudos = {sudoid,5184805269}
function Bot(msg)  
local idbot = false  
if tonumber(msg.sender.user_id) == tonumber(bot_id) then  
idbot = true    
end  
return idbot  
end
function devB(user)  
local idSub = false  
for k,v in pairs(Sudos) do  
if tonumber(user) == tonumber(v) then  
idSub = true    
end
end  
return idSub
end
function getChatId(id) local chat = {} local id = tostring(id) if id:match('^-100') then local channel_id = id:gsub('-100', '') chat = {ID = channel_id, type = 'channel'} else local group_id = id:gsub('-', '') chat = {ID = group_id, type = 'group'} end return chat end
function scandirfile(directory) local i, t, popen = 0, {}, io.popen for filename in popen('ls '..directory..''):lines() do i = i + 1 t[i] = filename end return t end
function exi_filesx(cpath) local files = {} local pth = cpath for k, v in pairs(scandirfile(pth)) do table.insert(files, v) end return files end
function file_exia(name, cpath) for k,v in pairs(exi_filesx(cpath)) do if name == v then return true end end return false end
reply_markup = bot.replyMarkup{
type = 'keyboard',
resize = true,
is_personal = true,
data = {
{{text = 'حذف بوت ➖',type = 'text'},{text ='صنع بوت ➕',type = 'text'}},
{{text ='تشغيل بوت 〰️',type = 'text'},{text ='ايقاف بوت 〰️',type = 'text'}},
{{text = 'معلومات السيرفر ⚠️',type = 'text'},{text ='المشتركين 👥', type = 'text'}},
{{text = 'تحديث الصانع 🔁',type = 'text'},{text = "تحديث المصنوعات🔄", type = 'text'}},
{{text = 'إلغاء 🚫',type = 'text'}},
}
}
function Run(msg,data)
if msg.content.text then
text = msg.content.text.text
else 
text = nil
end
if bot.getChatId(msg.chat_id).type == "basicgroup" then 
if devB(msg.sender.user_id)  then
if text == "تحديث المصنوعات🔄" then
local i = 0
local t = '▪︎ تم تحديث جميع المشتركين'
for v in io.popen('ls /root'):lines() do
if v then 
if v ~= bot.getMe().username then 
if v and v:match('(%S+)[Bb][Oo][Tt]') then
os.execute('cd ../'..v..' && rm -rf start.lua')
os.execute('cp -a ./Files/start.lua  ../'..v)
i = i +1
elseif not v then 
local t = '▪︎ لا يوجد مشتركين'
end
end
end
end 
bot.sendText(msg.chat_id,msg.id,t,"md",true)  
return false
end
if text == 'تحديث الصانع 🔁' then    
bot.sendText(msg.chat_id,msg.id,'▪︎تم تحديث ملفات الصانع بنجاح',"md",true)  
dofile("start.lua") 
return false
end 
if text == "/start" then 
local bl = '▪︎أهلا بك في صانع بوتات الحمايه\n\n▪︎استخدم الاوامر اسفل' 
return bot.sendText(msg.chat_id,msg.id,bl, 'md', false, false, false, false, reply_markup)
end
if redis:get(bot_id.."Send:UserName"..msg.chat_id..":"..msg.sender.user_id) == 'true1' then
if text == 'إلغاء 🚫' then
redis:del(bot_id.."Send:UserName"..msg.chat_id..":"..msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id,'▪︎تم اللغاء الطلب بنجاح', 'md', false, false, false, false, reply_markup)
return false  
end 
local UserName = string.match(text, "@[%a%d_]+") 
if UserName then
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*- اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*- اليوزر لقناه او مجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*- عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
redis:del(bot_id.."Send:UserName"..msg.chat_id..":"..msg.sender.user_id) 
local url , res = https.request('https://api.telegram.org/bot'..redis:get(bot_id.."Token:Bot"..msg.chat_id..":"..msg.sender.user_id)..'/getMe')
local Jsonfo = JSON.decode(url)
Sudo  = UserId_Info.id
file = io.open("./Files/sudo.lua", "w")  
file:write([[
return {
	
Token = "]]..redis:get(bot_id.."Token:Bot"..msg.chat_id..":"..msg.sender.user_id)..[[",

id = ]]..Sudo..[[

}
]])
file:close() 
file = io.open("./Files/start", "w")  
file:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
sudo lua5.3 start.lua
done
]])  
u , res = https.request('https://api.telegram.org/bot'..redis:get(bot_id.."Token:Bot"..msg.chat_id..":"..msg.sender.user_id)..'/getMe')
JsonSInfo = JSON.decode(u)
useyu = JsonSInfo['result']['username']
file:close()  
file = io.open("./Files/Run", "w")  
file:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
screen -S ]]..useyu..[[ -X kill
screen -S ]]..useyu..[[ ./start
done
]])  
file:close() 
os.execute('cp -a ./Files/. ../'..useyu..' && cd && cd '..useyu..' && screen -d -m -S '..useyu..' lua5.3 start.lua')
redis:del(bot_id.."Token:Bot"..msg.chat_id..":"..msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id,'▪︎تم حفظ معرومات المطور وتم تشغيل البوت بنجاح..', 'md')
return false  
end
end
if redis:get(bot_id.."Send:Token"..msg.chat_id..":"..msg.sender.user_id) == 'true' then
if text == 'إلغاء 🚫' then
local bl = '▪︎تم اللغاء الطلب بنجاح'
redis:del(bot_id.."Send:Token"..msg.chat_id..":"..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,bl, 'md', false, false, false, false, reply_markup)
return false
end
if text and text:match("^(%d+)(:)(.*)") then
local url , res = https.request('https://api.telegram.org/bot'..text..'/getMe')
local Json_Info = JSON.decode(url)
if Json_Info.ok == false then
bot.sendText(msg.chat_id,msg.id,'▪︎التوكن خطأ ارسل توكن صالح', 'md')
return false
else
NameBot = Json_Info.result.first_name
UserNameBot = Json_Info.result.username
NameBot = NameBot:gsub('"','') 
NameBot = NameBot:gsub("'",'') 
NameBot = NameBot:gsub('`','') 
NameBot = NameBot:gsub('*','') 
redis:del(bot_id.."Send:Token"..msg.chat_id..":"..msg.sender.user_id) 
redis:set(bot_id.."Send:UserName"..msg.chat_id..":"..msg.sender.user_id,'true1') 
redis:set(bot_id.."Token:Bot"..msg.chat_id..":"..msg.sender.user_id,text) 
bot.sendText(msg.chat_id,msg.id,'▪︎تم حفظ توكن البوت\n\n▪︎معلومات البوت:-\n\n• اسم البوت : ['..NameBot..']\n•معرف البوت : [@'..UserNameBot..']\n\n▪︎قم الان بأرسال معرف المطور مع @', 'md', false, false, false, false, reply_markup)
return false
end
end
end
if text == 'صنع بوت ➕' then
redis:set(bot_id.."Send:Token"..msg.chat_id..":"..msg.sender.user_id,'true') 
bot.sendText(msg.chat_id,msg.id,'▪︎قم بارسال توكن البوت الان',"md",true)  
return false
end
if redis:get(bot_id.."Del:Screen:And:Bot"..msg.chat_id..":"..msg.sender.user_id) == 'true' then
if text == 'إلغاء 🚫' then
local bl = '▪︎تم اللغاء الطلب بنجاح'
redis:del(bot_id.."Del:Screen:And:Bot"..msg.chat_id..":"..msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id,bl, 'md', false, false, false, false, reply_markup)
return false  
end 
if file_exia(text,'/root') then
if text == bot.getMe().username then 
bot.sendText(msg.chat_id,msg.id,'▪︎خطأ في معرف البوت تأكد منه', 'md')
return false 
end 
if text and text:match('(%S+)[Bb][Oo][Tt]') then 
redis:del(bot_id.."Del:Screen:And:Bot"..msg.chat_id..":"..msg.sender.user_id)
os.execute('cd && rm -fr '..text..' && screen -d -m -S del screen -S '..text..' -X kill')
bot.sendText(msg.chat_id,msg.id,'▪︎تم حذف وايقاف البوت بنجاح', 'md')
end
else
redis:del(bot_id.."Del:Screen:And:Bot"..msg.chat_id..":"..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,'▪︎عذرا لم يتم التعرف على البوت او لا يوجد', 'md')
end
end
if text == 'حذف بوت ➖' then
redis:set(bot_id.."Del:Screen:And:Bot"..msg.chat_id..":"..msg.sender.user_id,'true') 
bot.sendText(msg.chat_id,msg.id,'▪︎قم بأرسال معرف البوت الان', 'md')
return false
end
if text == 'المشتركين 👥' then
local i = 0
local t = '▪︎المشتركين \n — — — — —\n'
for v in io.popen('ls /root'):lines() do
if v then 
if v ~= bot.getMe().username then 
if v and v:match('(%S+)[Bb][Oo][Tt]') then 
i = i +1
t = t..'*'..i..'- * [@'..v..'] \n' 
elseif not v then 
t = '▪︎لا يوجد مشتركين.'
end
end 
end
end 
bot.sendText(msg.chat_id,msg.id,t, 'md')
return false
end
if redis:get(bot_id.."Del:Screen"..msg.chat_id..":"..msg.sender.user_id) == 'true' then
if text == 'إلغاء 🚫' then
redis:del(bot_id.."Del:Screen"..msg.chat_id..":"..msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id,'▪︎تم اللغاء الطلب بنجاح', 'md', false, false, false, false, reply_markup)
return false  
end 
if text and text:match('(%S+)[Bb][Oo][Tt]') then
if text == bot.getMe().username then 
bot.sendText(msg.chat_id,msg.id,'▪︎خطأ في معرف البوت تأكد منه', 'md', false, false, false, false, reply_markup)
return false 
end
redis:del(bot_id.."Del:Screen"..msg.chat_id..":"..msg.sender.user_id) 
os.execute('screen -S '..text..' -X kill')
bot.sendText(msg.chat_id,msg.id,'▪︎تم ايقاف تشغيل البوت بنجاح', 'md')
return false  
end 
end 
if text == 'ايقاف بوت 〰️' then
redis:set(bot_id.."Del:Screen"..msg.chat_id..":"..msg.sender.user_id,'true') 
bot.sendText(msg.chat_id,msg.id,'▪︎قم بارسال معرف البوت الان بدون @', 'md')
return false
end
if redis:get(bot_id.."op:Screen"..msg.chat_id..":"..msg.sender.user_id) == 'true' then
if text == 'إلغاء 🚫' then
redis:del(bot_id.."op:Screen"..msg.chat_id..":"..msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id,'▪︎تم اللغاء الطلب بنجاح', 'md', false, false, false, false, reply_markup)
return false  
end 
if file_exia(text,'/root') then
if text ~= bot.getMe().username then 
if text and text:match('(%S+)[Bb][Oo][Tt]') then 
redis:del(bot_id.."op:Screen"..msg.chat_id..":"..msg.sender.user_id) 
os.execute('cd && cd '..text..';screen -d -m -S '..text..' lua5.3 start.lua')
bot.sendText(msg.chat_id,msg.id,'▪︎تم تشغيل البوت بنجاح', 'md')
return false  
else
bot.sendText(msg.chat_id,msg.id,'▪︎المعرف غير مسجل لدي', 'md')
end 
else
bot.sendText(msg.chat_id,msg.id,'▪︎لا يمكنك عمل رن للمصنع الاساسي', 'md')
end 
else
bot.sendText(msg.chat_id,msg.id,'▪︎لا يوجد بوت مصنوع بهذا المعرف', 'md')
end 
end 
if text == 'تشغيل بوت 〰️' then
redis:set(bot_id.."op:Screen"..msg.chat_id..":"..msg.sender.user_id,'true') 
bot.sendText(msg.chat_id,msg.id,'▪︎قم بارسال معرف البوت بدون @ الان', 'md')
return false
end
if text == 'معلومات السيرفر ⚠️' then
bot.sendText(msg.chat_id,msg.id,"• Server Info .\n\n• Server Version : "..linux_version.."\n\n• Server CPU  : "..CPUPer.."\n\n• Server Ram : "..memUsedPrc.."\n\n• Server HardDesk : "..HardDisk.."\n\n• Server UpTime : "..uptime.."\n\n• Server User : "..whoami,"md",true)  
return false
end
end --- end devB(
end --- end type == "basicgroup"
end --- end Run(
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Call(data)
if data and data.luatele and data.luatele == "updateNewMessage" then
if data.message.sender.luatele == "messageSenderChat" then
return false
end
print(serpent.block(data, {comment=false}))  
Run(data.message,data)
elseif data and data.luatele and data.luatele == "updateMessageEdited" then
local msg = bot.getMessage(data.chat_id, data.message_id)
if tonumber(msg.sender.user_id) ~= tonumber(bot_id) then  
Run(msg,data)
end
elseif data and data.luatele and data.luatele == "updateNewCallbackQuery" then
---Callback(data)
elseif data and data.luatele and data.luatele == "updateMessageSendSucceeded" then
end --- end data
end --- end Call( 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
Runbot.run(Call)