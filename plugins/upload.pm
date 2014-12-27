my %pluglocale;

$pluglocale{"EN"}={
unsupported=>"Unsupported characters in the filename. Your filename may only contain alphabetic characters, numbers and the characters",
extension => "File type not allowed. Allowed are: @config_allowedMime",
noopenup=>"Couldn't open $output_file for writing: ",
saveup=>"File saved to ",
folder=>"Folders",
file => "File(s) to upload",
};
$pluglocale{"GER"}={
unsupported =>"Unerlaubte Zeichen im Dateinamen. Er darf nur Buchstaben, Zahlen und die volgenden Zeichen beinhalten",
extension => "Dateityp nicht erlaubt. Erlaubt sind: @config_allowedMime",
noopenup=>"$output_file konnte nicht geöffnet werden",
saveup=>"Datei gespeichert unter",
folder=>"Ordner",
file => "Dateien hochladen",
};
$pluglocale{"ES"}={
unsupported =>"Caracteres no admitidos en el nombre del archivo. Su nombre sólo puede contener caracteres alfabéticos, números y los caracteres",
extension => "Tipo de archivo no permitido. Con los tipos MIME son: @config_allowedMime",
noopenup=>"No puede abrir $output_file para escribir: ",
saveup=>"Archivo guardado en",
folder=>"Carpetas",
file => "Archivo para cargar",
};
$pluglocale{"EL"}=$pluglocale{"EN"};
$pluglocale{"CUSTOM"}=$pluglocale{"EN"};

print '<h1>'.$locale{$lang}->{upload}.'</h1>';

if (r('process') eq 'upload')
{
	my @filename = upload('filename');
	my $folder = r('folder');
	my $out_folder = $config_serverRoot.$folder;
	my ($bytesread, $buffer);
    my $numbytes = 1024;
    my $do = 1;
  
	if(!(opendir(DIR, $out_folder))) # create the folder if it does not exist
	{
		mkdir($out_folder, 0755);
	}
	
	foreach my $file(@filename)
	{
		my $output_file = $config_serverRoot.$folder.$file;  
		my $type = uploadInfo($file)->{'Content-Type'}; 
		
		if (defined $file) {
			# Upgrade the handle to one compatible with IO::Handle:
			$io_file = $file->handle;
		}
			# check for unsupported charcters
		unless($file =~ /^([-\@:\/\\\w.]+)$/) { 
			print "$pluglocale{$lang}->{unsupported} '_', '-', '\@', '/', '\\','.'";
			$do=0;  
			}
			#check for allowed mime types
	unless (grep {$type =~ /$_(.+?)/} @config_allowedMime){
		print "$pluglocale{$lang}->{extension}";
		$do=0;
	}

	
		#write file
		if ($do==1){
			open (OUTFILE, ">", "$output_file") or print "$pluglocale{$lang}->{noopenup} $!";
			while ($bytesread = $io_file->read($buffer, $numbytes)) 
				{print OUTFILE $buffer;}
			
			close OUTFILE and print "$pluglocale{$lang}->{saveup} $output_file <br />";
			}
		}
}
	

print '<form method="post" action="http://'.$ENV{HTTP_HOST}.$ENV{REQUEST_URI}.'" enctype="multipart/form-data" accept-charset="UTF-8">
<p><label for="file">'.$pluglocale{$lang}->{file}.'</label>
<input type="file" name="filename" multiple /></p>
<p><label>'.$pluglocale{$lang}->{folder}.'</label><select name="folder"/>';

#show upload folders and subfolders (2 levels)
foreach $fol(@config_uploadFolders){ 
	@recurse = <$config_serverRoot$fol*>; 
	foreach $rec(@recurse){
		my $name = $rec;
		$name =~ s/$config_serverRoot(.+?)/$1/;
		print '<option>'.$name.'/</option>' if -d $rec;
		@recurse2 = <$rec/*>;
		foreach $rec2(@recurse2){
			my $name2 = $rec2;
			$name2 =~ s/$config_serverRoot(.+?)/$1/;
			print '<option>'.$name2.'/</option>' if -d $rec2;
		}
		
	}
	
}
print'</select></p>
<p><input type="hidden" name="process" value="upload" id="process" />
<input type="submit" name="Submit" value='.$locale{$lang}->{submit}.' /></p>
</form>';



	


