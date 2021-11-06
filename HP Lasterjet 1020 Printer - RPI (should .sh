HP Lasterjet 1020 Printer - RPI (should work on x86 also) + Wifi + AirPrint + Android 
sudo apt install samba 
sudo apt install cups 
sudo usermod -a -G lpadmin pi 
sudo cupsctl --remote-any 
sudo /etc/init.d/cups restart 
sudo apt install cups printer-driver-foo2zjs 
sudo apt install hplip 
sudo hp-plugin https://127.0.0.1:631/admin/ > Add printer > Share Local connection: HP LaserJet 1020 USB FN16XLQ HPLIP 

sudo nano /etc/samba/smb.conf 
# CUPS printing.  See also the cupsaddsmb(8) manpage in the
# cupsys-client package.
printing = cups
printcap name = cups
[printers]
comment = All Printers
browseable = no
path = /var/spool/samba
printable = yes
guest ok = yes
read only = yes
create mask = 0700

# Windows clients look for this share name as a source of downloadable
# printer drivers
	[print$]
	comment = Printer Drivers
	path = /usr/share/cups/drivers
	browseable = yes
	read only = yes
	guest ok = no
	workgroup = your_workgroup_name
	wins support = yes


sudo systemctl restart smbd
sudo apt-get install avahi-discover

https://pimylifeup.com/raspberry-pi-airprint/