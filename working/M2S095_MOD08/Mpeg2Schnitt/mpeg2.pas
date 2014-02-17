{
 mpeg2.pas
 This file is part of mpeg2pas, a Kylix/Delphi translation of the mpeg2.h
 and related header files required to link against libmpeg2.so/libmpeg2-0.dll.

     Copyright (C) 2004 Igor Feldhaus <igor.feldhaus@gmx.net>
     Project homepage: 

 mpeg2pas is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 mpeg2pas is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with mpeg2pas; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.

 The original mpeg2.h is part of mpeg2dec, a free MPEG-2 video stream decoder.

     Copyright (C) 2000-2003 Michel Lespinasse <walken@zoy.org>
     Copyright (C) 1999-2000 Aaron Holtzman <aholtzma@ess.engr.uvic.ca>
     Project homepage: http://libmpeg2.sourceforge.net/

 And it is licensed under the GNU General Public License as well.
}

unit mpeg2;
{ $WEAKPACKAGEUNIT ON }
{ $ALIGN 4 }
{ $IFDEF FPC }
{ $PACKRECORDS 4 }
{ $ENDIF FPC}
  {$IFDEF MSWINDOWS}
    {$UNDEF LINUX}
  {$ENDIF}

interface
uses
  {$IFDEF MSWINDOWS}
   Windows,
  {$ENDIF}
   Types,SysUtils;
  const
  {$IFDEF MSWINDOWS}
    MPEG2ModuleName ='libmpeg2-0.dll';
  {$ENDIF}
  {$IFDEF LINUX}
    MPEG2ModuleName ='libmpeg2.so'; {Setup as you need}
  {$ENDIF}

  { Pointers to basic pascal types, inserted by h2pas conversion program.}
  Type
    PLongint  = ^Longint;
    PSmallInt = ^SmallInt;
    PByte     = ^Byte;
    PWord     = ^Word;
    PDWord    = ^DWord;
    PDouble   = ^Double;

    Tuint32_t = LongWord;
    Tuint8_t  = Byte;
    Tuint16_t  = Word;
    Puint8_t = ^Tuint8_t;
    Puint16_t = ^Tuint16_t;
    Tint8_t   = ShortInt;
    Tint16_t  = SmallInt;
    PPuint8_t = ^Puint8_t;

  const
     SEQ_FLAG_MPEG2 = 1;
     SEQ_FLAG_CONSTRAINED_PARAMETERS = 2;
     SEQ_FLAG_PROGRESSIVE_SEQUENCE = 4;
     SEQ_FLAG_LOW_DELAY = 8;
     SEQ_FLAG_COLOUR_DESCRIPTION = 16;
     SEQ_MASK_VIDEO_FORMAT = $e0;
     SEQ_VIDEO_FORMAT_COMPONENT = 0;
     SEQ_VIDEO_FORMAT_PAL = $20;
     SEQ_VIDEO_FORMAT_NTSC = $40;
     SEQ_VIDEO_FORMAT_SECAM = $60;
     SEQ_VIDEO_FORMAT_MAC = $80;
     SEQ_VIDEO_FORMAT_UNSPECIFIED = $a0;

  type

     Pmpeg2_sequence_s = ^Tmpeg2_sequence_s;
     Tmpeg2_sequence_s = record
          width : dword;
          height : dword;
          chroma_width : dword;
          chroma_height : dword;
          byte_rate : dword;
          vbv_buffer_size : dword;
          flags : Tuint32_t;
          picture_width : dword;
          picture_height : dword;
          display_width : dword;
          display_height : dword;
          pixel_width : dword;
          pixel_height : dword;
          frame_period : dword;
          profile_level_id : Tuint8_t;
          colour_primaries : Tuint8_t;
          transfer_characteristics : Tuint8_t;
          matrix_coefficients : Tuint8_t;
       end;
     Tmpeg2_sequence_t = Tmpeg2_sequence_s;
     Pmpeg2_sequence_t = ^Tmpeg2_sequence_t;

  const
     GOP_FLAG_DROP_FRAME = 1;
     GOP_FLAG_BROKEN_LINK = 2;
     GOP_FLAG_CLOSED_GOP = 4;

  type

     Pmpeg2_gop_s = ^Tmpeg2_gop_s;
     Tmpeg2_gop_s = record
          hours : Tuint8_t;
          minutes : Tuint8_t;
          seconds : Tuint8_t;
          pictures : Tuint8_t;
          flags : Tuint32_t;
       end;
     Tmpeg2_gop_t = Tmpeg2_gop_s;
     Pmpeg2_gop_t = ^Tmpeg2_gop_t;

  const
     PIC_MASK_CODING_TYPE = 7;
     PIC_FLAG_CODING_TYPE_I = 1;
     PIC_FLAG_CODING_TYPE_P = 2;
     PIC_FLAG_CODING_TYPE_B = 3;
     PIC_FLAG_CODING_TYPE_D = 4;
     PIC_FLAG_TOP_FIELD_FIRST = 8;
     PIC_FLAG_PROGRESSIVE_FRAME = 16;
     PIC_FLAG_COMPOSITE_DISPLAY = 32;
     PIC_FLAG_SKIP = 64;
     PIC_FLAG_TAGS = 128;
     PIC_MASK_COMPOSITE_DISPLAY = $fffff000;

  type

     Pmpeg2_picture_s = ^Tmpeg2_picture_s;
     Tmpeg2_picture_s = record
          temporal_reference : dword;
          nb_fields : dword;
          tag : Tuint32_t;
          tag2 : Tuint32_t;
          flags : Tuint32_t;
          display_offset : array[0..2] of record
               x : longint;
               y : longint;
            end;
       end;
     Tmpeg2_picture_t = Tmpeg2_picture_s;
     Pmpeg2_picture_t = ^Tmpeg2_picture_t;

     Pmpeg2_fbuf_s = ^Tmpeg2_fbuf_s;
     Tmpeg2_fbuf_s = record
          buf : array[0..2] of Puint8_t;
          id : pointer;
       end;
     Tmpeg2_fbuf_t = Tmpeg2_fbuf_s;
     Pmpeg2_fbuf_t = ^Tmpeg2_fbuf_t;

  type
     Pmpeg2_mc_fct = ^Tmpeg2_mc_fct;
//     Tmpeg2_mc_fct = void;
     Tmpeg2_mc_fct = Pointer;
     Pmotion_parser_t = ^Tmotion_parser_t;
     Tmotion_parser_t = Pointer;

     Pmotion_t = ^Tmotion_t;
     Tmotion_t = record
          ref : array[0..1] of array[0..2] of Puint8_t;
          ref2 : array[0..1] of ^Puint8_t;
          pmv : array[0..1] of array[0..1] of longint;
          f_code : array[0..1] of longint;
       end;

 type
     Pmpeg2_mc_t = ^Tmpeg2_mc_t;
     Tmpeg2_mc_t = record
          put : array[0..7] of Pmpeg2_mc_fct;
          avg : array[0..7] of Pmpeg2_mc_fct;
       end;

     Pmpeg2_decoder_s = ^Tmpeg2_decoder_s;
     Tmpeg2_decoder_s = record
          bitstream_buf : Tuint32_t;
          bitstream_bits : longint;
          bitstream_ptr : Puint8_t;
          dest : array[0..2] of Puint8_t;
          offset : longint;
          stride : longint;
          uv_stride : longint;
          slice_stride : longint;
          slice_uv_stride : longint;
          stride_frame : longint;
          limit_x : dword;
          limit_y_16 : dword;
          limit_y_8 : dword;
          limit_y : dword;
          b_motion : Tmotion_t;
          f_motion : Tmotion_t;
          motion_parser : array[0..4] of Pmotion_parser_t;
          dc_dct_pred : array[0..2] of Tint16_t;
          DCTblock : array[0..63] of Tint16_t{64};
          picture_dest : array[0..2] of Puint8_t;
          convert : procedure (convert_id:pointer; src:PPuint8_t; v_offset:dword);cdecl;
          convert_id : pointer;
          dmv_offset : longint;
          v_offset : dword;
          quantizer_matrix : array[0..3] of Puint16_t;
//          chroma_quantizer : array[0..1] of ^array[0..63] of Tuint16_t; /orig
         chroma_quantizer : array[0..1] of array[0..63] of Tuint16_t;
// ???
          quantizer_prescale : array[0..3] of array[0..31] of array[0..63] of Tuint16_t;
          width : longint;
          height : longint;
          vertical_position_extension : longint;
          chroma_format : longint;
          coding_type : longint;
          intra_dc_precision : longint;
          picture_structure : longint;
          frame_pred_frame_dct : longint;
          concealment_motion_vectors : longint;
          intra_vlc_format : longint;
          top_field_first : longint;
          scan : Puint8_t;
          second_field : longint;
          mpeg1 : longint;
       end;
     Tmpeg2_decoder_t = Tmpeg2_decoder_s;
     Pmpeg2_decoder_t = ^Tmpeg2_decoder_t;


     Pmpeg2_info_s = ^Tmpeg2_info_s;
     Tmpeg2_info_s = record
          sequence : Pmpeg2_sequence_t;
          gop : Pmpeg2_gop_t;
          current_picture : Pmpeg2_picture_t;
          current_picture_2nd : Pmpeg2_picture_t;
          current_fbuf : Pmpeg2_fbuf_t;
          display_picture : Pmpeg2_picture_t;
          display_picture_2nd : Pmpeg2_picture_t;
          display_fbuf : Pmpeg2_fbuf_t;
          discard_fbuf : Pmpeg2_fbuf_t;
          user_data : Puint8_t;
          user_data_len : dword;
       end;
     Tmpeg2_info_t = Tmpeg2_info_s;
     Pmpeg2_info_t = ^Tmpeg2_info_t;

     Pmpeg2_state_t = ^Tmpeg2_state_t;
     Tmpeg2_state_t =  Longint;

  type

     Pmpeg2_convert_init_s = ^Tmpeg2_convert_init_s;
     Tmpeg2_convert_init_s = record
          id_size : dword;
          buf_size : array[0..2] of dword;
          start : procedure (id:pointer; fbuf:Pmpeg2_fbuf_t; picture:Pmpeg2_picture_t; gop:Pmpeg2_gop_t);cdecl;
          copy : procedure (id:pointer; src:PPuint8_t; v_offset:dword);
       end;
     Tmpeg2_convert_init_t = Tmpeg2_convert_init_s;
     Pmpeg2_convert_init_t = ^Tmpeg2_convert_init_t;

     Pmpeg2_convert_stage_t = ^Tmpeg2_convert_stage_t;
     Tmpeg2_convert_stage_t =  Longint;
     Const
       MPEG2_CONVERT_SET = 0;
       MPEG2_CONVERT_STRIDE = 1;
       MPEG2_CONVERT_START = 2;

type  Tfbuf_alloc_t = record
   fbuf : Tmpeg2_fbuf_t;
    end;

  type

// wrong ....
     Pmpeg2_convert_t = ^Tmpeg2_convert_t;
     Tmpeg2_convert_t = longint;

     Pmpeg2dec_s = ^Tmpeg2dec_s;
     Tmpeg2dec_s = record
          decoder : Tmpeg2_decoder_t;
          info : Tmpeg2_info_t;
          shift : Tuint32_t;
          is_display_initialized : longint;
          action : function (mpeg2dec:Pmpeg2dec_s):Tmpeg2_state_t;cdecl;
          state : Tmpeg2_state_t;
          ext_state : Tuint32_t;
          chunk_buffer : Puint8_t;
          chunk_start : Puint8_t;
          chunk_ptr : Puint8_t;
          code : Tuint8_t;
          tag_current : Tuint32_t;
          tag2_current : Tuint32_t;
          tag_previous : Tuint32_t;
          tag2_previous : Tuint32_t;
          num_tags : longint;
          bytes_since_tag : longint;
          first : longint;
          alloc_index_user : longint;
          alloc_index : longint;
          first_decode_slice : Tuint8_t;
          nb_decode_slices : Tuint8_t;
          user_data_len : dword;
          new_sequence : Tmpeg2_sequence_t;
          sequence : Tmpeg2_sequence_t;
          new_gop : Tmpeg2_gop_t;
          gop : Tmpeg2_gop_t;
          new_picture : Tmpeg2_picture_t;
          pictures : array[0..3] of Tmpeg2_picture_t;
          picture : Pmpeg2_picture_t;
          fbuf : array[0..2] of Pmpeg2_fbuf_t;
          fbuf_alloc : array[0..2] of Tfbuf_alloc_t; //von mir
          custom_fbuf : longint;
          yuv_buf : array[0..2] of array[0..2] of Puint8_t;
          yuv_index : longint;
          convert : Pmpeg2_convert_t;
          convert_arg : pointer;
          convert_id_size : dword;
          convert_stride : longint;
          convert_start : procedure (id:pointer; fbuf:Pmpeg2_fbuf_t; picture:Pmpeg2_picture_t; gop:Pmpeg2_gop_t);
          buf_start : Puint8_t;
          buf_end : Puint8_t;
          display_offset_x : Tint16_t;
          display_offset_y : Tint16_t;
          copy_matrix : longint;
          q_scale_type : Tint8_t;
          scaled : array[0..3] of Tint8_t;
          quantizer_matrix : array[0..3] of array[0..63] of Tuint8_t;
          new_quantizer_matrix : array[0..3] of array[0..63] of Tuint8_t;
       end;
     Tmpeg2dec_t = Tmpeg2dec_s;
     Pmpeg2dec_t = ^Tmpeg2dec_t;

     Const
       STATE_BUFFER = 0;
       STATE_SEQUENCE = 1;
       STATE_SEQUENCE_REPEATED = 2;
       STATE_GOP = 3;
       STATE_PICTURE = 4;
       STATE_SLICE_1ST = 5;
       STATE_PICTURE_2ND = 6;
       STATE_SLICE = 7;
       STATE_END = 8;
       STATE_INVALID = 9;
       STATE_INVALID_END = 10;

  type

     Pmpeg2_alloc_t = ^Tmpeg2_alloc_t;
     Tmpeg2_alloc_t =  Longint;
     Const
       MPEG2_ALLOC_MPEG2DEC = 0;
       MPEG2_ALLOC_CHUNK = 1;
       MPEG2_ALLOC_YUV = 2;
       MPEG2_ALLOC_CONVERT_ID = 3;
       MPEG2_ALLOC_CONVERTED = 4;


  const
     MPEG2_ACCEL_X86_MMX = 1;
     MPEG2_ACCEL_X86_3DNOW = 2;
     MPEG2_ACCEL_X86_MMXEXT = 4;
     MPEG2_ACCEL_PPC_ALTIVEC = 1;
     MPEG2_ACCEL_ALPHA = 1;
     MPEG2_ACCEL_ALPHA_MVI = 2;
     MPEG2_ACCEL_SPARC_VIS = 1;
     MPEG2_ACCEL_SPARC_VIS2 = 2;
     MPEG2_ACCEL_DETECT = $80000000;
  type
  TFNmpeg2_convert = function(mpeg2dec:Pmpeg2dec_t; convert:Tmpeg2_convert_t; arg:pointer):longint;cdecl;
  TFNmpeg2_stride = function(mpeg2dec:Pmpeg2dec_t; stride:longint):longint;cdecl;
  TFNmpeg2_set_buf = procedure(mpeg2dec:Pmpeg2dec_t; buf:pbytearray; id:pointer);cdecl;
  TFNmpeg2_custom_fbuf = procedure(mpeg2dec:Pmpeg2dec_t; custom_fbuf:longint);cdecl;
  TFNmpeg2_accel = function (accel:Tuint32_t):Tuint32_t;cdecl;
  TFNmpeg2_init = function :Pmpeg2dec_t;cdecl;
  TFNmpeg2_info = function(mpeg2dec:Pmpeg2dec_t):Pmpeg2_info_t;cdecl;
  TFNmpeg2_close = procedure(mpeg2dec:Pmpeg2dec_t);cdecl;
  TFNmpeg2_buffer = procedure(mpeg2dec:Pmpeg2dec_t; start:Puint8_t; ende:Puint8_t);cdecl;
  TFNmpeg2_getpos = function(mpeg2dec:Pmpeg2dec_t):longint;cdecl;
  TFNmpeg2_parse = function(mpeg2dec:Pmpeg2dec_t):Tmpeg2_state_t;cdecl;
  TFNmpeg2_reset = procedure(mpeg2dec:Pmpeg2dec_t; full_reset:longint);cdecl;
  TFNmpeg2_skip = procedure(mpeg2dec:Pmpeg2dec_t; skip:longint);cdecl;
  TFNmpeg2_slice_region = procedure(mpeg2dec:Pmpeg2dec_t; start:longint; ende:longint);cdecl;
  TFNmpeg2_tag_picture = procedure(mpeg2dec:Pmpeg2dec_t; tag:Tuint32_t; tag2:Tuint32_t);cdecl;
  TFNmpeg2_init_fbuf = procedure(decoder:Pmpeg2_decoder_t; current_fbuf:pbytearray; forward_fbuf:pbytearray; backward_fbuf:pbytearray);cdecl;
  TFNmpeg2_slice = procedure(decoder:Pmpeg2_decoder_t; code:longint; buffer:Puint8_t);cdecl;
  TFNmpeg2_malloc = function(size:dword; reason:Tmpeg2_alloc_t):pointer;cdecl;
  TFNmpeg2_free = procedure(buf:pointer);cdecl;
  var
  mpeg2_convert: TFNmpeg2_convert = nil;
  mpeg2_stride: TFNmpeg2_stride = nil;
  mpeg2_set_buf: TFNmpeg2_set_buf = nil;
  mpeg2_custom_fbuf: TFNmpeg2_custom_fbuf = nil;
  mpeg2_accel: TFNmpeg2_accel = nil;
  mpeg2_init: TFNmpeg2_init = nil;
  mpeg2_info: TFNmpeg2_info = nil;
  mpeg2_close: TFNmpeg2_close = nil;
  mpeg2_buffer: TFNmpeg2_buffer = nil;
  mpeg2_getpos: TFNmpeg2_getpos  = nil;
  mpeg2_parse: TFNmpeg2_parse = nil;
  mpeg2_reset: TFNmpeg2_reset = nil;
  mpeg2_skip: TFNmpeg2_skip = nil;
  mpeg2_slice_region: TFNmpeg2_slice_region = nil;
  mpeg2_tag_picture: TFNmpeg2_tag_picture = nil;
  mpeg2_init_fbuf: TFNmpeg2_init_fbuf = nil;
  mpeg2_slice: TFNmpeg2_slice = nil;
  mpeg2_malloc: TFNmpeg2_malloc = nil;
  mpeg2_free: TFNmpeg2_free = nil;
  DLLHandle : THandle;
  Mpeg2Decoder_OK : Boolean;

  type
  mpeg2convert_rgb32 = tmpeg2_convert_t;
  mpeg2convert_rgb24 = tmpeg2_convert_t;
  mpeg2convert_rgb16 = tmpeg2_convert_t;
  mpeg2convert_rgb15 = tmpeg2_convert_t;
  mpeg2convert_rgb8 = tmpeg2_convert_t;
  mpeg2convert_bgr32 = tmpeg2_convert_t;
  mpeg2convert_bgr24 = tmpeg2_convert_t;
  mpeg2convert_bgr16 = tmpeg2_convert_t;
  mpeg2convert_bgr15 = tmpeg2_convert_t;
  mpeg2convert_bgr8 = tmpeg2_convert_t;

implementation

INITIALIZATION
BEGIN
  IF DLLHandle = 0 THEN
  BEGIN
    Mpeg2Decoder_OK := False;
    DLLHandle := LoadLibrary(MPEG2ModuleName);
    IF DLLHandle <> 0 THEN
    BEGIN
    @mpeg2_init := GetProcAddress(DLLHandle, 'mpeg2_init');
      IF NOT Assigned(mpeg2_init) then exit;
    @mpeg2_convert := GetProcAddress(DLLHandle, 'mpeg2_convert');
      IF NOT Assigned(mpeg2_convert) then exit;
    @mpeg2_stride := GetProcAddress(DLLHandle, 'mpeg2_stride');
      IF NOT Assigned(mpeg2_stride) then exit;
    @mpeg2_set_buf := GetProcAddress(DLLHandle, 'mpeg2_set_buf');
      IF NOT Assigned(mpeg2_set_buf) then exit;
    @mpeg2_custom_fbuf := GetProcAddress(DLLHandle, 'mpeg2_custom_fbuf');
      IF NOT Assigned(mpeg2_custom_fbuf) then exit;
    @mpeg2_accel := GetProcAddress(DLLHandle, 'mpeg2_accel');
      IF NOT Assigned(mpeg2_accel) then exit;
    @mpeg2_info := GetProcAddress(DLLHandle, 'mpeg2_info');
      IF NOT Assigned(mpeg2_info) then exit;
    @mpeg2_close := GetProcAddress(DLLHandle, 'mpeg2_close');
      IF NOT Assigned(mpeg2_close) then exit;
    @mpeg2_buffer := GetProcAddress(DLLHandle, 'mpeg2_buffer');
      IF NOT Assigned(mpeg2_buffer) then exit;
    @mpeg2_getpos := GetProcAddress(DLLHandle, 'mpeg2_getpos');
      IF NOT Assigned(mpeg2_getpos) then exit;
    @mpeg2_parse := GetProcAddress(DLLHandle, 'mpeg2_parse');
      IF NOT Assigned(mpeg2_parse) then exit;
    @mpeg2_reset := GetProcAddress(DLLHandle, 'mpeg2_reset');
      IF NOT Assigned(mpeg2_reset) then exit;
    @mpeg2_skip := GetProcAddress(DLLHandle, 'mpeg2_skip');
      IF NOT Assigned(mpeg2_skip) then exit;
    @mpeg2_slice_region := GetProcAddress(DLLHandle, 'mpeg2_slice_region');
      IF NOT Assigned(mpeg2_slice_region) then exit;
    @mpeg2_tag_picture := GetProcAddress(DLLHandle, 'mpeg2_tag_picture');
      IF NOT Assigned(mpeg2_tag_picture) then exit;
    @mpeg2_init_fbuf := GetProcAddress(DLLHandle, 'mpeg2_init_fbuf');
      IF NOT Assigned(mpeg2_init_fbuf) then exit;
    @mpeg2_slice := GetProcAddress(DLLHandle, 'mpeg2_slice');
      IF NOT Assigned(mpeg2_slice) then exit;
    @mpeg2_malloc := GetProcAddress(DLLHandle, 'mpeg2_malloc');
      IF NOT Assigned(mpeg2_malloc) then exit;
    @mpeg2_free := GetProcAddress(DLLHandle, 'mpeg2_free');
      IF NOT Assigned(mpeg2_free) then exit;
    Mpeg2Decoder_OK := True
    end;
  end;
end;

FINALIZATION
BEGIN
  IF DLLHandle <> 0 THEN
  BEGIN
    FreeLibrary(DLLHandle);
    DLLHandle := 0;
  END;
END;
end.
