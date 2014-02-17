unit HeaderTypenUnit;

interface

TYPE
  TSequenzHeader = CLASS
    Adresse : Int64;
    BildBreite : Word;
    BildHoehe : Word;
    Seitenverhaeltnis : Byte;
    Framerate : Byte;
    Bitrate : LongWord;
    VBVPuffer : Word;
    ProfilLevel : Byte;
    Progressive : Boolean;
    ChromaFormat : Byte;
    LowDelay : Boolean;
  END;

  TBildgruppenHeader = CLASS
    Adresse : Int64;
    Timecode : TTimecode;
    GeschlosseneGr : Boolean;
    Geschnitten : Boolean;
  END;

  TBildHeader = CLASS
    Adresse : Int64;
    TempRefer : Word;
    BildTyp : Byte;
    VBVDelay : Word;
    FCode0 : Byte;
    FCode1 : Byte;
    FCode2 : Byte;
    FCode3 : Byte;
    IntraDCPre : Byte;
    BildStruktur : Byte;
    OberstesFeldzuerst : Boolean;
    frame_pred_frame_dct : Boolean;
    concealment_motion_vectors : Boolean;
    q_scale_type : Boolean;
    intra_vlc_format : Boolean;
    alternate_scan : Boolean;
    repeat_first_field : Boolean;
    chroma_420_type : Boolean;
    progressive_frame : Boolean;
    composite_display_flag : Boolean;
    v_axis : Boolean;
    field_sequence : Byte;
    sub_carrier : Boolean;
    burst_amplitude : Byte;
    sub_carrier_phase : Byte;
  END;

implementation

end.
 