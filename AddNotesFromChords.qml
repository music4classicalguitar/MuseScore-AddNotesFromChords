//=============================================================================
//  MuseScore
//  Music Composition & Notation
//
//  Copyright (C) 2012-2017 Werner Schweer
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2
//  as published by the Free Software Foundation and appearing in
//  the file LICENCE.GPL
//=============================================================================

import QtQuick 2.2
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.1
import MuseScore 1.0

MuseScore {
	version:  "1.0"
	description: "Add notes from harmonies/chords"	
	menuPath: "Plugins.Add notes from chords"
	pluginType: "dialog"

	id:window
	width:  320; height: 270;
	
	Label {
		id: textHeader
		width: 250
		wrapMode: Text.WordWrap
		text: qsTr("Add notes from chords to :")
		font.pointSize:13
		anchors.top: window.top
		anchors.left: window.left
		anchors.topMargin: 5
		anchors.leftMargin: 5
	}
	Label {
		id: labelStaffOut
		width: 180
		wrapMode: Text.WordWrap
		text: qsTr("Staff")
		font.pointSize:13
		anchors.top: textHeader.bottom
		anchors.left: window.left
		anchors.topMargin: 5
		anchors.leftMargin: 5
	}
	TextField {
		id: staffOut
		width: 40
		text: Number(curScore.nstaves)
		validator: IntValidator{bottom: 1; top: curScore.nstaves;}
		anchors.top: textHeader.bottom
		anchors.left: labelStaffOut.right
		anchors.topMargin: 5
		anchors.rightMargin: 5
	}
	Label {
		id: labelVoiceOut
		width: 180
		wrapMode: Text.WordWrap
		text: qsTr("Voice")
		font.pointSize:13
		anchors.top: labelStaffOut.bottom
		anchors.left: window.left
		anchors.topMargin: 5
		anchors.leftMargin: 5
	}
	ComboBox {
    	id: comboBoxVoiceOut
    	width: 60
    	currentIndex: 3
   	 	model: ListModel {
        	id: comboBoxVoiceId
        	ListElement { text: "1"; }
        	ListElement { text: "2"; }
        	ListElement { text: "3"; }
        	ListElement { text: "4"; }
     	}
		anchors.top: staffOut.bottom
		anchors.left: labelVoiceOut.right
		anchors.topMargin: 5
		anchors.rightMargin: 5
	}
	Label {
		id: labelOverwriteVoice
		width: 180
		wrapMode: Text.WordWrap
		text: qsTr("Overwrite existing notes ? ")
		font.pointSize:13
		anchors.top: labelVoiceOut.bottom
		anchors.left: window.left
		anchors.topMargin: 15
		anchors.leftMargin: 5
	}
	CheckBox {
		id: overwriteVoice
        checked: false
		anchors.top: labelVoiceOut.bottom
		anchors.left: labelOverwriteVoice.right
		anchors.topMargin: 15
		anchors.rightMargin: 5
    }
	Label {
		id: labelOctaves
		width: 180
		wrapMode: Text.WordWrap
		text: qsTr("(Scientific Pitch Notation)\nLowest note >=")
		font.pointSize:13
		anchors.top: labelOverwriteVoice.bottom
		anchors.left: window.left
		anchors.topMargin: 10
		anchors.leftMargin: 5
	}
    ComboBox {
    	id: comboBoxOctaves
    	width: 60
    	currentIndex: 5
   	 	model: ListModel {
        	id: comboBoxOctaveId
        	ListElement { text: "C8"; }
        	ListElement { text: "C7"; }
        	ListElement { text: "C6"; }
        	ListElement { text: "C5"; }
        	ListElement { text: "C4"; }
        	ListElement { text: "C3"; }
        	ListElement { text: "C2"; }
        	ListElement { text: "C1"; }
    	}
		anchors.top: overwriteVoice.bottom
		anchors.left: labelOctaves.right
		anchors.topMargin: 5
		anchors.rightMargin: 5
	}
	Label {
		id: textMessage
		wrapMode: Text.WordWrap
		color: "black"
		width: 300
		text: qsTr("If chords are not recognized only the root and possible bass note (after a forward slash) are added.")
		anchors.top: labelOctaves.bottom
		anchors.left: window.left
		anchors.topMargin: 10
		anchors.leftMargin: 5
	}
	Button {
		id : buttonOK
		width: 120
		text: qsTr("OK")
		anchors.bottom: window.bottom
		anchors.left: window.left
		anchors.rightMargin: 5
		anchors.bottomMargin: 5
		onClicked: {
			var message=apply();
			if (message) {
				textMessage.color="red";
				textMessage.text=message[0];
				if (message[1]) buttonOK.visible=false;
			}
			else Qt.quit();
		}
	}
	Button {
		id : buttonCancel
		width: 120
		text: qsTr("Cancel")
		anchors.bottom: window.bottom
		anchors.right: window.right
		anchors.leftMargin: 5
		anchors.bottomMargin: 5
		onClicked: {
			Qt.quit()
		}
	}

	// See libmscore/segment.h
	function segmentTypeToString(segType) {
		var segmentTypes = Object.freeze({
			0x0000: 'Invalid',
			0x0001: 'Clef',
			0x0002: 'KeySig',
			0x0004: 'Ambitus',
			0x0008: 'TimeSig',
			0x0010: 'StartRepeatBarLine',
			0x0020: 'BarLine',
			0x0040: 'Breath',
			0x0080: 'ChordRest',
			0x0100: 'EndBarLine',
			0x0200: 'KeySigAnnounce',
			0x0400: 'TimeSigAnnounce'
		});
		return segmentTypes[segType];
	}
	
	// See libmscore/element.h
	function elementTypeToString(elType) {
		var elementTypes = Object.freeze([
			'Invalid',
			'Symbol',
			'Text',
			'Instrument Name',
			'Slur Segment',
			'Staff Lines',
			'Bar Line',
			'Stem Slash',
			'Line',

			'Arpeggio',
			'Accidental',
			'Stem',
			'Note',
			'Clef',
			'Keysig',
			'Ambitus',
			'Timesig',
			'Rest',
			'Breath',

			'Repeat Measure',
			'Image',
			'Tie',
			'Articulation',
			'Chordline',
			'Dynamic',
			'Beam',
			'Hook',
			'Lyrics',
			'Figured Bass',

			'Marker',
			'Jump',
			'Fingering',
			'Tuplet',
			'Tempo Text',
			'Staff Text',
			'Rehearsal Mark',
			'Instrument Change',
			'Harmony',
			'Fret Diagram',
			'Bend',
			'Tremolobar',
			'Volta',
			'Hairpin segment',
			'Ottava segment',
			'Trill segment',
			'Textline segment',
			'Volta segment',
			'Pedal segment',
			'Lyricsline segment',
			'Glissando segment',
			'Layout Break',
			'Spacer',
			'Staff State',
			'Ledger Line',
			'Notehead',
			'Notedot',
			'Tremolo',
			'Measure',
			'Selection',
			'Lasso',
			'Shadow Note',
			'Tab Duration Symbol',
			'FSymbol',
			'Page',
			'Hairpin',
			'Ottava',
			'Pedal',
			'Trill',
			'Textline',
			'Noteline',
			'Lyricsline',
			'Glissando',
			'Bracket',

			'Segment',
			'System',
			'Compound',
			'Chord',
			'Slur',
			'Element',
			'Element list',
			'Staff list',
			'Measure list',
			'Hbox',
			'Vbox',
			'Tbox',
			'Fbox',
			'Icon',
			'Ossia',
			'Bagpipe Embellishment',

			'MAXTYPE'
		]);
		return elementTypes[elType];
	}
	
	function tpcAndNoteName(value, searchCol) {
		var tpcsAndNoteNames = [
			[-1, "Fbb"], [0, "Cbb"], [1, "Gbb"], [2, "Dbb"], [3, "Abb"], [4, "Ebb"], [5, "Bbb"],
			[6, "Fb"], [7, "Cb"], [8, "Gb"], [9, "Db"], [10, "Ab"], [11, "Eb"], [12, "Bb"], 
			[13, "F"], [14, "C"], [15, "G"], [16, "D"], [17, "A"], [18, "E"], [19, "B"], 
			[20, "F#"], [21, "C#"], [22, "G#"], [23, "D#"], [24, "A#"], [25, "E#"], [26, "B#"],
			[27, "F##"], [28, "C##"], [29, "G##"], [30, "D##"], [31, "A##"], [32, "E##"], [33, "B##"]
		];
		for (var i=0;i<tpcsAndNoteNames.length;++i) {
			if (value==tpcsAndNoteNames[i][searchCol]) return tpcsAndNoteNames[i][1-searchCol] ;
		}
	}

	// created from chords.xml
	function chordIdAndName(value,searchCol) {
		var chordids= [
			[1,""],
			[2,"Maj"],
			[3,"5b"],
			[4,"+"],
			[5,"6"],
			[6,"Maj7"],
			[7,"Maj9"],
			[8,"Maj9#11"],
			[9,"Maj13#11"],
			[10,"Maj13"],
			[11,"Maj9(no 3)"],
			[12,"+"],
			[13,"Maj7#5"],
			[14,"69"],
			[15,"2"],
			[16,"m"],
			[17,"m+"],
			[18,"mMaj7"],
			[19,"m7"],
			[20,"m9"],
			[21,"m11"],
			[22,"m13"],
			[23,"m6"],
			[24,"m#5"],
			[25,"m7#5"],
			[26,"m69"],
			[27,"Lyd"],
			[28,"Maj7Lyd"],
			[29,"Maj7b5"],
			[32,"m7b5"],
			[33,"dim"],
			[34,"m9b5"],
			[40,"5"],
			[56,"7+"],
			[57,"9+"],
			[58,"13+"],
			[59,"(blues)"],
			[60,"7(Blues)"],
			[64,"7"],
			[65,"13"],
			[66,"7b13"],
			[67,"7#11"],
			[68,"13#11"],
			[69,"7#11b13"],
			[70,"9"],
			[72,"9b13"],
			[73,"9#11"],
			[74,"13#11"],
			[75,"9#11b13"],
			[76,"7b9"],
			[77,"13b9"],
			[78,"7b9b13"],
			[79,"7b9#11"],
			[80,"13b9#11"],
			[81,"7b9#11b13"],
			[82,"7#9"],
			[83,"13#9"],
			[84,"7#9b13"],
			[85,"9#11"],
			[86,"13#9#11"],
			[87,"7#9#11b13"],
			[88,"7b5"],
			[89,"13b5"],
			[90,"7b5b13"],
			[91,"9b5"],
			[92,"9b5b13"],
			[93,"7b5b9"],
			[94,"13b5b9"],
			[95,"7b5b9b13"],
			[96,"7b5#9"],
			[97,"13b5#9"],
			[98,"7b5#9b13"],
			[99,"7#5"],
			[100,"13#5"],
			[101,"7#5#11"],
			[102,"13#5#11"],
			[103,"9#5"],
			[104,"9#5#11"],
			[105,"7#5b9"],
			[106,"13#5b9"],
			[107,"7#5b9#11"],
			[108,"13#5b9#11"],
			[109,"7#5#9"],
			[110,"13#5#9#11"],
			[111,"7#5#9#11"],
			[112,"13#5#9#11"],
			[113,"7alt"],
			[128,"7sus"],
			[129,"13sus"],
			[130,"7susb13"],
			[131,"7sus#11"],
			[132,"13sus#11"],
			[133,"7sus#11b13"],
			[134,"9sus"],
			[135,"9susb13"],
			[136,"9sus#11"],
			[137,"13sus#11"],
			[138,"13sus#11"],
			[139,"9sus#11b13"],
			[140,"7susb9"],
			[141,"13susb9"],
			[142,"7susb9b13"],
			[143,"7susb9#11"],
			[144,"13susb9#11"],
			[145,"7susb9#11b13"],
			[146,"7sus#9"],
			[147,"13sus#9"],
			[148,"7sus#9b13"],
			[149,"9sus#11"],
			[150,"13sus#9#11"],
			[151,"7sus#9#11b13"],
			[152,"7susb5"],
			[153,"13susb5"],
			[154,"7susb5b13"],
			[155,"9susb5"],
			[156,"9susb5b13"],
			[157,"7susb5b9"],
			[158,"13susb5b9"],
			[159,"7susb5b9b13"],
			[160,"7susb5#9"],
			[161,"13susb5#9"],
			[162,"7susb5#9b13"],
			[163,"7sus#5"],
			[164,"13sus#5"],
			[165,"7sus#5#11"],
			[166,"13sus#5#11"],
			[167,"9sus#5"],
			[168,"9sus#5#11"],
			[169,"7sus#5b9"],
			[170,"13sus#5b9"],
			[171,"7sus#5b9#11"],
			[172,"13sus#5b9#11"],
			[173,"7sus#5#9"],
			[174,"13sus#5#9#11"],
			[175,"7sus#5#9#11"],
			[176,"13sus#5#9#11"],
			[177,"4"],
			[184,"sus"],
			[185,"dim7"],
			[186,"sus2"],
			[187,"maddb13"],
			[188,"add#13"],
			[189,"add#11#13"],
			[190,"add#13"],
			[191,"6add9"],
			[192,"sus4"],
			[193,"11"],
			[194,"Maj11"],
			[195,"Tristan"],
			[196,"m7add11"],
			[197,"Maj7add13"],
			[198,"madd9"],
			[199,"m9Maj7"],
			[200,"5"],
			[201,"m11b5"],
			[202,"dim7add#7"],
			[203,"aug9"],
			[204,"omit5"],
			[205,"aug7"],
			[206,"aug9"],
			[207,"aug13"],
			[210,"Maj7#11"],
			[211,"Maj9#5"],
			[212,"Maj7#9"],
			[213,"add2"],
			[214,"add9"],
			[215,"susb9"],
			[216,"Maj7sus"],
			[217,"Maj9sus"],
			[220,"m7b9"],
			[221,"m7b13"],
			[222,"Phryg"],
			[223,"madd2"],
			[230,"7b9#9"],
			[240,"sus#4"],
			[241,"Maj7b13"]
		];

			for (var i=0;i<chordids.length;++i) {
				if (value==chordids[i][searchCol]) return chordids[i][1-searchCol];
			}
			return null;
	}

	function transposeTpcArray(tpcArray,transposeTo,useDoubleSharpsFlats) {
		if (tpcArray == null) return new Array();
		var diff=14-transposeTo;
		var tpcNewArray=new Array() ;
		var n;
		for (var i=0;i<tpcArray.length;++i) {
			n=tpcArray[i]-diff;
			if (useDoubleSharpsFlats) {
				while (n<-1) n+=12;
				while (n>33) n-=12;
			} else {
				while (n<6) n+=12;
				while (n>26) n-=12;
			}
			tpcNewArray[i]=n;
		}
		return tpcNewArray;
	}

	/** create and return a new Note element with given (midi) pitch, tpc1, tpc2 and headtype */
	function createNote(pitch, tpc1, tpc2, head) {
		var note = newElement(Element.NOTE);
		note.pitch = pitch;
		note.tpc1 = tpc1;
		note.tpc2 = tpc2;
		if (head) note.headType = head; 
		else note.headType = NoteHead.HEAD_AUTO;
		return note;
	}
	
	// see https://en.wikipedia.org/wiki/Chord_names_and_symbols_(popular_music)
	function parseChord(chord,debug) {
		var chordrest;
		var lowerCaseMinorChords=false;
		var noteSpelling;
		var root="", qualifierMatch="", qualifier="", alteration="", base="", n1="C", n2="", n3="", n5="", n6="", n7="", n9="", n11="", n13="";
		if (debug) console.log("   chord : '"+chord+"'");
		// root
		var pattern=/^[ABCDEFGabcdefg]((##)|x|(bb)|b)?/;
		var match=pattern.exec(chord);
		if (match) {
			root=match[0];
			chordrest=chord.substring(match.index+match[0].length);
			if (debug) console.log("   chordrest : '"+chordrest+"' root '"+root+"'");
			// alternate base note
			pattern=/[\/][ABCDEFGabcdefg]((##)|#|x|(bb)|b)?$/;
			match=pattern.exec(chordrest);
			if (match) {
				chordrest=chordrest.substring(0,match.index);
				if (match[0].substring(2)=="x") base=match[0].substring(1,1)+"##";
				else base=match[0].substring(1);
				if (debug) console.log("   chordrest : '"+chordrest+"' base '"+base+"'");
			}
			// qualifier
			pattern=/^((Maj7Lyd)|Δ|(Maj)|(Ma)|M|(maj)|m|(min)|[-]|[+]|(aug5?)|(5#$)|o|°|(dim5?)|(5b$)|ø|Ø|(sus2)|(sus)|(sus4)|(sus#4)|(5$)|(2$)|(Lyd)|(Phryg)|(Tristan$))/;
			match=pattern.exec(chordrest);
			if (match) {
				chordrest=chordrest.substring(match.index+match[0].length);
				qualifierMatch=match[0];
				switch (match[0]) {
					case 'Δ' : case 'Maj' : case 'Ma' : case 'maj' : qualifier= "major"; n3="E"; n5="G"; break; // C–E-G
					case 'm' : case 'min' : case '-' : qualifier= "minor"; n3="Eb"; n5="G"; break; // C–Eb-G
					case '+' : case 'aug' : case 'aug5' : case '5#' : qualifier= "augmented"; n3="E"; n5="G#"; break; // C–E–G#
					case 'o' : case '°' : case 'dim' : case 'dim5' : qualifier= "diminished"; n3="Eb"; n5="Gb"; break; // C–Eb–Gb
					case '5b' : qualifier= "b5"; n3="E"; n5="Gb"; break; // C–E–Gb
					case 'sus2' : qualifier= "suspended 2"; n3="D"; n5="G"; break; // C–D–G
					case 'sus4' : case 'sus' : qualifier= "suspended 4"; n3="F"; n5="G"; break; // C–F–G
					case 'sus#4' : qualifier= "suspended #4"; n3="F#"; n5="G"; break; // C–F#-G
					case '5' : qualifier= "power"; n5="G"; break; // C-G
					case '2' : qualifier= "major"; n2="D"; n3="E"; n5="G"; break; // C–D-E-G
					case 'Maj7Lyd' : qualifier= "Major 7 Lydian"; n3="E"; n5="G"; n7="B"; n9="D"; n11="F#"; n13="A"; break; // C–E-G-B-D-F#-A
					// https://en.wikipedia.org/wiki/Lydian_chord
					case 'Lyd' : qualifier= "Lydian"; n3="E"; n5="G"; n7="B"; n11="F#"; break; // C–E-G-B-F# major 7♯11
					// https://en.wikipedia.org/wiki/So_What_chord m7♭911♭13 [no 5] 
					case 'Phryg' : qualifier= "Phrygian"; n3="Eb"; n7="Bb"; n9="Db"; n11="F"; n13="Ab"; break; // C–Eb-Bb-Db-Ab
					// https://en.wikipedia.org/wiki/Tristan_chord
					case 'Tristan' : qualifier= "Tristan"; n3="F#"; n5="A#"; n9="D"; break; // C–F#-A#-C#
					 
				}
				if (debug) console.log("   chordrest : '"+chordrest+"' match '"+match[0]+"'");
			} else { qualifier= "major"; n3="E"; n5="G"; } // C–E-G
			if (debug) console.log("   chordrest : '"+chordrest+"' qualifierMatch '"+qualifierMatch+"' qualifier '"+qualifier+"'");
			pattern=/^((sus)|[+]|([b#]5)|6|(7alt)|7|(Δ7)|(Ma7)|(Maj7)|([#]?(11))|([b#]?(9|(13))))/;
			match=pattern.exec(chordrest);
			if (match) {
				chordrest=chordrest.substring(match.index+match[0].length);
				if (debug) console.log("   chordrest : '"+chordrest+"' first alt match '"+match[0]+"'");
				switch (match[0]) {
					case 'sus' : n3="F"; break;
					case '+' : n5="G#"; break;
					case 'b5' : n5="Gb"; break;
					case '#5' : case '+' : n5="G#"; break;
					case '6' : n6="A"; break;
					case '7' : if (qualifier=="major"&&qualifierMatch!="") n7="B"; else n7="Bb"; break;
					case '7alt' : n5=""; n7="Bb"; n9="Db"; n11="F#"; n13="Ab"; break; // https://en.wikipedia.org/wiki/Altered_chord
					case 'Δ7' : case 'Ma7' : case 'Maj7' : if (qualifier=="minor"&&qualifierMatch!="") n7="B"; break;
					case 'b9' : n7="Bb"; n9="Db"; break;
					case '9' : if (qualifier=="major"&&qualifierMatch!="") { n7="B"; n9="D"; } else { n7="Bb"; n9="D"; } break;
					case '#9' : n7="Bb"; n9="D#"; break;
					case '11' : if (qualifier=="major"&&qualifierMatch!="") { n7="B"; n9="D"; n11="F"; } else { n7="Bb"; n9="D"; n11="F"; } break;
					case '#11' : n7="Bb"; n9="D"; n11="F#"; break;
					case 'b13' : n7="Bb"; n9="D"; n11="F"; n13="Ab"; break;
					case '13' : n7="Bb"; n9="D"; n11="F"; n13="A"; break;
					case '#13' : n7="Bb"; n9="D"; n11="F"; n13="A#"; break;
				}
			}
			while (chordrest!="") {
				pattern=/^((add ?)|(sus)|[+]|([b#]5)|7|([b#]?(9|(13)))|(#?(11))|([(]no 3[)]))/;
				match=pattern.exec(chordrest);
				if (match) {
					chordrest=chordrest.substring(match.index+match[0].length);
					console.log("   chordrest : '"+chordrest+"' while match '"+match[0]+"'");
					switch (match[0]) {
						case '(no 3)' : n3=""; break;
						case 'sus' : n3="F"; break;
						case 'b5' : n5="Gb"; break;
						case '#5' : case '+' : n5="G#"; break;
						case '7' : n7="Bb"; break;
						case 'b9' : n9="Db"; break;
						case '9' : n9="D"; break;
						case '#9' : n9="D#"; break;
						case '11' : n11="F"; break;
						case '#11' : n11="F#"; break;
						case 'b13' : n13="Ab"; break;
						case '13' : n13="A"; break;
						case '#13' : n13="A#"; break;
					}
				} else break;
			}
		}
		if (debug) console.log("Chord : '"+chord+" root '"+root+"' qualifierMatch '"+qualifierMatch+"' qualifier '"+qualifier+"' alteration '"+alteration+"' base '"+base+"'");
		if (debug) console.log("  '"+n1+"' '"+n2+"' '"+n3+"' '"+n5+"' '"+n6+"' '"+n7+"' '"+n9+"' '"+n11+"' '"+n13+"'");
		var n=-1,tpcArray=new Array(), rootTpc, baseTpc;
		if (n1!="") tpcArray[++n]=tpcAndNoteName(n1,1);
		if (n2!="") tpcArray[++n]=tpcAndNoteName(n2,1);
		if (n3!="") tpcArray[++n]=tpcAndNoteName(n3,1);
		if (n5!="") tpcArray[++n]=tpcAndNoteName(n5,1);
		if (n6!="") tpcArray[++n]=tpcAndNoteName(n6,1);
		if (n7!="") tpcArray[++n]=tpcAndNoteName(n7,1);
		if (n9!="") tpcArray[++n]=tpcAndNoteName(n9,1);
		if (n11!="") tpcArray[++n]=tpcAndNoteName(n11,1);
		if (n13!="") tpcArray[++n]=tpcAndNoteName(n13,1);
		rootTpc=tpcAndNoteName(root,1);
		tpcArray=transposeTpcArray(tpcArray,rootTpc,false);
		if (base!="") {
			baseTpc=tpcAndNoteName(base,1);
			tpcArray=[baseTpc].concat(tpcArray);
		}
		return tpcArray;
	}

	function setCursorToTime(cursor, time, atChordRest){
		cursor.rewind(0);
		if (time==0&&atChordRest==false) return true;
		while (cursor.segment) { 
			var current_time = cursor.tick;
			if(current_time>=time&&(atChordRest==false||cursor.segment.segmentType==0x0080)){
				return true;
			}
			cursor.next();
		}
		return false;
	}
	
	function addChord(cursor, harmonyArray, debug) {
		if (harmonyArray[0]==-2) return;
		if (debug) console.log("harmonyArray[0]>"+harmonyArray[0]+"<");
		var cursor, rootTpc, baseTpc, harmonyId, harmonyName, harmonyText, harmonyDuration, harmonyTick;
		rootTpc=harmonyArray[0];
		baseTpc=harmonyArray[1];
		harmonyId=harmonyArray[2];
		harmonyName=harmonyArray[3];
		harmonyText=harmonyArray[4];
		harmonyDuration=harmonyArray[5];
		harmonyTick=harmonyArray[6];
		
		var tpcArray;
		if (harmonyId>=0) {
			var chord=tpcAndNoteName(rootTpc,0)+chordIdAndName(harmonyId,0);
			if (baseTpc>-2) chord+="/"+tpcAndNoteName(baseTpc,0);
			tpcArray=parseChord(chord,debug);
		} else if (harmonyName) {
			tpcArray=parseChord(harmonyName,debug);
		} else if (harmonyText) {
			tpcArray=parseChord(harmonyText,debug);
		} else {
			tpcArray=new Array();
			if (baseTpc>-2) tpcArray=[baseTpc].concat(tpcArray);
			if (rootTpc>-2) tpcArray=[rootTpc].concat(tpcArray);
		}
		var info=" ( ";
		for (var i=0;i<tpcArray.length;++i) info+=tpcAndNoteName(tpcArray[i],0)+" ";
		info+=")";
		if (rootTpc==-2) return;
		if (tpcArray.length==0) { if (rootTpc>-2) tpcArray=[rootTpc]; }
		if (debug) console.log("Add notes from chord duration : "+harmonyDuration[0]+"/"+harmonyDuration[1]+" id : "+harmonyId+" name : "+harmonyName+"  at : "+harmonyTick+" current position "+cursor.tick+" tpcArray : >"+tpcArray+"< info :"+info);
		var referenceC = 108-comboBoxOctaves.currentIndex*12; // C3 : 48 for C in octave -1, inc-/de-crease by 12 for each octave up/down.
		var pitch, lastpitch=referenceC;
		if (!setCursorToTime(cursor, harmonyTick, false)) return;
		if (cursor.tick!=harmonyTick) { if (debug) console.log("  Error in position, at "+cursor.tick+" instead of "+harmonyTick);}
		var cur_time=cursor.tick;
		cursor.setDuration(harmonyDuration[0],harmonyDuration[1]);
		pitch = ((((tpcArray[0]-2+12)%12)*7)%12)+referenceC;
		while(pitch<lastpitch) pitch+=12;
		lastpitch=pitch;
		if (debug) console.log("Add first note, pitch "+pitch);
		cursor.addNote(pitch); //add 1st note
		var next_time=cursor.tick;
		if (!setCursorToTime(cursor, harmonyTick, true)) return;
		var chord = cursor.element; //get the chord created when 1st note was inserted
		for(var i=1; i<tpcArray.length; i++) {
			pitch = ((((tpcArray[i]-2+12)%12)*7)%12)+referenceC;
			while(pitch<lastpitch) pitch+=12;
			lastpitch=pitch;
			if (debug) console.log("Add note "+i+", pitch "+pitch);
			chord.add(createNote(pitch, tpcArray[i], tpcArray[i], NoteHead.HEAD_AUTO)); //add notes to the chord
		}
		return;
	}

	function gcf(a,b) {
		var c;
		a = Math.abs(a);
		b = Math.abs(b);
		while (b) {
			c = a % b;
			a = b;
			b = c;
		}
	return a;
	}

	function calculateFraction(numerator, denominator) {
		var g=gcf(numerator, denominator);
		numerator/=g;
		denominator/=g;
		if (denominator<0) {
			numerator*=-1;
			denominator*=-1;
		}
		return [numerator,denominator];
	}
	
	function isVoiceEmpty(staff,voice,track, debug) {
		var cursor = curScore.newCursor();
		curScore.lastSegment.tick
		cursor.staffIdx = staff;
		cursor.voice = voice;
		cursor.track = track;
		cursor.rewind(0);
		while (cursor.segment) {
			if (debug) console.log("Segment "+segmentTypeToString(cursor.segment.segmentType));
			if (cursor.segment.segmentType==0x0080) { // ChordRest
				if (elementTypeToString(cursor.segment.elementAt(track).type)!='Rest') return false;
			}
			cursor.next();
		}
		return true;
	}

	function apply() {
		var debug=true;				
		if (debug) console.log("staffOut >"+staffOut.text+"< comboBoxVoiceOut.currentIndex >"+(comboBoxVoiceOut.currentIndex+1)+"<");
		if (debug) console.log("overwriteVoice "+overwriteVoice.checked);

		if (staffOut.text=="") return ["Staff has no value", false];
		//if (voiceOut.text=="") return ["Voice has no value", false];

		var staff, voice, track;
		staff=staffOut.text-1;
		voice=comboBoxVoiceOut.currentIndex;
		track=4*staff+voice;
		if (!overwriteVoice.checked) {
			if (!isVoiceEmpty(staff,voice,track,debug)) return ["Staff "+staffOut.text+", voice "+(comboBoxVoiceOut.currentIndex+1)+" is not empty, choose to overwrite the voice or choose another voice.", false];
		}
		
		curScore.startCmd();

		var segment=curScore.firstSegment();
		var seenHarmony=false;
		var rootTpc=-2, baseTpc=-2, harmonyId=-2, harmonyName, harmonyText, harmonyDuration, harmonyTick;
		var chords = new Array();
		var lastTick, previousTick=0 ;
		if (debug) console.log("AddNotesFromChords");
		if (debug) console.log("Cn "+comboBoxOctaves.currentIndex);

		while (segment) {
			var count = 0;
			var annotation = segment.annotations[count];
			var element = segment.elementAt(0);
				if (element) {
					var type	 = element.type;
					var duration = element.duration;
					var durationString = "";
					if (duration) {
						durationString = ' duration : ' + duration.numerator + '/' + duration.denominator + ', ticks : ' + duration.ticks;
					}
					// if (debug) console.log(' Element : '+elementTypeToString(type) + ' (' + type + ') at : ' + segment.tick+durationString);
					lastTick = segment.tick;
				}
			while (annotation) {
				// if (debug) console.log(" Annotation : " +  annotation._name()+ " "+ annotation.type)
				if (annotation.type === Element.HARMONY) {
					if (seenHarmony) {
						harmonyDuration = calculateFraction((segment.tick-harmonyTick),division*4);
						chords=chords.concat([[rootTpc, baseTpc, harmonyId, harmonyName, harmonyText, harmonyDuration, harmonyTick]]);
					}
					seenHarmony = true;
					rootTpc=annotation.rootTpc;
					baseTpc=annotation.baseTpc;
					harmonyId=annotation.id;
					harmonyName=annotation.harmonyName;
					harmonyText=annotation.text;
					harmonyTick=segment.tick;
					harmonyDuration=null;
					if (debug) console.log("  Harmony id : ",annotation.id," name : ",annotation.harmonyName," text : ",annotation.harmonyText," at ",segment.tick);
				}
				 annotation = segment.annotations[++count]
			}
			segment = segment.next ;
		}
		if (seenHarmony) {
			harmonyDuration = calculateFraction((lastTick-harmonyTick),division*4);
			chords=chords.concat([[rootTpc, baseTpc, harmonyId, harmonyName, harmonyText, harmonyDuration, harmonyTick]]);
		}
		if (chords.length==0) return ["Found no chords in "+curScore.name, true];
		
		if (debug) console.log("AddNotesFromChords calculate durations of measures");
		// calculate durations of measures
		var cursor = curScore.newCursor();
		cursor.rewind(0);
		cursor.voice = 0;
		cursor.staffIdx = 0;
		var durations=new Array(), d=-1;
		do {
			durations[++d]=calculateFraction((cursor.measure.lastSegment.tick-cursor.measure.firstSegment.tick),division*4);
		} while (cursor.nextMeasure());
		
		if (debug) console.log("AddNotesFromChords add (dummy) notes");
		// add (dummy) notes 
		cursor.rewind(0);
		cursor.voice = voice;
		cursor.staffIdx = staff;
		for (i=0;i<durations.length;++i) {
			cursor.setDuration(durations[i][0],durations[i][1]);
			cursor.addNote(84);
		}

		if (debug) console.log("AddNotesFromChords replace (dummy) notes by rests");
		// replace notes by rests
		cursor.rewind(0);
		do {
			var rest = newElement(Element.REST);
			rest.duration=cursor.element.duration;
			rest.durationType=cursor.element.durationType;
			cursor.add(rest);
		} while (cursor.next())
		
		// add notes from chords		
		if (debug) console.log("AddNotesFromChords adding notes from chords");
		cursor.rewind(0);
		for (var i=0;i<chords.length;++i) {
			if (debug) console.log("chord["+i+"]:"+chords[i]);
			addChord(cursor,chords[i], debug);
		}
		curScore.doLayout();
		curScore.endCmd();
		return ;
	}	

	onRun: {
		if (typeof curScore === 'undefined') Qt.quit();
	}
	
}
