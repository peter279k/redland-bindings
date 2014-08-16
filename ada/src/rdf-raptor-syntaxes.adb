with Ada.Unchecked_Conversion;
with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;
with Interfaces.C.Pointers;
with RDF.Raptor.World; use RDF.Raptor.World;

package body RDF.Raptor.Syntaxes is

   package String_Ptrs is new Interfaces.C.Pointers(size_t, chars_ptr, chars_ptr_array, Null_Ptr);

   use String_Ptrs;

   Mime_Type_Q_Default: constant Mime_Type_Q := Mime_Type_Q'(Mime_Type=>Null_Ptr, Mime_Type_Len=>0, Q=>0); -- hack
   type Mime_Type_Q_Array is array (size_t range <>) of aliased Mime_Type_Q;
   package Mime_Type_Q_Ptrs is new Interfaces.C.Pointers(size_t, Mime_Type_Q, Mime_Type_Q_Array, Mime_Type_Q_Default);

   use Mime_Type_Q_Ptrs;

   use String_Ptrs;

   function Get_MIME_Type (Object: Mime_Type_Q) return String is
   begin
      return Value(Object.Mime_Type, Object.Mime_Type_Len);
   end;

   function Get_Q (Object: Mime_Type_Q) return Q_Type is (Q_Type(Object.Q));

   function Get_Name (Object: Syntax_Description_Type; Index: Natural) return String is
      Ptr: constant access chars_ptr := Object.Names + ptrdiff_t(Index);
   begin
      return Value(Ptr.all);
   end;

   function Get_Names_Count (Object: Syntax_Description_Type) return Natural is (Natural(Object.Names_Count));

   function Get_Label (Object: Syntax_Description_Type) return String is
   begin
      return Value(Object.Label);
   end;

   function Get_MIME_Type (Object: Syntax_Description_Type; Index: Natural) return Mime_Type_Q is
      Ptr: constant access Mime_Type_Q := Object.Mime_Types + ptrdiff_t(Index);
   begin
      return Ptr.all;
   end;

   function Get_MIME_Types_Count (Object: Syntax_Description_Type) return Natural is (Natural(Object.Mime_Types_Count));

   function Get_URI (Object: Syntax_Description_Type; Index: Natural) return String is
      Ptr: constant access chars_ptr := Object.URI_Strings + ptrdiff_t(Index);
   begin
      return Value(Ptr.all);
   end;

   function Get_URIs_Count (Object: Syntax_Description_Type) return Natural is (Natural(Object.URI_Strings_Count));

   function Get_Flags (Object: Syntax_Description_Type) return Syntax_Bitflags is
     function Conv is new Ada.Unchecked_Conversion(Int, Syntax_Bitflags);
   begin
      return Conv(Object.Flags);
   end;

   function C_Raptor_World_Is_Parser_Name(World: RDF.Raptor.World.Handle_Type; Name: char_array) return int
     with Import, Convention=>C, External_Name=>"raptor_world_is_parser_name";

   function Is_Parser_Name (World: World_Type_Without_Finalize'Class; Name: String) return Boolean is
   begin
      return C_Raptor_World_Is_Parser_Name(Get_Handle(World), To_C(Name, Append_Nul=>True)) /= 0;
   end;

   function C_Raptor_World_Guess_Parser_Name (World: RDF.Raptor.World.Handle_Type;
                                              URI: RDF.Raptor.URI.Handle_Type;
                                              MIME_Type: Char_Array;
                                              Buffer: Char_Array;
                                              Len: Size_T;
                                              Identifier: Char_Array) return chars_ptr
     with Import, Convention=>C, External_Name=>"raptor_world_guess_parser_name";


   function Guess_Parser_Name (World: World_Type_Without_Finalize'Class; URI: URI_Type; MIME_Type: String; Buffer: String; Identifier: String)
                               return String is
   begin
      return Value( C_Raptor_World_Guess_Parser_Name(Get_Handle(World),
                                                     Get_Handle(URI),
                                                     To_C(MIME_Type, Append_Nul=>True),
                                                     To_C(Buffer, Append_Nul=>False),
                                                     size_t(Buffer'Length),
                    To_C(Identifier, Append_Nul=>True)) );
   end;

   function C_Raptor_World_Is_Serializer_Name(World: RDF.Raptor.World.Handle_Type; Name: char_array) return int
     with Import, Convention=>C, External_Name=>"raptor_world_is_serializer_name";

   function Is_Serializer_Name (World: World_Type_Without_Finalize'Class; Name: String) return Boolean is
   begin
      return C_Raptor_World_Is_Serializer_Name(Get_Handle(World), To_C(Name, Append_Nul=>True)) /= 0;
   end;

end RDF.Raptor.Syntaxes;
