# 19.07.13 added edit css option, thanks to sc0ttman!
my %pluglocale;
$pluglocale{'EN'}={
nobackup => "Could not back up Config file, changes not saved.",
saved => "Changes have been saved.",
nosaved => "Something went wrong, changes not saved.",
goindex => "Go to index",
try => "Try Again",
noopenconfig => "Could not open Config file",
noopencss => "Could not open style sheet",
changesettings => "Change the settings of the blog",
changestyle => "Change the style of the blog",
warning1 => "Warning! This might break the blog, check your changes carefully!",
warning2 => "Get me out of here!",
eCpassword => "Type in your password to change the settings of the blog:",
};
$pluglocale{'GER'}={
nobackup => "Konnte keine Sicherheitskopie der Konfigurationsdatei erstellen. Änderungen wurden nicht gespeichert.",
saved => "Änderungen wurden gespeichert.",
nosaved => "Es ist ein Fehler aufgetreten, die Änderungen wurden nicht gespeichert.",
goindex => "Startseite",
try => "Erneut veruchen",
noopenconfig => "Die Konfigurationsdatei konnte nicht geöffnet werden",
noopencss => "Die Stilvorlage konnte nicht geöffnet werden",
changesettings => "Die Blogeinstellungen ändern",
warning1 => "Vorsicht! Diese Aktion kann den Blog funktionsunfähig machen, überprüfen Sie ihre Änderungen sorgfälting!",
warning2 => "Ich will hier weg!",
changestyle => "Das Aussehen des Blogs verändern",
eCpassword => "Geben sie Ihr Passwort ein um die Blogeinstellungen zu verändern:",
};
$pluglocale{'EL'}={
editConfig => "Change settings",
nobackup => "Could not back up Config file, changes not saved.",
saved => "Changes have been saved.",
nosaved => "Something went wrong, changes not saved.",
goindex => "Επιστροφή στην αρχική σελίδα",
try => "Try Again",
noopenconfig => "Could not open Config file",
noopencss => "Could not open style sheet",
changesettings => "Change the settings of the blog",
changestyle => "Change the style of the blog",
warning1 => "Warning! This might break the blog, check your changes carefully!",
warning2 => "Get me out of here!",
eCpassword => "Type in your password to change the settings of the blog:",
};
$pluglocale{'ES'}={
nobackup => "No se pudo realizar copias de seguridad del archivo de configuración, los cambios no se han guardado.",
saved => "Los cambios se han guardado",
nosaved => "Algo falló, los cambios no se han guardado.",
goindex => "Ir al índice",
try => "inténtalo de nuevo",
noopenconfig => "No se pudo abrir el archivo de configuración",
noopencss => "No se pudo abrir la hoja de estilo",
changesettings => "Cambie la configuración del blog",
changestyle => "Cambiar el estilo del blog",
warning1 => "¡Advertencia! Esto podría romper el blog, ver sus cambios cuidadosamente! ",
warning2 => "¡Sáquenme de aquí!",
eCpassword => "Escriba la contraseña para cambiar la configuración del blog:",
};

$pluglocale{'CUSTOM'}=$pluglocale{'EN'};

if (r('process')eq 'editConfig')
{
	if (r('pass') eq $config_adminPass && r('confContent') ne ''){

		my $content = basic_r('confContent');
		my $which = r('which');
		my $file;
		$file = "$config_serverRoot$config_currentStyleFolder/$config_currentStyleSheet";
		
		if ($which eq "config"){
		$file = "$config_DatabaseFolder/pe_Config.pm";
		
		unless (rename ("$file", "$file.bak")){
			print '<br />'.$pluglocale{$lang}->{nobackup}.' <a href="?page=1">'.$locale{$lang}->{back}.'</a>';
			last;
			}
		}
		open (FILE, ">$file") or print $!.' <a href="?do=editConfig">'.$pluglocale{$lang}->{try}.'</a>?';
		print FILE $content and print '<br />'.$pluglocale{$lang}->{saved}.' <a href="?page=1">'.$pluglocale{$lang}->{goindex}.'</a>';
		close FILE;
	}
	else {print '<br />'.$pluglocale{$lang}->{nosaved}.' <a href="?do=editConfig">'.$pluglocale{$lang}->{try}.'</a>?';}
	
}

elsif (r('password') eq $config_adminPass){

	my $configFile = "$config_DatabaseFolder/pe_Config.pm";
	my $content = '';
	my $cssFile = "./$config_currentStyleFolder/$config_currentStyleSheet";
	my $css = '';
	my $pass = r('password');
	
	open (FILE, $configFile) or print $pluglocale{$lang}->{noopenconfig};
	while (<FILE>){$content .= $_;}
	close FILE;
	
	print '<form accept-charset="UTF-8" name="submitform" method="post">
		   <legend>'.$locale{$lang}->{changesettings}.'</legend>
		   <textarea name="confContent"  wrap="off" rows="30" id="confContent">'
		   .$content.
		  '</textarea><p>
		    '.$pluglocale{$lang}->{warning1}.'<a href="?page=1">'.$pluglocale{$lang}->{warning2}.'</a>
		   <input name="pass" type="hidden" id="pass" value="'.$pass.'">
		   <input name="which" type="hidden" id="which" value="config">
		   <input name="process" type="hidden" id="process" value="editConfig">
		   <input type="submit" name="Submit" type="hidden" value="'.$locale{$lang}->{edentry}.'"></p></form><br />';
		   
	open (FILE, $cssFile) or print $pluglocale{$lang}->{noopencss};
	while (<FILE>){$css .= $_;}
	close FILE;
	
	print '<form accept-charset="UTF-8" name="submitform" method="post">
		   <legend>'.$pluglocale{$lang}->{changestyle}.'</legend>
		   <textarea name="confContent" wrap="off" rows="30" id="confContent">'
		   .$css.
		  '</textarea><p>
		   <input name="pass" type="hidden" id="pass" value="'.$pass.'">
		   <input name="which" type="hidden" id="which" value="css">
		   <input name="process" type="hidden" id="process" value="editConfig">
		   <input type="submit" name="Submit" type="hidden" value="'.$locale{$lang}->{edentry}.'"></p></form>';
}
else {
	print '<form method="post" action="">
	<legend>'.$pluglocale{$lang}->{eCpassword}.'</legend>
	<input type="password" name="password">
	<input name="do" type="hidden" id="do" value="editConfig">
	<input type="submit" name="Submit" type="hidden" value="'.$locale{$lang}->{submit}.'"></form>';
}
1;	
