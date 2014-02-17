{-----------------------------------------------------------------------------------
Diese INC Datei ist Teil der MOD Extension (Erweiterung) des Programms Mpeg2Schnitt.

Das Programm Mpeg2Schnitt ist ein einfaches Schnittprogramm (nur harte Schnitte) für
Mpeg2Video-Dateien und Mpeg2- und AC3Ton-Dateien.

Copyright (C) 2003  Martin Dienert
 Homepage: http:www.mdienert.de/mpeg2schnitt/
 E-Mail:   m.dienert@gmx.de

Die MOD Extension erlaubt die Integration von ProjectX
(ProjectX - a free Java based demux utility -> sourceforge.net/projects/project-x/)
im Mpeg2Schnitt Programm.

MOD Extension Copyright (C) 2006  Lostech
 Homepage: http://www.lostech.de.vu
 E-Mail:   lostech@gmx.de

This program is free software; you can redistribute it and/or modify it under the terms
of the GNU General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program;
if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.


Auf Deutsch:
Dieses Programm ist freie Software. Sie können es unter den Bedingungen
der GNU General Public License, wie von der Free Software Foundation veröffentlicht,
weitergeben und/oder modifizieren, entweder gemäß Version 2 der Lizenz oder
(nach Ihrer Option) jeder späteren Version.

Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß es Ihnen von Nutzen
sein wird, aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite Garantie der MARKTREIFE
oder der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK. Details finden Sie in der
GNU General Public License.

Sie sollten eine Kopie der GNU General Public License zusammen mit diesem Programm erhalten haben.
Falls nicht, schreiben Sie an die Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.

--------------------------------------------------------------------------------------}

//In Unit "Hauptfenster.pas" nach Zeile
//  MpegEdit: TMpegEdit;
//folgende Zeile einfügen
//{$I MpegEditFormCreate.inc}

  PXMenueItem: TMenuItem;
  PXMenueItem2: TMenuItem;
  PXMenueItem3: TMenuItem;
  PXMenueItem4: TMenuItem;
  PXMenueItem5: TMenuItem;
  PXMenueItem6: TMenuItem;
  PXMenueItem7: TMenuItem;
  PXMenueItem8: TMenuItem;
  PXMenueItem9: TMenuItem;

