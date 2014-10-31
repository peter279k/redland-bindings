with RDF.Auxiliary.Handled_Record;
with RDF.Raptor.World; use RDF.Raptor.World;
with RDF.Raptor.IOStream;
limited with RDF.Raptor.Namespaces_Stacks;

package RDF.Raptor.URI is

   type URI_String is new String;

   package Handled_Record is new RDF.Auxiliary.Handled_Record(RDF.Auxiliary.Dummy_Record);

   subtype Handle_Type is Handled_Record.Access_Type;

   -- Only absolute URIs!
   type URI_Type_Without_Finalize is new Handled_Record.Base_Object with null record;

   not overriding function Compare(URI1, URI2: URI_Type_Without_Finalize) return RDF.Auxiliary.Comparison_Result;

   not overriding function Equals(URI1, URI2: URI_Type_Without_Finalize) return Boolean;

   overriding function "="(URI1, URI2: URI_Type_Without_Finalize) return Boolean renames Equals;

   not overriding function To_String(URI: URI_Type_Without_Finalize) return URI_String;

   not overriding function To_Relative_URI_String(Base_URI, Reference_URI: URI_Type_Without_Finalize) return URI_String;

   function Resolve_URI_Reference (Base_URI, Reference_URI: String) return URI_String;

   function Filename_To_URI_String (Filename: String) return URI_String;

   function URI_String_Is_Absolute (Str: URI_String) return Boolean;

   function URI_String_Is_File_URI (Str: URI_String) return Boolean;

   -- ignores the fragment
   function URI_String_To_Filename (Str: URI_String) return String;

   type Filename_And_Fragment(<>) is private;

   function Get_Filename (Pair: Filename_And_Fragment) return String;
   function Get_Fragment (Pair: Filename_And_Fragment) return String;

   function URI_String_To_Filename_And_Fragment(Str: URI_String) return Filename_And_Fragment;

   -- Not supposed to be used, but included for completeness
   not overriding procedure Print (URI: URI_Type_Without_Finalize; File: RDF.Auxiliary.C_File_Access);

   not overriding function Get_World (URI: URI_Type_Without_Finalize) return World_Type_Without_Finalize;

   not overriding procedure Write (URI: URI_Type_Without_Finalize; Stream: RDF.Raptor.IOStream.Base_Stream_Type'Class);

   not overriding function URI_File_Exists (URI: URI_Type_Without_Finalize) return Boolean;

   function Filename_Exists (Filename: String) return Boolean;

   not overriding function To_Turtle_String (World: World_Type_Without_Finalize'Class;
                                             URI: URI_Type_Without_Finalize;
                                             Stack: RDF.Raptor.Namespaces_Stacks.Namespace_Stack_Type_Without_Finalize'Class;
                                             Base_URI: URI_Type_Without_Finalize)
                                             return String;

   not overriding procedure Turtle_Write (World: World_Type_Without_Finalize'Class;
                                          Stream: RDF.Raptor.IOStream.Stream_Type_Without_Finalize'Class;
                                          URI: URI_Type_Without_Finalize;
                                          Stack: RDF.Raptor.Namespaces_Stacks.Namespace_Stack_Type_Without_Finalize'Class;
                                          Base_URI: URI_Type_Without_Finalize);

   not overriding function Copy (Object: URI_Type_Without_Finalize'Class) return URI_Type_Without_Finalize;

   type URI_Type is new URI_Type_Without_Finalize with null record;

   overriding procedure Adjust(Object: in out URI_Type);

   overriding procedure Finalize_Handle(Object: URI_Type; Handle: Handle_Type);

   not overriding function From_String(World: World_Type_Without_Finalize'Class; Arg: URI_String) return URI_Type;

   not overriding function From_URI_With_Local_Name(World: World_Type_Without_Finalize'Class; URI: URI_Type_Without_Finalize'Class; Local_Name: String) return URI_Type;

   not overriding function From_URI_Or_File_String(World: World_Type_Without_Finalize'Class;
                                                   Base_URI: URI_Type_Without_Finalize'Class;
                                                   uri_or_file: String)
                                                   return URI_Type;

   not overriding function From_URI_Relative_To_Base(World: World_Type_Without_Finalize'Class;
                                                     Base_URI: URI_Type_Without_Finalize'Class;
                                                     URI: URI_String)
                                                     return URI_Type;

   not overriding function From_ID(World: World_Type_Without_Finalize'Class; Base_URI: URI_Type_Without_Finalize'Class; ID: String) return URI_Type;

   not overriding function From_RDF_Concept(World: World_Type_Without_Finalize'Class; Name: String) return URI_Type;

   not overriding function For_XML_Base(Old_URI: URI_Type_Without_Finalize'Class) return URI_Type;

   not overriding function For_Retrieval(Old_URI: URI_Type_Without_Finalize'Class) return URI_Type;

   -- null
   --overriding function Default_Handle(Object: URI_Type) return Handle_Type;

private

   type Filename_And_Fragment (Filename_Length, Fragment_Length: Natural) is
      record
         Filename: String(1..Filename_Length);
         Fragment: String(1..Fragment_Length);
      end record;

end RDF.Raptor.URI;
