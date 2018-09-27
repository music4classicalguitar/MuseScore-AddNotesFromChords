# MuseScore-AddNotesFromChords

This plugin for [MuseScore 2.x] (http://musescore.org/) expands chords annotations into notes in an already existing staff and voice, which you can choose, that are directly playable by MuseScore.

Supports chords with note spelling : Standard/(Full) German/Solfeggio/French, lowercase minor chords, lower case bass notes
(Style - General - ChordSymbols, Fretboard Diagrams).

It is possible to transpose the generated notes, e.g.
- Trumpet melody (B♭) with chords in first staff, transpose all notes a major second higher for C-instruments in a second staff
- Alto saxophone melody (E♭) with chords, transpose all notes a minor third higher for C-instruments

By default it does not overwrite notes if already present, but you can choose to do so.

Note length is up to the next chord.

To end a chord or leave a measure empty add a chord without any meaning (for MuseScore), e.g. N.C. (No Chord).

For an unpatched version of MuseScore 2.x :

    Adapt chord style :
  
    Style - General - ChordSymbols, Fretboard Diagrams
    - Appearance : Custom
    - Load chords.xml : true
    Save your file and reopen it.
or

    Transpose to anything and transpose back
or

    Double click on the chords for which you want to add the notes
before using the plugin.


For a patched version of MuseScore.x :

    Just works as intended
  
For a patched version of MuseScore the following patch is needed in libmscore/harmony.h for MusScore 2.x:

    After line 70 :
  
      Q_PROPERTY(int rootTpc  READ rootTpc  WRITE setRootTpc)
      
    add a line with :
  
      Q_PROPERTY(QString harmonyName READ harmonyName)
      
    and compile MuseScore for your platform
  
See https://github.com/musescore/MuseScore/blob/2.3.2/libmscore/harmony.h

## How-To

- [Download] (https://github.com/music4classicalguitar/MuseScore-AddNotesFromChords/blob/master/AddNotesFromChords.qml) and [install the plugin] (https://musescore.org/en/handbook/plugins-0#installation) to your MuseScore 2.x install. Only the [qml file] (https://github.com/music4classicalguitar/MuseScore-AddNotesFromChords/blob/master/AddNotesFromChords.qml) is needed, but the examples (in [test/](https://github.com/music4classicalguitar/MuseScore-AddNotesFromChords/tree/master/test)) are useful to try it out quickly.

- enable the AddNotesFromChords plugin in 'Plugins > Plugin Manager' dialog
- reload the plugins with 'Plugins - Plugin Manager - Reload Plugins' or restart MuseScore.
- run the plugin via 'Plugin > Add notes from chords'

## Issues and limitations

- I would like to give the possibility to generate these new notes in a new staff instead of a voice in a current staff. Any suggestion how to do so is welcome.

## Support

Kindly report issues or requests in the [issue tracker](https://github.com/music4classicalguitar/MuseScore-AddNotesFromChords/issues).
