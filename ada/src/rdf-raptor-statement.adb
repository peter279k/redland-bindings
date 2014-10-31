with Ada.Tags;
with RDF.Raptor.Term;
with Interfaces.C; use Interfaces.C;
with RDF.Raptor.IOStream; use RDF.Raptor.IOStream;

package body RDF.Raptor.Statement is

   use RDF.Raptor.World;
   use RDF.Raptor.Term;

   function Get_World (Statement: Statement_Type_Without_Finalize) return RDF.Raptor.World.World_Type_Without_Finalize is
   begin
--        return Get_Handle(Statement).World.all; -- does not work, so the below hack:
      return S: RDF.Raptor.World.World_Type_Without_Finalize do
         Set_Handle_Hack(S, Get_Handle(Statement).World);
      end return;
   end;

   function Get_Subject   (Statement: Statement_Type_Without_Finalize) return RDF.Raptor.Term.Term_Type_Without_Finalize is (From_Handle(Get_Handle(Statement).Subject));
   function Get_Predicate (Statement: Statement_Type_Without_Finalize) return RDF.Raptor.Term.Term_Type_Without_Finalize is (From_Handle(Get_Handle(Statement).Predicate));
   function Get_Object    (Statement: Statement_Type_Without_Finalize) return RDF.Raptor.Term.Term_Type_Without_Finalize is (From_Handle(Get_Handle(Statement).Object));
   function Get_Graph     (Statement: Statement_Type_Without_Finalize) return RDF.Raptor.Term.Term_Type_Without_Finalize is (From_Handle(Get_Handle(Statement).Graph)); -- may return null handle

--     function No_Auto_Finalization (Term: RDF.Raptor.Term.Term_Type_Without_Finalize'Class) return Boolean is
--     begin
--        return Is_Null(Term) or not (Term in RDF.Raptor.Term.Term_Type'Class);
--     end;

   function C_Raptor_New_Statement (World: RDF.Raptor.World.Handle_Type)
                                                  return Statement_Handle
     with Import, Convention=>C, External_Name=>"raptor_new_statement";

--     function New_Statement (World: RDF.Raptor.World.World_Type_Without_Finalize) return Statement_Type is
--     begin
--        return From_Non_Null_Handle( C_Raptor_New_Statement(Get_Handle(World)) );
--     end;

   function C_Raptor_New_Statement_From_Nodes (World: RDF.Raptor.World.Handle_Type; Subject, Predicate, Object, Graph: RDF.Raptor.Term.Term_Handle)
                                               return Statement_Handle
     with Import, Convention=>C, External_Name=>"raptor_new_statement_from_nodes";

   function New_Statement (World: RDF.Raptor.World.World_Type_Without_Finalize'Class;
                           Subject, Predicate, Object: RDF.Raptor.Term.Term_Type_Without_Finalize'Class;
                           Graph: RDF.Raptor.Term.Term_Type_Without_Finalize'Class := RDF.Raptor.Term.Term_Type_Without_Finalize'(From_Handle(null)))
                           return Statement_Type is
   begin
      return New_Statement_Without_Copies(World, Copy(Subject), Copy(Predicate), Copy(Object), Copy(Graph));
   end;

   function New_Statement_Without_Copies (World: RDF.Raptor.World.World_Type_Without_Finalize'Class;
                                          Subject, Predicate, Object: RDF.Raptor.Term.Term_Type_Without_Finalize;
                                          Graph: RDF.Raptor.Term.Term_Type_Without_Finalize := From_Handle(null))
                                          return Statement_Type is
   begin
      return From_Non_Null_Handle( C_Raptor_New_Statement_From_Nodes(Get_Handle(World),
                                                                     Get_Handle(Subject), Get_Handle(Predicate), Get_Handle(Object), Get_Handle(Graph)) );
   end;

   procedure C_Raptor_Free_Statement (Statement: Statement_Handle)
      with Import, Convention=>C, External_Name=>"raptor_free_statement";

   procedure Finalize_Handle (Object: Statement_Type; Handle: Statement_Handle) is
   begin
      C_Raptor_Free_Statement(Handle);
   end;

   function C_Raptor_Statement_Copy (Term: Statement_Handle) return Statement_Handle
      with Import, Convention=>C, External_Name=>"raptor_statement_copy";

   procedure Adjust (Object: in out Statement_Type) is
   begin
      Set_Handle_Hack(Object, C_Raptor_Statement_Copy(Get_Handle(Object)));
   end;

   function Copy (Object: Statement_Type_Without_Finalize'Class) return Statement_Type_Without_Finalize is
   begin
      return From_Handle (C_Raptor_Statement_Copy (Get_Handle(Object)) );
   end;

   function C_Raptor_Statement_Compare (Left, Right: Statement_Handle) return int
      with Import, Convention=>C, External_Name=>"raptor_statement_compare";

   function Compare (Left, Right: Statement_Type_Without_Finalize) return RDF.Auxiliary.Comparison_Result is
   begin
      return RDF.Auxiliary.Sign( C_Raptor_Statement_Compare(Get_Handle(Left), Get_Handle(Right)) );
   end;

   function C_Raptor_Statement_Equals (Left, Right: Statement_Handle) return int
      with Import, Convention=>C, External_Name=>"raptor_statement_equals";

   function Equals (Left, Right: Statement_Type_Without_Finalize) return Boolean is
   begin
      return C_Raptor_Statement_Equals(Get_Handle(Left), Get_Handle(Right)) /= 0;
   end;

   function C_Raptor_Statement_Print (Statement: Statement_Handle; File: RDF.Auxiliary.C_File_Access) return int
      with Import, Convention=>C, External_Name=>"raptor_statement_print";

   procedure Print (Statement: Statement_Type_Without_Finalize; File: RDF.Auxiliary.C_File_Access) is
   begin
      if C_Raptor_Statement_Print(Get_Handle(Statement), File) /= 0 then
         raise RDF.Raptor.IOStream.IOStream_Exception;
      end if;
   end;

   function C_Raptor_Statement_Print_As_Ntriples (Statement: Statement_Handle; File: RDF.Auxiliary.C_File_Access) return int
      with Import, Convention=>C, External_Name=>"raptor_statement_print_as_ntriples";

   procedure Print_As_Ntriples (Statement: Statement_Type_Without_Finalize; File: RDF.Auxiliary.C_File_Access) is
   begin
      if C_Raptor_Statement_Print_As_Ntriples(Get_Handle(Statement), File) /= 0 then
         raise RDF.Raptor.IOStream.IOStream_Exception;
      end if;
   end;

   function C_Raptor_Statement_Ntriples_Write (Statement: Statement_Handle; Stream: RDF.Raptor.IOStream.Handle_Type; Write_Graph_Term: int)
                                               return Int
      with Import, Convention=>C, External_Name=>"raptor_statement_ntriples_write";

   procedure Ntriples_Write (Statement: Statement_Type_Without_Finalize;
                             Stream: RDF.Raptor.IOStream.Stream_Type_Without_Finalize'Class;
                             Write_Graph_Term: Boolean) is
      Flag: constant int := (if Write_Graph_Term then 1 else 0);
   begin
      if C_Raptor_Statement_Ntriples_Write(Get_Handle(Statement), Get_Handle(Stream), Flag) /= 0 then
         raise RDF.Raptor.IOStream.IOStream_Exception;
      end if;
   end;

end RDF.Raptor.Statement;
