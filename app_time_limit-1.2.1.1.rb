#!/usr/bin/env ruby
#
#
=begin
Aufgabe des Skript ist es die Zeit ausgewählter Programme zu kontrollieren und 
bei Überschreiten des Zeit-Limit die Anwendung zu schließen.
Idee und Inspiration
http://askubuntu.com/questions/726544/how-can-i-limit-or-restrict-access-to-an-application


benötigz ruby tk
sudo apt-get install libtcltk-ruby

Dazu wird die Datei 
app_time_limit.rb.desktop

		[Desktop Entry]
		Type=Application
		Exec=/usr/share/app_time_control/app_time_limit
		Hidden=false
		NoDisplay=false
		X-GNOME-Autostart-enabled=true
		Name[de_DE]=time_use
		Name=time_use
		Comment[de_DE]=
		Comment= 

in /usr/share/applications kopieren.

Die Skripte/icon liegen unter 
/usr/share/app_time_limit/app_time_limit.rb

Dateien:
app_time_limit.rb
lib/class.atl_user.rb
lib/lib.atl_file-1.0.rb
lib/lib.atl_gui-1.0.rb
pics/icon_atl.gif
pics/atl_logo.giv



Nutzdaten der User werden in
V1.0 in Verzeichnis /home/user/Dokumente/.atl_use/ abgelegt
	Da die Dateien mit User-Rechten erstellt werden ist das ein Sicherheitsrisiko.
	Da es sich aber um Linux-Un-Erfahrene Benutzer handelt ist es unwharscheinlich, 
	dass die Nutzdateien manupuliert werden.
V1.1 Versionen eingebaut 
				lib.atl_file-1.0.rb 
				lib.atl_gui-1.0.rb 
				erstellt
V1.2 User in Hash angelegt
			Fehrer: 
				applog wir nicht angelegt! Fehler in lib.atl_file-1.0.rb 
				degugging_on readfile wird angezeigt
				lara hat exit button
V1.2.0.2 Dieser Fehler sind behoben
				
#@version = "V1.1.0.1 - Version"
#@version = "V1.1.0.2 - new GUI"
#@version = "V1.1.0.3 - new path"
#@version = "V1.2.0.1 - User Hash"
#@version = "V1.2.0.2 - some bugs"
=end	 
@version = "V1.2.1.1 - lib_atl_user-1.2.rb"


# Pfade definieren
# V1.1
# Scriptpfad
#script_devel_path = "/home/ralf/Dokumente/ruby/app_time_limit"
#script_path = script_devel_path 
script_path = "/usr/share/app_time_limit"

# nachgeladene Dateien und Requirements
require 'tk'

# ausgelagerte Funktionen
require "#{script_path}/lib/lib.atl_file-1.1.rb"
require "#{script_path}/lib/lib.atl_gui-1.0.rb"
require "#{script_path}/lib/lib.atl_user-1.2.rb"

# user_class
require "#{script_path}/lib/class.atl_user.rb"

##################################################################
###
###        Variablen
###
##################################################################

# Anwendungen die für das Zeitlimit zählen. 
app_list = ["firefox", "chrome", "pinta"]

# User, für das Script gelten soll.
@atl_user = Hash.new
# USER  = [name, "restricted: yes/no", "hardlimit: 90min", "softlimit: 60min", "Exit-Button: yes/no"] 
@atl_user["ralf"] = ATLUser.new("ralf", false, 120, 90, true)
@atl_user["jac"] = ATLUser.new("jac", true, 120, 90, true)
@atl_user["lara"] = ATLUser.new("lara", true, 65, 60, false)
@atl_user["coralie"] = ATLUser.new("coralie", true, 65, 60, false)



##################################################################
###
###        ab hier sollten keine Änderungen nötig sein
###
##################################################################

# Ort an dem die Daten abgelegt werden
user = ENV['USER']
puts user if @debugging_on == true
@prog_path = "/home/#{user}/Dokumente/.atl_use/"

# Wichtige Variablen der Klasse
uselog = "uselog" 		# File für den Counter
datefile = "currdate" #	File für das Datum
applog = "applog"			# ein Log-File für die verwendeten Apps
do_app_log = true			# Bool um das Log ein bzw. auszuschalten
debugfile = "debug"		# File um Debugging ein bzw. auszuschalten
@debugging_on = true  # Sollen Puts auf die Konsole gehen?

# Alle interval Sekunden wird das überprüft
interval = 10
warnstufe = "green"

# Counter für das loggen.
# last_write = 6 bedeute alle 6 Zähler wird geloggt
last_write =  6

# falls es den user nicht gibt machen einen default_user
set_user(user) if does_user_exist(user) == false

# user mit limit
resticted_user = get_resticted_user
# user die den exit-button benutzen dürfen
exit_button_user = get_exit_button_user

# hole die aktuelle Zeit
time1 = Time.new


####################################
## Dateien testen und ggf anlegen
####################################

# ist der Ordner angelegt?
# falls nein anlegen!
create_storage_folder if exist_file() == false

# Teste and Create, falls erforderlich uselog and datefile 
test_file_and_create(datefile, time1.day.to_i)
test_file_and_create(uselog, 1)
test_file_and_create(debugfile, "off")

# Teste and Create, falls erforderlich. Schreibe das Datum  
if read_file(applog)[0] == 1
  test_file_and_create(applog, 	"Start #{time1.strftime("%d-%m-%Y %H:%M:%S")}")
	append_to_file(applog, "\n ----- \n")
else
	append_to_file(applog, "\n#{time1.strftime("%d-%m-%Y %H:%M:%S")}\n")
end


####################################
## GUI definieren
####################################

#root = TkRoot.new
root = TkRoot.new {
	title "App-Time-Limit "
	background "#aee3ae"
}
#Verhindern, dass das Fenster geschlossen wird
root.protocol("WM_DELETE_WINDOW", proc { close_window_forbidden })
#root.protocol("WM_DELETE_WINDOW", proc { close_window_allowed(root) })

#Icon setzen 
atl_icon_path = "#{script_path}/pics/icon_atl.gif"
atl_icon = TkPhotoImage.new('file' => atl_icon_path) 
root.iconphoto(atl_icon)

label_pic = TkPhotoImage.new
label_pic.file = "#{script_path}/pics/atl_logo.gif"

if exit_button_user.include?(user) == true
	exit =  TkButton.new(root) {
		text "Exit"
		#command "exit"
		command "close_window_allowed"
		background "orange"
	 	grid('row'=>1, 'column'=>0)
	}
end
label_bild = TkLabel.new(root){
	image label_pic
	background "light blue"
	height 32 
  width 32 
  grid('row'=>0, 'column'=>0)
} 
#code to add a label widget
label1=TkLabel.new(root){
   text @version
   foreground "blue"
   background "#aee3ae"
   grid('row'=>0, 'column'=>1)
}
#label1.text = "#{@version} 2"
      	    
#code to add a frame
frame = TkFrame.new(root){
  relief 'flat' #'sunken'
  borderwidth 8
  background "green"
  grid('row'=>1, 'column'=>1)
}
textfeld = TkText.new(frame) {
  width 30
  height 2
  borderwidth 2
  font TkFont.new('times 12 bold')
  grid('row'=>1, 'column'=>1)
}
text2 = TkText.new(frame) {
  width 30
  height 2
  borderwidth 2
  font TkFont.new('times 12 bold')
  grid('row'=>2, 'column'=>1)
}

puts "Main - #{Thread.current}"
mainthread = Thread.current
####################################
## GUI Ende
####################################

=begin
# Das tut!
b = Thread.new {
n = 0
while true
	n +=1
	insert_text(textfeld, "Textfeld - #{n}")
	insert_text(text2, "Text 2 - #{n}")
	puts "n = #{n}"
	sleep(2)
end
}
=end


##################################################
## Die Schleife
##################################################
schleife = Thread.new {
	# Zeitlimit in Minuten
	minutes = @atl_user[user].get_softlimit # 60
	hardlimit = @atl_user[user].get_hardlimit 
	# hole das aktuell gespeicherte Datum 
	currday1 = read_file(datefile)

	# hole den aktuellen Zähler
	n = read_file(uselog).to_i
	puts "n = #{n}"

	while true #(textfield.exist? rescue false) and resticted_user.include?(user) == true
		currday2 = time1.day.to_i
		puts "Schleife - #{schleife.status}" if ["run", "sleep"].include?(mainthread.status) == true
		puts "Schleife - #{Thread.current}"
		puts "Mainthread Status #{mainthread.status}" 
		
	
		# Checke neuer Tag?
		if currday1.to_i != currday2.to_i
			puts "Neuer Tag!"  if @debugging_on == true
			deletefile = delete_file(datefile)
			writefile = write_to_file(datefile, time1.day.to_i)
			deletefile = delete_file(uselog)
			writefile = write_to_file(uselog, 1)
			n = 1
			currday1 = currday2
		end
	
		#@debugging_on = true if read_file(debugfile) == "on" 
		#@debugging_on = false if read_file(debugfile) == "off"
		#puts " debugging_on = #{@debugging_on} - readfile = >#{read_file(debugfile)}<" 
	
		# Welche PID haben die überwachten Programme?
		pid = []
		app_list.each { |app|
			try_pid = `pgrep #{app}`
			#pid << try_pid.chomp
			if try_pid.include?("\n") == true
				all_pids = try_pid.split("\n")
				puts "mehrere pids - #{all_pids}" if @debugging_on == true
				all_pids.each { |value| pid << value }
			else
				if try_pid != ""
					pid << try_pid	
				end
			end
			puts "#{app} all_pids = #{all_pids}" if @debugging_on == true
			if last_write == 6 and do_app_log == true
			
				append_to_file(applog,"#{time1.strftime("%d-%m-%Y %H:%M:%S")}, n=#{n}:  #{app} - #{all_pids}")
			end
		}
		append_to_file(applog,"#{time1.strftime("%d-%m-%Y %H:%M:%S")}, n=#{n}:  #{pid}")
		last_write == 6 ? last_write = 1 : last_write += 1

		n = read_file(uselog).to_i
		# Falls eines der überwachten Programme aktiv ist: -> n+1
		if pid.size > 0
			n += 1
			write_to_file(uselog, n)
		end
	
	 	puts "n = #{n}" if @debugging_on == true
	 	
	 	# Ausgabe in die Gui
	 	rest_minuten = minutes - (n/6)
		insert_text(textfeld, "Maximale Zeit: #{minutes} Minuten \nVerbleiben ca. #{rest_minuten} Minuten")
	 	insert_text(text2, "Verstrichene Zyklen: #{n} von #{minutes * (60 / interval)}") 
	 	if n > (minutes * 0.80) * (60 / interval) and warnstufe == "green"
			frame.background = "yellow"
			warnstufe = "yellow"
		end
		if n > (minutes) * (60 / interval) 
			frame.background = "red"
			time_left = hardlimit - (n * interval / 60)
		 	insert_text(text2, "Limit erreicht, #{hardlimit} Programme werden in #{time_left} Minuten geschlossen.") 
		end
	 	
	 	# Warte Interval
		sleep(interval)

		# Zeit ist um, dann kill Programm XX
		if n > hardlimit * (60 / interval) 
			pid.each { |single_pid| 
				cmd = `kill #{single_pid.to_i}` if single_pid.to_i > 0
				puts "kill #{single_pid.to_i} - Erfolg: #{$1.to_i}"  if @debugging_on == true
			}
		end
	end
}


# Für das GUI
Tk.mainloop

