##############################################
## Def für Dateizugriffe
##############################################
=begin
V1.0 einfache zugriffe

# V1.1 - überarbeiten, ein Methode - eine Aufgabe"
=end


# V1.1 - überarbeiten, ein Methode - eine Aufgabe"
# Gibt es die Datei?
# Return 
#		true = ja
#		false = nein
def exist_file(file = "")
	filename = "#{@prog_path}#{file}"
	return File.exist?(filename)
end

# V1.1 - überarbeiten, ein Methode - eine Aufgabe"
# Gibt es die Datei?
# Return
#	  OK: 	0 = 1 File gelöscht
#		oder: [1, "Anzahl der gelöschten Dateien: #{file}"]
def delete_file(file)
	# löschen der Datei!
	filename = "#{@prog_path}#{file}"
	file = File.delete(filename)
	if file == 1
		returnvalue = 0
	else
		returnvalue = [1, "Anzahl der gelöschten Dateien: #{file}"]
	end
	return returnvalue
end

# V1.1 - überarbeiten, ein Methode - eine Aufgabe"
# prüfe ob es die Datei gibt.
# Return 
#		OK: 	Inhalt der Datei ohne /n
#		oder: [1, "#{filename} existiert nicht"]	
def read_file(file)
	filename = "#{@prog_path}#{file}"
	if exist_file(file) == true
		file = File.open(filename)
		contents = ""
		file.each {|line|
  		contents << line
		}
		contents.gsub("\n", "")
	else
		contents = [1, "#{filename} existiert nicht"]
	end
	return contents
end	


# V1.1 - überarbeiten, ein Methode - eine Aufgabe"
# Schreibe Daten in die Datei
# Return 
#		OK: 	true = content wurde geschrieben
#		oder: false = Beim schreiben trat ein Fehler auf
def write_to_file(file, content)
	filename = "#{@prog_path}#{file}"
	puts "filename  #{filename}" if @debugging_on == true
	write = File.write(filename, content)
	if write == content.to_s.length
		returnvalue = true
	else
		returnvalue = false
	end
	return returnvalue
end


# V1.1 - überarbeiten, ein Methode - eine Aufgabe"
# Schreibe Daten in die Datei, angehängt
# Return 
#		Kein Return
def append_to_file(file, content)
  # ame Datei!
  filename = "#{@prog_path}#{file}"
  puts "filename  #{filename}"  if @debugging_on == true
	File.open(filename, "a+") { |f| f.puts(content) }
end


# V1.1 - überarbeiten, ein Methode - eine Aufgabe"
# erzeuge den storage_folder
# Return 
#		Kein Return
def create_storage_folder
	#system 'mkdir', '-p', #{@prog_path}
  `mkdir -p #{@prog_path}`
end	


# V1.1 - überarbeiten, ein Methode - eine Aufgabe"
# gibt es die Datei - fallse nein, lege sie mit dem Inhalt content an.
# Return 
#		Kein Return
def test_file_and_create(file, content)
	# gibt es die Datei?
	filename = "#{@prog_path}#{file}"
	if exist_file(file) == false
		File.open(filename, "w") { |f| f.puts(content) }
	end
end


