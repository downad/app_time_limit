##############################################
## Def für Gui
##############################################	
# Ausgabe falls das Fenster geschlossen wird 

def close_window_forbidden
	Tk.messageBox( :message=>'Das Schließen ist nicht erlaubt!')
end

def close_window_allowed(root = false)
  if root != false
  	root.withdraw 
  end
  Thread.new do
    sleep 1
    Tk.exit
    Kernel.exit!
  end
  nil
end

def insert_text(textfeld, content)
	textfeld.value = content
end

