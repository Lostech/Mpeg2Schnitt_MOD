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


//In Unit "Hauptfenster.pas" in Funktion "procedure TMpegEdit.FormCreate(Sender: TObject);" nach Zeile
//  Mpeg2Fenster.Tempo := 1;
//2 Zeilen weiter folgende Zeile einfügen
//{$I MpegEditFormCreate2.inc}

  PXMenueItem:=TMenuItem.Create(MpegEdit);
  PXMenueItem.Caption:='ProjectX';
  Hauptmenue.Items.Insert(6,PXMenueItem);
  PXMenueItem2:=TMenuItem.Create(MpegEdit);
  PXMenueItem2.Caption:='Dateien mit ProjectX importieren';
  PXMenueItem2.OnClick:=ProjectXForm.Start;
  PXMenueItem.Add(PXMenueItem2);
  PXMenueItem3:=TMenuItem.Create(MpegEdit);
  PXMenueItem3.Caption:='ProjectX Pfad festlegen';
  PXMenueItem3.OnClick:=ProjectXForm.ProjectXPfadSetup;
  PXMenueItem.Add(PXMenueItem3);
  PXMenueItem4:=TMenuItem.Create(MpegEdit);
  PXMenueItem4.Caption:='ProjectX Ausgabe Ordner festlegen';
  PXMenueItem4.OnClick:=ProjectXForm.ProjectXAusgabeOrdnerSetup;
  PXMenueItem.Add(PXMenueItem4);
  PXMenueItem7:=TMenuItem.Create(MpegEdit);
  PXMenueItem7.Caption:='ProjectX Ausgabe Ordner aufräumen';
  PXMenueItem7.OnClick:=ProjectXForm.ProjectXAusgabeOrdnerAufraeumen;
  PXMenueItem.Add(PXMenueItem7);
  PXMenueItem9:=TMenuItem.Create(MpegEdit);
  PXMenueItem9.Caption:='ProjectX starten';
  PXMenueItem9.OnClick:=ProjectXForm.ProjectXaufrufen;
  PXMenueItem.Add(PXMenueItem9);
  PXMenueItem5:=TMenuItem.Create(MpegEdit);
  PXMenueItem5.Caption:='JAVA Pfad festlegen';
  PXMenueItem5.OnClick:=ProjectXForm.JavaPfadSetup;
  PXMenueItem.Add(PXMenueItem5);
  PXMenueItem8:=TMenuItem.Create(MpegEdit);
  PXMenueItem8.Caption:='Programmpfade automatisch suchen';
  PXMenueItem8.OnClick:=ProjectXForm.AutomatischePfadangaben;
  PXMenueItem.Add(PXMenueItem8);
  PXMenueItem6:=TMenuItem.Create(MpegEdit);
  PXMenueItem6.Caption:='Über MOD Extension ...';
  PXMenueItem6.OnClick:=ProjectXForm.About;
  HilfeMenu.Add(PXMenueItem6);

