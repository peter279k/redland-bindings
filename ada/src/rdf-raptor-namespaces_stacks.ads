with RDF.Auxilary.Limited_Handled_Record;
with RDF.Raptor.URI; use RDF.Raptor.URI;
with Interfaces.C;
with RDF.Raptor.World;
with RDF.Auxilary; use RDF.Auxilary;
limited with RDF.Raptor.Namespaces;

package RDF.Raptor.Namespaces_Stacks is

   package Namespace_Stack_Handled_Record is new RDF.Auxilary.Limited_Handled_Record(RDF.Auxilary.Dummy_Record);

   subtype Namespace_Stack_Handle_Type is Namespace_Stack_Handled_Record.Access_Type;

   type Namespace_Stack_Type_Without_Finalize is new Namespace_Stack_Handled_Record.Base_Object with null record;

   not overriding procedure Clear (Stack: Namespace_Stack_Type_Without_Finalize);

   -- See also below
   not overriding procedure Start_Namespace (Stack: Namespace_Stack_Type_Without_Finalize; Namespace: RDF.Raptor.Namespaces.Namespace_Type'Class);

   not overriding procedure Start_Namespace (Stack: Namespace_Stack_Type_Without_Finalize;
                                             Prefix: String_Holders.Holder;
                                             NS_URI: String_Holders.Holder;
                                             Depth: Natural);

   not overriding procedure End_For_Depth (Stack: Namespace_Stack_Type_Without_Finalize; Depth: Natural);

   not overriding function Get_Default_Namespace (Stack: Namespace_Stack_Type_Without_Finalize) return RDF.Raptor.Namespaces.Namespace_Type;

   not overriding function Find_Namespace (Stack: Namespace_Stack_Type_Without_Finalize; Prefix: String) return RDF.Raptor.Namespaces.Namespace_Type;

   not overriding function Find_Default_Namespace (Stack: Namespace_Stack_Type_Without_Finalize) return RDF.Raptor.Namespaces.Namespace_Type;

   not overriding function Find_Namespace_By_URI (Stack: Namespace_Stack_Type_Without_Finalize; URI: URI_Type_Without_Finalize'Class)
                                                  return RDF.Raptor.Namespaces.Namespace_Type;

   not overriding function In_Scope (Stack: Namespace_Stack_Type_Without_Finalize; NS: RDF.Raptor.Namespaces.Namespace_Type'Class)
                                     return Boolean;

   not overriding procedure Start_Namespace (Stack: Namespace_Stack_Type_Without_Finalize; NS: RDF.Raptor.Namespaces.Namespace_Type_Without_Finalize'Class; New_Depth: Natural);

   type Namespace_Stack_Type is new Namespace_Stack_Type_Without_Finalize with null record;

   overriding procedure Finalize_Handle(Object: Namespace_Stack_Type; Handle: Namespace_Stack_Handle_Type);

   type Defaults_Type is (None_Type, XML_Type, RDF_Type, Undefined_Type)
      with Convention => C;
   for Defaults_Type use (None_Type=>0, XML_Type=>1, RDF_Type=>2, Undefined_Type=>3);

   not overriding function Create_Stack (World: RDF.Raptor.World.World_Type_Without_Finalize'Class; Defaults: Defaults_Type)
                                         return Namespace_Stack_Type;

   -- raptor_namespaces_init() not bound (it seems that function is internal for Raptor implementation).

end RDF.Raptor.Namespaces_Stacks;
