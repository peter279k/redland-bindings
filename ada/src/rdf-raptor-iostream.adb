with Ada.Unchecked_Conversion;
with RDF.Raptor.World; use RDF.Raptor.World;
with RDF.Raptor.URI; use RDF.Raptor.URI;
with RDF.Raptor.Term; use RDF.Raptor.Term;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with RDF.Auxiliary.Convert; use RDF.Auxiliary.Convert;

package body RDF.Raptor.IOStream is

   function raptor_new_iostream_from_sink (World: Raptor_World_Handle) return IOStream_Handle
     with Import, Convention=>C;

   function From_Sink (World: Raptor_World_Type_Without_Finalize'Class) return Stream_Type_Without_Finalize is
   begin
      return From_Non_Null_Handle( raptor_new_iostream_from_sink (Get_Handle (World)) );
   end;

   function raptor_new_iostream_from_filename (World: Raptor_World_Handle; filename: char_array) return IOStream_Handle
     with Import, Convention=>C;

   function From_Filename (World: Raptor_World_Type_Without_Finalize'Class; Filename: String) return Stream_Type_Without_Finalize is
   begin
      return From_Non_Null_Handle( raptor_new_iostream_from_filename (Get_Handle (World), To_C (Filename)) );
   end;

   function raptor_new_iostream_from_file_handle (World: Raptor_World_Handle; File: RDF.Auxiliary.C_File_Access) return IOStream_Handle
     with Import, Convention=>C;

   function From_File_Handle (World: Raptor_World_Type_Without_Finalize'Class; File: RDF.Auxiliary.C_File_Access)
                              return Stream_Type_Without_Finalize is
   begin
      return From_Non_Null_Handle( raptor_new_iostream_from_file_handle (Get_Handle (World), File) );
   end;

   function raptor_new_iostream_to_sink (World: Raptor_World_Handle) return IOStream_Handle
     with Import, Convention=>C;

   function To_Sink (World: Raptor_World_Type_Without_Finalize'Class) return Stream_Type_Without_Finalize is
   begin
      return From_Non_Null_Handle( raptor_new_iostream_to_sink (Get_Handle (World)) );
   end;

   function raptor_new_iostream_to_filename (World: Raptor_World_Handle; filename: char_array) return IOStream_Handle
     with Import, Convention=>C;

   function To_Filename (World: Raptor_World_Type_Without_Finalize'Class; Filename: String) return Stream_Type_Without_Finalize is
   begin
      return From_Non_Null_Handle( raptor_new_iostream_to_filename (Get_Handle (World), To_C (Filename)) );
   end;

--     function raptor_new_iostream_to_string (World: Raptor_World_Handle; str: char_array; length: size_t) return Handle_Type
--       with Import, Convention=>C;
--
--     function To_String (World: Raptor_World_Type_Without_Finalize'Class; Str: String)
--                           return Stream_Type_Without_Finalize is
--        Handle: constant Handle_Type := raptor_new_iostream_to_string (Get_Handle (World), To_C (Str), Str'Length);
--     begin
--        return From_Handle (Handle);
--     end;

   function raptor_new_iostream_to_file_handle (World: Raptor_World_Handle; File: RDF.Auxiliary.C_File_Access) return IOStream_Handle
     with Import, Convention=>C;

   function To_File_Handle (World: Raptor_World_Type_Without_Finalize'Class; File: RDF.Auxiliary.C_File_Access)
                              return Stream_Type_Without_Finalize is
   begin
      return From_Non_Null_Handle( raptor_new_iostream_to_file_handle (Get_Handle (World), File) );
   end;

   function raptor_iostream_hexadecimal_write (value: unsigned; width: int; Stream: IOStream_Handle) return int
     with Import, Convention=>C;

   procedure Hexadecimal_Write (Value: Natural; Width: Natural; Stream: Base_Stream_Type) is
   begin
      if raptor_iostream_hexadecimal_write(unsigned (Value), int(Width), Get_Handle (Stream)) < 0 then
         raise IOStream_Exception;
      end if;
   end;

   function raptor_iostream_read_bytes (Ptr: chars_ptr; size, nmemb: size_t; Stream: IOStream_Handle) return size_t
     with Import, Convention=>C;

   function Read_Bytes (Ptr: chars_ptr; size, nmemb: size_t; Stream: Base_Stream_Type) return size_t is
      Result: constant size_t := raptor_iostream_read_bytes (Ptr, size, nmemb, Get_Handle (Stream));
   begin
      if Result < 0 then
         raise IOStream_Exception;
      end if;
      return Result;
   end;

   function raptor_iostream_read_eof (Stream: IOStream_Handle) return int
     with Import, Convention=>C;

   function Read_Eof (Stream: Base_Stream_Type) return Boolean is
   begin
      return raptor_iostream_read_eof (Get_Handle (Stream)) /= 0;
   end;

   function raptor_iostream_tell (Stream: IOStream_Handle) return unsigned_long
     with Import, Convention=>C;

   function Tell (Stream: Base_Stream_Type) return unsigned_long is
   begin
      return raptor_iostream_tell (Get_Handle (Stream));
   end;

   function raptor_iostream_counted_string_write (str: char_array; len: size_t; Stream: IOStream_Handle) return unsigned_long
     with Import, Convention=>C;

   procedure Write (Value: String; Stream: Base_Stream_Type) is
   begin
      if raptor_iostream_counted_string_write (My_To_C_Without_Nul(Value), size_t (Value'Length), Get_Handle (Stream)) /= 0 then
         raise IOStream_Exception;
      end if;
   end;

   function raptor_iostream_decimal_write (Value: int; Stream: IOStream_Handle) return int
     with Import, Convention=>C;

   procedure Decimal_Write (Value: int; Stream: Base_Stream_Type) is
   begin
      if raptor_iostream_decimal_write (Value, Get_Handle (Stream)) < 0 then
         raise IOStream_Exception;
      end if;
   end;

   function raptor_iostream_write_byte (byte: int; Stream: IOStream_Handle) return int
     with Import, Convention=>C;

   procedure Write (Value: char; Stream: Base_Stream_Type) is
   begin
      if raptor_iostream_write_byte (char'Pos(Value), Get_Handle (Stream)) /= 0 then
         raise IOStream_Exception;
      end if;
   end;

   function raptor_iostream_write_bytes (Ptr: chars_ptr; size, nmemb: size_t; Stream: IOStream_Handle) return int
     with Import, Convention=>C;

   function Write_Bytes (Ptr: chars_ptr; size, nmemb: size_t; Stream: Base_Stream_Type) return int is
      Result: constant int := raptor_iostream_write_bytes (Ptr, size, nmemb, Get_Handle (Stream));
   begin
      if Result < 0 then
         raise IOStream_Exception;
      end if;
      return Result;
   end;

   function raptor_iostream_write_end (Stream: IOStream_Handle) return int
     with Import, Convention=>C;

   procedure Write_End (Stream: Base_Stream_Type) is
   begin
      if raptor_iostream_write_end (Get_Handle (Stream)) /= 0 then
         raise IOStream_Exception;
      end if;
   end;

   function raptor_bnodeid_ntriples_write (bnode: char_array; len: size_t; Stream: IOStream_Handle) return int
     with Import, Convention=>C;

   procedure Bnodeid_Ntriples_Write (bnode: String; Stream: Base_Stream_Type) is
   begin
      if raptor_bnodeid_ntriples_write (To_C (bnode, Append_Nul=>False), bnode'Length, Get_Handle (Stream)) /= 0 then
         raise IOStream_Exception;
      end if;
   end;

   function raptor_string_escaped_write (Str: char_array; Len: size_t; Delim: char; Flags: unsigned; Stream: IOStream_Handle) return int
     with Import, Convention=>C;

   procedure Escaped_Write (Value: String; Delim: Character; Flags: Escaped_Write_Bitflags.Bitflags; Stream: Base_Stream_Type) is
   begin
      if raptor_string_escaped_write (My_To_C_Without_Nul(Value), Value'Length, To_C (Delim), unsigned (Flags), Get_Handle (Stream)) /= 0 then
         raise IOStream_Exception;
      end if;
   end;

   function raptor_string_ntriples_write (Str: char_array; Len: size_t; Delim: char; Stream: IOStream_Handle) return int
     with Import, Convention=>C;

   procedure Ntriples_Write (Value: String; Delim: Character; Stream: Base_Stream_Type) is
   begin
      if raptor_string_ntriples_write (My_To_C_Without_Nul(Value), Value'Length, To_C (Delim), Get_Handle (Stream)) /= 0 then
         raise IOStream_Exception;
      end if;
   end;

   function raptor_string_python_write (ptr: char_array; len: size_t; delim: char; mode: Python_Write_Mode; Stream: IOStream_Handle) return int
     with Import, Convention=>C;

   procedure String_Python_Write (Value: String; Delim: Character; Mode: Python_Write_Mode; Stream: Base_Stream_Type) is
   begin
      if raptor_string_python_write (My_To_C_Without_Nul(Value), Value'Length, To_C (Delim), Mode, Get_Handle (Stream)) /= 0 then
         raise IOStream_Exception;
      end if;
   end;

   procedure raptor_free_iostream(Handle: IOStream_Handle)
     with Import, Convention=>C;

   procedure Finalize_Handle(Object: Stream_Type; Handle: IOStream_Handle) is
   begin
      raptor_free_iostream (Handle);
   end;

   type raptor_iostream_init_func is access function (context: chars_ptr) return int
      with Convention=>C;
   type raptor_iostream_finish_func is access procedure (context: chars_ptr)
      with Convention=>C;
   type raptor_iostream_write_byte_func is access function (context: chars_ptr; byte: int) return int
      with Convention=>C;
   type raptor_iostream_write_bytes_func is access function (context: chars_ptr; ptr: chars_ptr; size, nmemb: size_t) return int
      with Convention=>C;
   type raptor_iostream_write_end_func is access function (context: chars_ptr) return int
      with Convention=>C;
   type raptor_iostream_read_bytes_func is access function (context: chars_ptr; ptr: chars_ptr; size, nmemb: size_t) return int
      with Convention=>C;
   type raptor_iostream_read_eof_func is access function (context: chars_ptr) return int
      with Convention=>C;

   type Dispatcher_Type is
      record
         version    : int := 2;
         -- V1 functions
         init       : raptor_iostream_init_func   := null;
         finish     : raptor_iostream_finish_func := null;
         write_byte : raptor_iostream_write_byte_func;
         write_bytes: raptor_iostream_write_bytes_func;
         write_end  : raptor_iostream_write_end_func;
         -- V2 functions
         read_bytes : raptor_iostream_read_bytes_func;
         read_eof   : raptor_iostream_read_eof_func;
      end record
         with Convention=>C;

   type User_Defined_Access is access all User_Defined_Stream_Type'Class;
   function Ptr_To_Obj is new Ada.Unchecked_Conversion(chars_ptr, User_Defined_Access);
   function Obj_To_Ptr is new Ada.Unchecked_Conversion(User_Defined_Access, chars_ptr);

--     function raptor_iostream_init_impl (context: chars_ptr) return int
--        with Convention=>C;
--     procedure raptor_iostream_finish_impl (context: chars_ptr)
--        with Convention=>C;
   function raptor_iostream_write_byte_impl (context: chars_ptr; byte: int) return int
      with Convention=>C;
   function raptor_iostream_write_bytes_impl (context: chars_ptr; ptr: chars_ptr; size, nmemb: size_t) return int
      with Convention=>C;
   function raptor_iostream_write_end_impl (context: chars_ptr) return int
      with Convention=>C;
   function raptor_iostream_read_bytes_impl (context: chars_ptr; ptr: chars_ptr; size, nmemb: size_t) return int
      with Convention=>C;
   function raptor_iostream_read_eof_impl (context: chars_ptr) return int
      with Convention=>C;

   function raptor_iostream_write_byte_impl (context: chars_ptr; byte: int) return int is
   begin
      Do_Write_Byte (Ptr_To_Obj (context).all, char'Val(byte));
      return 0;
   exception
      when others =>
         return 1;
   end;

   function raptor_iostream_write_bytes_impl (context: chars_ptr; ptr: chars_ptr; size, nmemb: size_t) return int is
      Result: constant int := Do_Write_Bytes (Ptr_To_Obj (context).all, ptr, size, nmemb);
   begin
      return Result;
   exception
      when others =>
         return -1;
   end;

   function raptor_iostream_write_end_impl (context: chars_ptr) return int is
   begin
      Do_Write_End (Ptr_To_Obj (context).all);
      return 0;
   exception
      when others =>
         return 1;
   end;

   function raptor_iostream_read_bytes_impl (context: chars_ptr; ptr: chars_ptr; size, nmemb: size_t) return int is
      Ret: constant size_t := Do_Read_Bytes (Ptr_To_Obj (context).all, ptr, size, nmemb);
   begin
      return int(Ret);
   exception
      when others =>
         return -1;
   end;

   function raptor_iostream_read_eof_impl (context: chars_ptr) return int is
   begin
      return (if Do_Read_Eof (Ptr_To_Obj (context).all) then 1 else 0);
   end;

   Dispatch: aliased constant Dispatcher_Type :=
     (version => 2,
      init => null,
      finish => null,
      write_byte => raptor_iostream_write_byte_impl'Access,
      write_bytes=> raptor_iostream_write_bytes_impl'Access,
      write_end  => raptor_iostream_write_end_impl'Access,
      read_bytes => raptor_iostream_read_bytes_impl'Access,
      read_eof   => raptor_iostream_read_eof_impl'Access);

   function raptor_new_iostream_from_handler(world: Raptor_World_Handle;
                                               user_data: chars_ptr;
                                               Dispatcher: access constant Dispatcher_Type)
                                               return IOStream_Handle
     with Import, Convention=>C;

   function Open (World: Raptor_World_Type_Without_Finalize'Class) return User_Defined_Stream_Type is
      Handle: IOStream_Handle;
      use all type Raptor_World_Type;
   begin
      return Stream: User_Defined_Stream_Type do
         Handle := raptor_new_iostream_from_handler (Get_Handle (World),
                                                       Obj_To_Ptr (User_Defined_Stream_Type'Class(Stream)'Unchecked_Access),
                                                       Dispatch'Access);
         Set_Handle_Hack (Stream, Handle);
      end return;
   end;

   procedure Do_Write_Byte (Stream: in out User_Defined_Stream_Type; Byte: char) is
      Byte2: aliased char_array := (1=>Byte);
   begin
      if Do_Write_Bytes (Stream, To_Chars_Ptr (Byte2'Unchecked_Access), 1, 1) /= 1 then
         raise IOStream_exception;
      end if;
   end;

   function Do_Write_Bytes (Stream: in out User_Defined_Stream_Type; Data: chars_ptr; Size, Count: size_t) return int is
   begin
      raise Program_Error;
      return 0;
   end;

   procedure Do_Write_End (Stream: in out User_Defined_Stream_Type) is
   begin
      raise Program_Error;
   end;

   function Do_Read_Bytes (Stream: in out User_Defined_Stream_Type; Data: chars_ptr; Size, Count: size_t) return size_t is
   begin
      raise Program_Error;
      return 0;
   end;

   function Do_Read_Eof (Stream: in out User_Defined_Stream_Type) return Boolean is
   begin
      raise Program_Error;
      return False;
   end;

   function From_Handle(Handle: IOStream_Handle) return Stream_From_String is
   begin
      raise Program_Error;
      return (Base_Stream_Type'(From_Handle (Handle)) with Length=>0, Str=>"");
   end;

   function From_Non_Null_Handle(Handle: IOStream_Handle) return Stream_From_String is
   begin
      raise Program_Error;
      return (Base_Stream_Type'(From_Handle (Handle)) with Length=>0, Str=>"");
   end;

   function raptor_new_iostream_from_string (World: Raptor_World_Handle; str: char_array; length: size_t) return IOStream_Handle
     with Import, Convention=>C;

   function Open_From_String (World: Raptor_World_Type_Without_Finalize'Class; Value: String) return Stream_From_String is
   begin
      return Stream: Stream_From_String(Value'Length) do
         Stream.Str := My_To_C_Without_Nul(Value);
         Set_Handle_Hack (Stream, raptor_new_iostream_from_string (Get_Handle (World), Stream.Str, Value'Length));
      end return;
   end;

   function From_Handle(Handle: IOStream_Handle) return Stream_To_String is
   begin
      raise Program_Error;
      return (Base_Stream_Type'(From_Handle (Handle)) with Str=>Ada.Strings.Unbounded.Null_Unbounded_String);
   end;

   function From_Non_Null_Handle(Handle: IOStream_Handle) return Stream_To_String is
   begin
      raise Program_Error;
      return (Base_Stream_Type'(From_Handle (Handle)) with Str=>Ada.Strings.Unbounded.Null_Unbounded_String);
   end;

   function Open (World: Raptor_World_Type_Without_Finalize'Class) return Stream_To_String is
   begin
      return (User_Defined_Stream_Type'(Open (World)) with Str=>Ada.Strings.Unbounded.Null_Unbounded_String);
   end;

   function Value (Stream: Stream_To_String) return String is
   begin
      return To_String (Stream.Str);
   end;

   function Do_Write_Bytes (Stream: in out Stream_To_String; Data: chars_ptr; Size, Count: size_t) return int is
   begin
      Append(Stream.Str, Value (Data, Size*Count));
      return int(Size*Count);
   end;

   function raptor_term_escaped_write (Term: RDF.Raptor.Term.Term_Handle; Flags: unsigned; Stream: IOStream_Handle) return int
     with Import, Convention=>C;

   procedure Term_Escaped_Write (Term: RDF.Raptor.Term.Term_Type_Without_Finalize'Class; Flags: Escaped_Write_Bitflags.Bitflags; Stream: Base_Stream_Type) is
      use Term_Handled_Record;
      use type Term_Handled_Record.Base_Object;
   begin
      if raptor_term_escaped_write(Get_Handle(Term), Unsigned(Flags), Get_Handle(Stream)) /= 0 then
         raise IOStream_Exception;
      end if;
   end;

   function raptor_uri_escaped_write (URI, Base_URI: URI_Handle; Flags: unsigned; Stream: IOStream_Handle) return int
     with Import, Convention=>C;

   procedure URI_Escaped_Write (URI, Base_URI: URI_Type_Without_Finalize'Class; Flags: Escaped_Write_Bitflags.Bitflags; Stream: Base_Stream_Type) is
   begin
      if raptor_uri_escaped_write(Get_Handle(URI), Get_Handle(Base_URI), Unsigned(Flags), Get_Handle(Stream)) /= 0 then
         raise IOStream_Exception;
      end if;
   end;

end RDF.Raptor.IOStream;
